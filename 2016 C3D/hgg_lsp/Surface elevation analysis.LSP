;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Tool to transfer, export and import Surface Elevation Analysis data   ;;;
;;; for Civil 3D 2008                		                          ;;;
;;; Version from 30.07.07                                                 ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Routine to transfer Civil 3D surface elevation analysis data          ;;;
;;; between surfaces in the same drawing                                  ;;;
;;; Routine to export Civil 3D surface elevation analysis data            ;;;
;;; into a text file  (Tab-delimited)                                     ;;;
;;; Routine to import Civil 3D surface elevation analysis data            ;;;
;;; from a text file  							  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; tested with Civil 3D 2008                                             ;;;
;;; Commands to call: TransferElevations                                  ;;;
;;;         ExportElevations und                             		  ;;;
;;;         ImportElevations                                              ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; True Color and Color book colors are replaced by index colors         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(vl-load-com)
(defun C:TransferElevations ( / ALLREGIONS CNT DGMENTENTITY SSDGMS )
  (Prompt "Transfer surface elevation analysis data")

  (If (and (setq dgmententity (car (entsel "Select source surface:")))
	   (= "AECC_TIN_SURFACE" (cdr (assoc 0 (entget dgmententity))))
      )
    (progn
      (Setq AllRegions (GETTINDATA dgmententity))
      (prompt "Select target surface:")
      (if (setq ssDGMS (SSGET (list (cons 0 "AECC_TIN_SURFACE"))))
	(progn
	  (setq cnt (sslength ssDGMS))
	  (while (>= (setq cnt (1- cnt)) 0)
	    (PutTINDATA (ssname ssDGMs cnt)  AllRegions)
	  )
	)
      )
    )
    (Prompt "No surface selected.")
  )
  (prin1)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun C:ExportElevations ( / ALLREGIONS CNT DGMENTENTITY SSDGMS )
  (Prompt "Export surface elevation analysis data")

  (If (and (setq dgmententity (car (entsel "Select source surface:")))
	   (= "AECC_TIN_SURFACE" (cdr (assoc 0 (entget dgmententity))))
	   (setq datei (getfiled "Specify export file for surface elevation analysis data:"
				"S:/Grading Color Schemes/"
				;;; (getvar "dwgname")
				 "txt"
				 1
		       )
	   )
      )
    (progn
      (setq file (open datei "w"))
      (Write-line "Colour\tMin. Elevation\tMax. Elevation" file)
      ; Daten MÜSSEN mit Nachkommastellen exportiert werden
      (setq dimz (getvar "dimzin"))
      (setvar "dimzin" 2)
      (foreach region (GETTINDATA dgmententity)
	(write-line (strcat (itoa (car   region)) ; Color
			    "\t"
			    (rtos (cadr  region) 2 3) ; MinimumElevation
			    "\t"
			    (rtos (caddr region) 2 3) ; MaximumElevation
		    )
	            file
	)
      )
      (setvar "dimzin" dimz)
      (close file)
      (prompt "Output finished.")
    )
    (Prompt "No surface selected.")
  )
  (prin1)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun C:ImportElevations ( / ALLREGIONS CNT DGMENTENTITY SSDGMS )
  (Prompt "Import and assign surface elevation analysis data")

  (If (and (setq dgmententity (car (entsel "Select target surface:")))
	   (= "AECC_TIN_SURFACE" (cdr (assoc 0 (entget dgmententity))))
	   (setq datei (getfiled "Specify import file for surface elevation analysis data:"
				"S:/Grading Color Schemes/"
				;;; (getvar "dwgname")
				 "txt"
				 0
		       )
	   )
      )
    (progn
      (setq file (open datei "r"))
      (read-line file)
      (while (setq zeile (read-line file))
	(setq region (read (strcat "(" zeile ")"))
	      allRegions (cons region allRegions)
	)
      )
      (close file)
      (if (RegionDataok? (reverse AllRegions))
        (PutTINDATA dgmententity  (reverse AllRegions))
	(alert "The file contains invalid data! Import failed.")
      )
      (prompt "Finished.")

    )
    (Prompt "No surface selected.")
  )
  (prin1)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun RegionDataok? (AllRegions)
  (setq cnt 0
	ok 'T
  )
  (repeat (length allRegions)
    (if (> (cadr (nth cnt allRegions)) (caddr (nth cnt allRegions)))
      (progn
	 (Prompt (strcat "Problem: Data in line " (itoa (1+ cnt)) " invalid! Min > Max.") )
	 (setq ok nil)
      )
    )
    (Cond
      ((= cnt 0) 'T)
      ((= (cadr (nth cnt allRegions)) (caddr (nth (1- cnt) allRegions))) 'T)
      ((> (cadr (nth cnt allRegions)) (caddr (nth (1- cnt) allRegions)))
       (Prompt (strcat "Gap in line " (itoa (1+ cnt))
		       "  Max < Min of following line."))
      )
      ((< (cadr (nth cnt allRegions)) (caddr (nth (1- cnt) allRegions)))
       (Prompt (strcat "Overlapping data in line "
		       (itoa (1+ cnt)) "  Max > Min of following line."))
       (setq ok nil)
      )
      ('T 'T)
    )
    (Setq cnt (1+ cnt))
  )
  (progn ok) ; Rückgabewert
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun GETTINDATA (dgmententity /
		   AllRegions DGMOBJECT ELEVATIONREGIONS REGIONLIST
		   SURFACEANALYSIS SURFACEANALYSISELEVATION )
  (setq DGMObject (vlax-ename->vla-object DGMententity))
  (setq SurfaceAnalysis (vlax-get-property DGMObject "SurfaceAnalysis"))
  (setq SurfaceAnalysisElevation (vlax-get-property SurfaceAnalysis "ElevationAnalysis"))
  (setq ElevationRegions (vlax-get-property SurfaceAnalysisElevation "ElevationRegions"))
  (vlax-for Region ElevationRegions
    (setq Regionlist (list (vlax-get-property Region "Color")
                           (vlax-get-property Region "MinimumElevation")
                           (vlax-get-property Region "MaximumElevation")
		     )
	  AllRegions (cons Regionlist AllRegions)
    )   
      ;   Color = 26
    ;   MaximumElevation = 80.0
    ;   MinimumElevation = 60.0
  )
   (reverse allRegions)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun PUTTINDATA (DGMententity Regions
		   / DGMOBJECT ELEVATIONREGIONS SURFACEANALYSIS
		   SURFACEANALYSISELEVATION Regionobjlist)
  (setq DGMObject (vlax-ename->vla-object DGMententity))
  (setq SurfaceAnalysis (vlax-get-property DGMObject "SurfaceAnalysis"))
  (setq SurfaceAnalysisElevation (vlax-get-property SurfaceAnalysis "ElevationAnalysis"))
  (setq ElevationRegions (vlax-invoke-method SurfaceAnalysisElevation
			                     "CalculateElevationRegions"
			                     (length Regions)
			                     :vlax-false
			 )
  )
  ; da die Bereiche sich nicht überlagern dürfen, werden Sie temporär
  ; neu belegt, dann erst mit den Realwerten belegt.
  ; zuerst eine Objektliste erzeugen
  (vlax-for Region ElevationRegions
    (setq regionobjlist (cons Region Regionobjlist))
  )
  (Setq tempmax (+ (last (last Regions))
		   (vlax-get-property (car regionobjlist) "MaximumElevation" )
		   (length Regions)
	        )
  )
  (foreach Region regionobjlist
    (vlax-put-property Region "MaximumElevation" tempmax)
    (vlax-put-property Region "MinimumElevation" (setq Tempmax (1- tempmax)))
  )
  (foreach Region (reverse regionobjlist)
    (vlax-put-property Region "Color" (caar Regions))
    (vlax-put-property Region "MinimumElevation" (cadar Regions))
    (vlax-put-property Region "MaximumElevation" (caddar Regions))
    (setq Regions (cdr Regions))
  )
  
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(Prompt (strcat "Surface elevation analysis.LSP is loaded"
        	"TransferElevations, ImportElevations und"
		"ExportElevations is available."))
(prin1)