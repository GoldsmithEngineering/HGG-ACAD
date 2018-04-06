;;; SuperQuickSave.LSP -- Saves autoCAD drawing with everything but the 0 layer frozen and everything (including regaps) purged.
;;
;;; Copyright (C) 2018, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <spasztor@goldsmithengineering.com>
;;; Created: 27 August 2014
;;; Modified: 06 April 2018
;;; Version: 1.0.4
;;; Keywords: sss, super, quick, save
;;;
;;; Commentary: This routine first purges everything from the drawing then 
;;;				continues to purge regapps (because shitty purgeall doesn't purge all.) 
;;;				Then, it freezes all the layers but the current (0 layer), saves the
;;;				drawing and then restores the saved layer state. Followed with a regenall
;;;
;;; Notes: At one point make the output prettier.
;;;
;;; Revisions:
;;;		1.0.1 (S.P. @ 09-30-2014) - Added error handling and removed saving layerstate SQS-TEMP.
;;;		1.0.2 (S.P. @ 03/02/2015) - Removed shitty layer-state implementation, added regenall and
;;;									updated commentary. Also updated copyright, blocked out error
;;;									handling (no time to update) and added "Modified" tag.
;;;		1.0.3 (S.P. @ 03-13-2015) - Changed the layer that is left on to D-SH-L-REVBLKZZZZ
;;;									and thaws the 0 layer.
;;;		1.0.4 (S.P. @ 04-06-2018) - Made the routine very robust and added a variety of features
;;;									including error checking, variable saving, removed magic numbers,
;;;									and cleaner output.
;;;
;;; Code:
(defun c:SSS ( / *error*)

  	;; Error Handling:
    (defun *error* ( msg )
	    (if echo (setvar 'cmdecho echo))
        (if ACAD_layerp_mode (acet-layerp-mark ACAD_layerp_mode))
		(if (not (member msg '("Function cancelled" "quit / exit abort")))
            (princ (strcat "\nError: " msg))
        )
        (princ)
	)

	;; Sets variables.
	(setq echo (getvar 'cmdecho))
	(setq ACAD_layerp_mode (acet-layerp-mode))	
	(setq no_plot_layer "D-SH-L-REVBLKZZZZ")
	(setq no_plot_layer_exist_before_purge (tblsearch "LAYER" no_plot_layer))
	(setq base_layer "0")
	(setq version "1.0.4")
	(setvar 'cmdecho 0)
	
	(write-line (strcat "\nBeginning Super Quick Save (v" version ")\n----------"))
	;; Resets layers and sets layerp marker.
	(command "layer" "plot" "plot" base_layer "")
	(command "layer" "plot" "no" no_plot_layer "")
	(if (not ACAD_layerp_mode)
        (acet-layerp-mode T)
    )
	(acet-layerp-mark T)
	
	;; Purge file.
	(write-line "Starting full purge:")
	(command "purge" "all" "*" "no")
	(command "purge" "regapp" "*" "no")
	(write-line "\nFinished full purge.")
		
	;; Create no_plot_layer and announce creation if it didn't exist before purge.
	(if (not (tblsearch "LAYER" no_plot_layer))
	    (progn
		    (command "layer" "make" no_plot_layer "" )
			(command "layer" "plot" "no" no_plot_layer "")
			(write-line (strcat "\n" no_plot_layer " not found and has been created."))
		)
	)
	
    ;; Freezes all layers except base_layer.
	(write-line (strcat "\nFreezing all layers except layer " base_layer "..."))
	(command "layer" "set" base_layer "freeze" "*" "")
	
	;; Save file.
	(write-line "\nSaving file...")
	(command "qsave")
	(acet-layerp-mark nil)
	
	;; Restore old layer state.
	(write-line "\nRestoring layers...")
	(command "layerp")
	(command "regenall")
	
	;; Restore variables and print success.
	(setq *error* nil)
	(setvar 'cmdecho echo) 
	(write-line "----------\nSuper Quick Save Complete.")
	(princ)
)
;;; SuperQuickSave.LSP
