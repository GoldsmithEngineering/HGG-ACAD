;;; SuperQuickSave.LSP -- Saves autoCAD drawing with everything but the 0 layer frozen and everything (including regaps) purged.
;;
;;; Copyright (C) 2015, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <szabolcs1992@gmail.com>
;;; Created: 27 August 2014
;;; Modified: 08 June 2015
;;; Version: 1.0.4
;;; Keywords: sss, super, quick, save
;;;
;;; Commentary: This routine first purges everything from the drawing then 
;;;				continues to purge regapps (because shitty purgeall doesn't purge all.) 
;;;				Then, it freezes all the layers but the current (0 layer), saves the
;;;				drawing and then restores the saved layer state. Followed with a regenall
;;;
;;; To Do:
;;;		(S.P. @ 03-02-2015)			At one point make the output prettier.
;;;		(S.P. @ 03-13-2015)			Add Error Handling.
;;;		(S.P. @ 06-08-2015)			Add Documentation
;;;
;;; Revisions:
;;;		1.0.1 (S.P. @ 09-30-2014)	Added error handling and removed saving layerstate SQS-TEMP.
;;;		1.0.2 (S.P. @ 03-02-2015)	Removed shitty layer-state implementation, added regenall and
;;;									updated commentary. Also updated copyright, blocked out error
;;;									handling (no time to update) and added "Modified" tag.
;;;		1.0.3 (S.P. @ 03-13-2015)	Changed the layer that is left on to D-SH-L-REVBLKZZZZ
;;;									and thaws the 0 layer.
;;;		1.0.4 (S.P. @ 06-08-2015)	Now sets hides command output during save.
;;;
;;; Code:
(defun c:SSS ( / *error*)
;; Error Handling:
;;        (defun *error* ( msg )
;;
;;	    if: layer settings haven't been set
;;		then: LAYERP x 2
;;
;;	    (if (not (member msg '("Function cancelled" "quit / exit abort")))
;;	        (princ (strcat "\nError: " msg))
;;	    )
;;	    (princ)
;;	)
	(setq OLD_ECHO (getvar "CMDECHO"))
	(command "CMDECHO" 0 "")
	
	;; Purge file:
	(command "purge" "all" "*" "no")
	(command "purge" "regapp" "*" "no")
	
	;; Create D-SH-L-REVBLKZZZZ if it doesn't exist and set it to no-plot.
	(if (= (tblsearch "LAYER" "D-SH-L-REVBLKZZZZ") nil)
		(command "layer" "make" "D-SH-L-REVBLKZZZZ" "" )
	)
	(command "layer" "plot" "no" "D-SH-L-REVBLKZZZZ" "")
	
	;; Set Current Layer to D-SH-L-REVBLKZZZZ and freeze all layers (but layer 0) and save.
	(command "layer" "set" "D-SH-L-REVBLKZZZZ" "freeze" "*" "thaw" "0" "")
	(command "qsave")
	
	;; Restore working state.
	(command "layerp")
	(command "layerp")
	(command "CMDECHO" OLD_ECHO "")
	(command "regenall")
;;	(setq *error* nil)

	print "Super Quick Save Complete."
)
;;; SuperQuickSave.LSP