;Lot Label program
;;; ==========================================================================
;;; LOTLABEL.LSP
;;; Resolutions
;;; P.O. Box 1265
;;; Sumner, WA 98390-0250
;;; (206) 845-2200
;;; 
;;; Notes	 :	Written for Hugh G. Goldsmith & Associates
;;; 
;;; Date	 :	9/5/96
;;; 
;;; Revisions:  10/15/96 v1.01  Added support for DVIEW Twist.
;;;                             If BPOLY fails let user select boundary.
;;;             9/11/97  v1.1   Added support for R14.
;;;		2/20/03  v1.2   Added support for A2000 ; Paul Kohut
;;; 
;;; ==========================================================================
(defun C:LOTLABEL (/  ; Local functions and variables

; Functions
		val rtod PolyLabel GetBulgeLength LabelLine LabelArc RunBoundary

; Local variables
		angbase angdir clayer dp old_err osmode pt txtht KeepBoundary
		boundary twist

	)

	(defun val (nr e) (cdr (assoc nr e)))
	(defun rtod (x)(* x (/ 180.0 pi)))

;; Returns the Boundary ename if successful
(defun RunBoundary (pt / lastent hpbound)
	(setq hpbound (getvar "HPBOUND"))
	(setvar "HPBOUND" 1)
	(setq lastent (entlast))
	(command "._-BOUNDARY" pt "")
	(setvar "HPBOUND" hpbound)
	(if (equal lastent (entlast))
		nil
		(entlast)
	)
)

;; --- Setup ---
	(setvar "cmdecho" 0)
	(setq osmode (getvar "OSMODE"))
	(setvar "OSMODE" 0)
	(setq clayer (getvar "CLAYER"))
	(setq angbase (getvar "ANGBASE"))
	(setq angdir (getvar "ANGDIR"))
	(setq txtht (val 40 (tblsearch "style" (getvar "TEXTSTYLE"))))
	(if (= txtht 0)
		(progn
			(initget 6)
			(setq txtht (getreal "\nLabel Text height: "))
		)
	)
	(initget 4)
	(setq dp (getint "\nNumber of decimal places <0>: "))
	(if (null dp)
		(setq dp 0)
	)
	(initget "Yes No")
	(setq KeepBoundary (getkword "\nRetain Lot Boundary? (Yes/<No>): "))
	(if (null KeepBoundary)
		(setq KeepBoundary "No")
	)
	(if (null (setq twist (getangle "\nDVIEW Twist Angle: <0.00> ")))
		(setq twist 0.0)
	)

;; --- ERROR handler ---
	(setq old_err *error*)
	;; --- If cancelled reset UCS to WORLD ---
	(defun-q *error* (msg)
		(setvar "CMDECHO" 0)
		(setvar "OSMODE" osmode)
		(princ (strcat "\nError: " msg ".\n"))
		(command "._UCS" "_W")
		(setq *error* old_err)
		(princ)
	)
;;; ==========================================================================
;;; Function: PolyLabel
;;; Purpose : Step through a PLINE and call the LINE or ARC labelling routines
;;;
;;; --------------------------------------------------------------------------
(defun PolyLabel (ent pt / e start_pt p1 p2 arc_info)
	(setq e (entget ent))
	(setq
		ent (entnext (val -1 e))
		e (entget ent)
		start_pt (val 10 e)
	)
	(while (/= (val 0 (entget (entnext ent))) "SEQEND")
		(setq
			p1 (val 10 e)
			p2 (val 10 (entget (entnext ent)))
		)
		(if (> (distance p1 p2) 0.001)
			(if (zerop (val 42 e))
				(LabelLine p1 p2 (rtos (distance p1 p2) 2 dp) pt)
				(progn
					(setq arc_info (GetBulgeLength p1 (val 42 e) p2))
					(LabelArc p1 p2 (car arc_info) (rtos (cadr arc_info) 2 dp) pt)
				)
			)
		)
		(setq ent (entnext ent) e (entget ent))
	)
	;; --- Last segment is the closeur ---
	(setq
		p1 (val 10 e)
		p2 start_pt
	)
	(if (> (distance p1 p2) 0.001)
		(if (zerop (val 42 e))
			(LabelLine p1 p2 (rtos (distance p1 p2) 2 dp) pt)
			(progn
				(setq arc_info (GetBulgeLength p1 (val 42 e) p2))
				(LabelArc p1 p2 (car arc_info) (rtos (cadr arc_info) 2 dp) pt)
			)
		)
	)
)
;;; ==========================================================================
;;; Function: GetBulgeLength
;;; Purpose : Calculate the length for a PLINE ARC & Center point
;;;
;;; --------------------------------------------------------------------------
(defun GetBulgeLength (p1 bulge p2 / anga rad chord inang chordang ang)
	(setq inang (* 4 (atan bulge)))
	(setq anga (- (/ pi 2) (/ inang 2)))
	(setq chord (distance p1 p2))
	(setq rad (/ (/ chord 2) (cos anga)))
	(setq chordang (angle p1 p2))
	(if (minusp chordang)
		(setq ang (- chordang anga))
		(setq ang (+ chordang anga))
	)
	(list (polar p1 ang rad) (* rad inang))
)
;;; ==========================================================================
;;; Function: LabelLine
;;; Purpose : Label the Pline Line segment
;;; Params  : p1...........start point
;;;		      p2...........end point
;;;		      label........label to place
;;;		      inside_pt....point inside the PolyLine
;;;
;;; --------------------------------------------------------------------------
(defun LabelLine (p1 p2 label inside_pt / pt pt1 pt2 a1 a2 dist ang midpt ent_pt TextAngle)
	(setq
		ang (angle p1 p2)
		dist (distance p1 p2)
		midpt (polar p1 ang (/ dist 2.0))
	)
	(setq a1
		(cond
			((> ang (* 1.5 pi)) ang)
			((> ang pi) (- ang pi))
			((> ang (* 0.5 pi)) (+ ang pi))
			(T ang)
		)
	)
	(setq pt1 (polar midpt (- a1 (* 0.5 pi)) txtht))
	(setq pt2 (polar midpt (+ a1 (* 0.5 pi)) txtht))
	(if (< (distance inside_pt pt1)(distance inside_pt pt2))
		(setq pt pt1)
		(setq pt pt2 pt2 pt1)
	)
	;; --- Calculate TEXT angle taking into account any DVIEW Twist ---
	(setq a2 (+ ang twist))
	(if (> a2 (* 2 pi))
		(setq a2 (- a2 (* 2 pi)))
	)
	(setq a1
		(cond
			((> a2 (* 1.5 pi)) ang)
			((> a2 pi) (- ang pi))
			((> a2 (* 0.5 pi)) (+ ang pi))
			(T ang)
		)
	)
	;; --- Only place label if TEXT is not there ---
	(if (not (and
			(setq ent_pt (nentselp pt2))
			(setq e (entget (car ent_pt)))
			(= (val 0 e) "TEXT")
			(= (val 8 e) (getvar "CLAYER"))
			(= (val 7 e) (getvar "TEXTSTYLE"))
		))
		(progn
			(if (zerop angdir)
				(setq TextAngle (rtod (- a1 angbase)))
				(setq TextAngle (- 360 (rtod (- a1 angbase))))
			)
			(if (> (val 40 (tblsearch "style" (getvar "TEXTSTYLE"))) 0)
				(command "._TEXT" "M" pt TextAngle label)
				(command "._TEXT" "M" pt txtht TextAngle label)
			)
		)
	)
)
;;; ==========================================================================
;;; Function: LabelArc
;;; Purpose : Label the Pline Arc segment
;;; Params  : p1...........start point
;;;		      p2...........end point
;;;		      cen..........center point
;;;		      label........label to place
;;;		      inside_pt....point inside the PolyLine
;;;
;;; --------------------------------------------------------------------------
(defun LabelArc (p1 p2 cen label inside_pt / pt pt1 pt2 a1 a2 a3 ang midpt ent_pt rad TextAngle)
	(setq
		ang (angle p1 p2)
		rad (distance p1 cen)
		midpt (polar p1 ang (/ (distance p1 p2) 2.0))
		a3 (angle cen midpt)
	)
	(setq a1
		(cond
			((> ang (* 1.5 pi)) ang)
			((> ang pi) (- ang pi))
			((> ang (* 0.5 pi)) (+ ang pi))
			(T ang)
		)
	)
	(setq pt1 (polar cen a3 (- rad txtht)))
	(setq pt2 (polar cen a3 (+ rad txtht)))
	(if (< (distance inside_pt pt1)(distance inside_pt pt2))
		(setq pt pt1)
		(setq pt pt2 pt2 pt1)
	)
	;; --- Calculate TEXT angle taking into account any DVIEW Twist ---
	(setq a2 (+ ang twist))
	(if (> a2 (* 2 pi))
		(setq a2 (- a2 (* 2 pi)))
	)
	(setq a1
		(cond
			((> a2 (* 1.5 pi)) ang)
			((> a2 pi) (- ang pi))
			((> a2 (* 0.5 pi)) (+ ang pi))
			(T ang)
		)
	)
	(if (not (and
			(setq ent_pt (nentselp pt2))
			(setq e (entget (car ent_pt)))
			(= (val 0 e) "TEXT")
			(= (val 8 e) (getvar "CLAYER"))
			(= (val 7 e) (getvar "TEXTSTYLE"))
		))
		(progn
			(if (zerop angdir)
				(setq TextAngle (rtod (- a1 angbase)))
				(setq TextAngle (- 360 (rtod (- a1 angbase))))
			)
			(if (> (val 40 (tblsearch "style" (getvar "TEXTSTYLE"))) 0)
				(command "._TEXT" "M" pt TextAngle label)
				(command "._TEXT" "M" pt txtht TextAngle label)
			)
		)
	)
)
;;; --- End subroutines -----------------------------------------------------

;;; --- Start C:LOTLABEL

	(while (setq pt (getpoint "\nSelect internal point:"))
		;; --- If BPOLY fails try a couple of other UCS's ---
		(command "._UCS" "_3POINT" pt (polar pt 0.1 10) (polar pt 1.5 10))
		(if
			(if (= (substr (getvar "ACADVER") 1 2) "14")
				(RunBoundary (trans pt 0 1))
			; Else
				(or
				  ;_ changed C:BPOLY to BPOLY; Paul Kohut 02/20/03
					(BPOLY (trans pt 0 1)) ;ADS function
					(command "._UCS" "_P")
					(command "._UCS" "O" pt)
					(not (princ " 2"))
					(BPOLY (trans pt 0 1)) ;ADS function
					(command "._UCS" "_P")
					(command "._UCS" "Z" 1.33)
					(not (princ " 3"))
					(BPOLY (trans pt 0 1)) ;ADS function
				)
			)
			(progn
				(command "._UCS" "_P")
				(setq boundary (entlast))
				(if (= (val 0 (entget boundary)) "LWPOLYLINE")
					(command "._CONVERTPOLY" "_HEAVY" boundary "")
				)
				(PolyLabel boundary pt)
				(if (= KeepBoundary "No")
					(progn
						(command "._erase" boundary "")
						(redraw)
					)
				)
			)
			(progn
				(command "._UCS" "_P")
				(alert "*Error*  Cannot calucalate boundary")
			)
		)
	)
	(setvar "OSMODE" osmode)
	(setvar "CLAYER" clayer)
	(princ)
)
(princ "\nLOTLABEL v1.2")
(princ)

