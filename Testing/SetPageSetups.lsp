;;; SuperQuickSave.LSP -- Saves autoCAD drawing with everything but the 0 layer frozen and everything (including regaps) purged.
;;
;;; Copyright (C) 2014, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <spasztor@goldsmithengineering.com>
;;; Created: 27 August 2014
;;; Version: 1.0.1
;;; Keywords: SETPAGESETUPS, page setups, page, setups
;;;
;;; Commentary: Almost all code based from:
;;;				http://forums.augi.com/showthread.php?63099-page-setup-import-vlisp&p=720404&viewfull=1#post720404
;;;
;;; Revisions:
;;; 	
;;; Code:
(defun c:SETPAGESETUPS ( / *error* nom curdwg pslayout x)

  	;; Error Handling:
        (defun *error* ( msg )

	    (if nom (setvar 'nomutt nom))

            (command "layer" "state" "restore" layerstatename "" "" "")
	    (command "layer" "state" "delete" "SQS-Temp" "" "" "")
	    (command "regenall" "")

	    (if (not (member msg '("Function cancelled" "quit / exit abort")))
	        (princ (strcat "\nError: " msg))
	    )
	    (princ)
	)

	;; Set NOMUTT system variable to 1 and save old state.
	(setq nom (getvar 'nomutt))
	(setvar 'nomutt 1)

	(vl-load-com) 
	(setq curdwg
		(vla-get-ActiveDocument (vlax-get-Acad-Object)) 
		pslayout (vla-get-Layout (vla-get-PaperSpace curdwg)) 
	) 
	
	;; Call RefreshPlotDeviceInfo before GetPlotDeviceNames 
	(vla-RefreshPlotDeviceInfo pslayout) 
	(vlax-for x (vla-get-Plotconfigurations curdwg) 
		(vla-delete x) 
	) 

	(command "-PSETUPIN" )
	;; Restore NOMUTT system variable and *error* symbol.
	(setvar 'nomutt 0)
	(setq *error* nil)

	(printc)
)
;;; SuperQuickSave.LSP
