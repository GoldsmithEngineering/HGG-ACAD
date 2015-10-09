;;; Clean.LSP -- Does a full PURGE and AUDIT
;;
;;; Copyright (C) 2015, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <spasztor@goldsmithengineering.com>
;;; Created: 01 January 2015
;;; Modified: 03 March 2015
;;; Version: 1.0.2
;;; Keywords: cnn, purge, audit, regapps
;;;
;;; Commentary: This routine first purges everything from the drawing then 
;;;				does a full audit before finishing.
;;;
;;; Revisions:
;;;		1.0.1 (S.P. @ 03-03-2015) - Added purging regapps because shitty purge all doesn't purge all.
;;;									Also updated copyright, added regapps as keyword 
;;;									and added "Modified" tag.
;;;
;;; Code:
(defun c:CNN nil
	;; Do a full purge on the drawing:
	(command "purge" "r" "*" "no")
	(command "purge" "all" "*" "no")
	
	;; Audit the drawing:
	(command "audit" "y")
	
	print "Clean Complete."
)
;;; Clean.LSP