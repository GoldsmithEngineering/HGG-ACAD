;;; Restore.LSP -- Thaws everything, zooms to extents and then regens.
;;
;;; Copyright (C) 2015, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <spasztor@goldsmithengineering.com>
;;; Created: 28 January 2015
;;; Version: 1.0.0
;;; Keywords: rst, restore, zoom, save
;;;
;;; Commentary: [TO BE ADDED]
;;;
;;; Code:
(defun c:RST nil
	(command "zoom" "e" "")
	(command "laythw")
	(command "regen")
	print "Restore Complete."
)
;;; SuperQuickSave.LSP