(defun c:STAN nil
	(setvar "NOMUTT" 1)
	(setq f_name_sufix "_hgg.dwg")
	(setq f_path (getvar "dwgprefix"))
	(setq f_name (strcat  (vl-filename-base (getvar "dwgname"))))
	(setq log_file (getvar "LOGFILENAME"))
	
	(command "saveas" "2013" (strcat f_path f_name f_name_sufix))
	
	;; Detach all xrefs:
	(command "xref" "detach" "*")
	
	;; Delete all unused scales:
	(command "-scalelistedit" "d" "*" "ex")
	
	;; Purge the drawing"
	(command "purge" "r" "*" "no")
	(command "purge" "all" "*" "no")
	
	;; Audit the drawing:
	(command "audit" "y")
	
	;; Set all objects to by layer:
	(command "layer" "unlock" "*" "")
	(command "setbylayer" "all" "" "yes" "yes")
	
	;; Round two of purging:
	(command "purge" "r" "*" "no")
	(command "purge" "all" "*" "no")
	
	;; Save file:
	(command "qsave")
	
	;; [TODO] Open Log File to see results:
	;;(startapp "notepad" log_file)
	(setvar "nomutt" 0)
)