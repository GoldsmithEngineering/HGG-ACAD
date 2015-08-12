;;; CloseTraverse.LSP -- Closes a traverse made up of COGO Points using the compass method.
;;;
;;; Copyright (C) 2015, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <spasztor@goldsmithengineering.com>
;;; Created: 12 August 2015
;;; Modified: 12 August 2015
;;; Version: 1.0.1
;;; Keywords: traverse, close, points, survey
;;;
;;; Commentary:
;;;
;;; Notes:
;;;
;;; Revisions:
;;;
;;; Code:
(defun c:CLOSETRAVERSE (/ i n x y ss)
  (if (setq ss (ssget '((0 . "AECC_COGO_POINT")))) ; If selection not empty
    (progn ; then
      (setq i 0
            n (sslength)
      )
      (while (< i n)
      )
  )
)
