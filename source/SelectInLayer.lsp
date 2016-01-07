;;; SelectInLayer.LSP -- Selects all objects in specified layer.
;;
;;; Copyright (C) 2015, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <spasztor@goldsmithengineering.com>
;;; Created: 07 October 2015
;;; Modified: 07 October 2015
;;; Version: 1.0.1
;;; Keywords: 
;;;
;;; Commentary: 
;;;
;;; Notes: A
;;;
;;; Revisions:
;;;
;;; Code:
(defun c:SELECTINLAYER ( / *error* layer_name)
  (setq layer_name (getstring nil "Enter layer filter to select objects from: "))
  (ssget "X" (list (cons 8 layer_name)))
  (command "pselect" "p" "")
  (princ)
)
;;; SelectInLayer.LSP
