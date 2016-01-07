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
(defun C:CALCERROR (/ _values _error)
  ; loop through list and add up values
  ; return error
)

(defun C:CLOSETRAVERSE (/ i departs lats ss ss_count ss_entity x y)
  (if (setq ss (ssget '((0 . "AECC_COGO_POINT")))) ; If selection not empty
    (progn ; then
      (setq i 0
            ss_count (sslength)
      )
      (while (< i ss_count)
             (setq ss_entity (ssname ss i)
                   ; x = point x
                   ; y = point y
                   i (1+ i)
             )
      )
  )
)
