;;; SuperQuickSave.LSP -- Saves autoCAD drawing with everything but the 0 layer frozen and everything (including regaps) purged.
;;
;;; Copyright (C) 2014, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <spasztor@goldsmithengineering.com>
;;; Created: 27 August 2014
;;; Version: 1.0
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
(setvar "nomutt" 1)
(defun c:SSS nil
	;; Purge file:
	(princ (command "purge" "all" "*" "no"))
	(command "purge" "regapp" "*" "no")
	
	;; Save Layer State:
	(setq layerstatename (strcat (vl-filename-base (getvar "dwgname")) "-temp"))
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
)
(setvar "nomutt" 0)
;;; SuperQuickSave.LSP