;;; CopyRot.LSP -- Copies and rotates an object at a specified basepoint.
;;;
;;; Copyright (C) 2017, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <spasztor@goldsmithengineering.com>
;;; Created:  31 March 2000 (Or even earlier by others)
;;; Modified: 08 August 2017
;;; Version: 1.0.2
;;; Keywords: CR, copy, rotate, copyrot
;;;
;;; Commentary: This routine first gets a selection and then copies the selection 
;;;             at the sepecified point before then rotating the same seleciton
;;;             at the specified point.
;;;
;;; Revisions:
;;;		1.0.1 (NA   @ 03-31-2000) - Routine extracted from the ACAD.lsp
;;;		1.0.2 (S.P. @ 08/08/2017) - Updated selset to ssget and added documentatoin.Removed shitty layer-state implementation, added regenall and
;;;
;;; ToDo:
;;;     S.P. @ 08/08/2017 - Modify code to C# as opposed to AutoLISP
;;;
;;; Code:
(defun C:COPYROT (/ objs)
   (setvar "cmdecho" 0)
   (setq objs (ssget))
   (initget 9)
   (setq pt1 (getpoint "\nPoint of rotation: "))
   (command ".COPY" objs "" pt1 pt1)
   (princ "\n<rotation angle>/Reference: ")
   (command ".ROTATE" objs "" pt1 PAUSE)
   (princ)
)

(princ "\n...COPYROT")
;;; CopyRot.LSP
