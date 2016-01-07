;;; LayerFreeze.LSP -- Calls the "layfrz" command with the viewports setting set to "freeze".
;;
;;; Copyright (C) 2014, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <spasztor@goldsmithengineering.com>
;;; Created: 28 August 2014
;;; Version: 1.0
;;; Keywords: layfrz, layer, freeze,
;;;
;;; Code:
(defun c:FR nil
	(setvar "nomutt" 1)
	(command "layfrz" "settings" "viewports" "freeze" "")
	(setvar "nomutt" 0)
	(command "layfrz")
)
;;; LayerFreeze.LSP