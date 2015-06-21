;;; SuperQuickSave.LSP -- Saves autoCAD drawing with everything but the 0 layer frozen and everything (including regaps) purged.
;;
;;; Copyright (C) 2014, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <spasztor@goldsmithengineering.com>
;;; Created: 27 August 2014
;;; Version: 1.0.2
;;; Keywords: sss, super, quick, save
;;;
;;; Commentary: This routine first purges everything from the drawing then 
;;;				continues to purge regapps (because shitty purgeall doesn't purge all.) 
;;;				Then, it freezes all the layers but the current (0 layer), saves the
;;;				drawing and then restores the saved layer state. Followed with a regenall
;;;
;;; Revisions:
;;;		1.0.2 (S.P. @ 03/02/2015) -  Removed shitty layer-state implementation, added regenall and updated commentary.
;;;
;;; Code:
(defun c:SSS nil
	;; Purge file:
	(command "purge" "all" "*" "no")
	(command "purge" "regapp" "*" "no")
	
	;; Save Current Layer to 0 and freeze all layers and save.
	(command "layer" "set" "0" "freeze" "*" "")
	(command "qsave")
	
	;; Restore old layer state.
	(command "layerp")
	(command "layerp")
	(command "regenall")
	print "Super Quick Save Complete."
)
;;; SuperQuickSave.LSP