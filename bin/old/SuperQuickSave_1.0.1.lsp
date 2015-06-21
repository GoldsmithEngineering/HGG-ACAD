;;; SuperQuickSave.LSP -- Saves autoCAD drawing with everything but the 0 layer frozen and everything (including regaps) purged.
;;
;;; Copyright (C) 2014, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <spasztor@goldsmithengineering.com>
;;; Created: 27 August 2014
;;; Version: 1.0.1
;;; Keywords: sss, super, quick, save
;;;
;;; Commentary: This routine first purges everything from the drawing then 
;;;				continues to purge regapps. Then it saves the current layer 
;;;				state under [FILENAME]-temp (deletes the old temp layer under
;;;				that name if it exists) and then sets the current layer to "0".
;;;				Finally, it freezes all the layers but the current, saves the
;;;				drawing and then restores the saved layer state.
;;;
;;; Code:
(defun c:SSS nil
	(setvar "nomutt" 1)
	;; Purge reg-apps from file:
	(command "purge" "regapp" "*" "no")
	
	;; Save Current Layer State:
	(setq layerstatename (strcat (vl-filename-base (getvar "dwgname")) "-temp"))
	(command "layer" "state" "save" "SQS-temp" "" "" "")
	(command "layer" "state" "restore" "SQS-temp" "" "")
	(if (layerstate-has layerstatename)
		(command "layer" "state" "delete" layerstatename "" "")
	)
	(command "layer" "state" "save" layerstatename "" "" "")
	
	;; Freeze all layers but "0" layer and save:
	(command "layer" "set" "0" "")
	(command "layer" "freeze" "*" "")
	(command "qsave")
	
	;; Restore old layer state.
	(command "layer" "state" "restore" layerstatename "" "")
	(command "layer" "state" "delete" "SQS-temp" "" "" "")
	(setvar "nomutt" 0)
	print "Super Quick Save Complete."
)
;;; SuperQuickSave.LSP