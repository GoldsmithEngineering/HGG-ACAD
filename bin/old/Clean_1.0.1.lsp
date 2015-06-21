;;; Clean.LSP -- Does a full PURGE and AUDIT
;;
;;; Copyright (C) 2014, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <spasztor@goldsmithengineering.com>
;;; Created: 01 January 2015
;;; Version: 1.0.1
;;; Keywords: cnn, purge, audit
;;;
;;; Commentary: This routine first purges everything from the drawing then 
;;;				does a full audit before finishing.
;;;
;;; Code:
(defun c:CNN nil
	;; Do a full purge on the drawing:
	(command "purge" "all" "*" "no")
	
	;; Audit the drawing:
	(command "audit" "y")
	
	print "Clean Complete."
)
;;; Clean.LSP