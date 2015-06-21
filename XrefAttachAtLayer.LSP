;;; XrefAttachAtLayer.LSP -- Places x-references on their own layer with a "0_" as a prefix.
;;;
;;; Copyright (C) 2015, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <spasztor@goldsmithengineering.com>
;;; Created: 01 January 2015
;;; Modified: 20 April 2015
;;; Version: 1.0.2
;;; Keywords: xal, xref, xa, xattach
;;;
;;; Commentary: This routine places an xref on a layer with the format: "0_" + [xref name] after saving
;;;				the current layer and then restoring it once the xref has been set.
;;;
;;;				This command also undefines _xattach to replace its functionality with this function.
;;;
;;; Original Author's Commentary:
;;;		For those who xref drawings to use a backgrounds for their detailing or modeling work...
;;;
;;;		This will load an xref and put it on its own locked layer.
;;;		The new layer will be named by prepending an "XR-" to the drawing name of the xref
;;;		The routine finishes by returning the user to the current working layer
;;;
;;;		I wrote this because my layer management in loading xrefs eventually becomes an ankle biter.
;;;		I don't always remember to get the xref on a locked layer.  When I do this step, I don't always
;;;		remember to get out of the locked layer before returning to the model.  This routine prevents
;;;		this "shoot-myself-in-the-foot" behavior by handling all of the layer management in the
;;;		background.  "lnl" is my acronym for load and lock.
;;;
;;; TODO:
;;;		(S.P. @ 04-20-2015) - Need to add error handling.
;;;
;;; Revisions:
;;;		1.0.1 (S.P. @ 04-20-2015) - Added a header, cleaned up code and undefined "_xattach".
;;;									Also turned command output off.
;;;
;;; Code:
(defun C:XAL (/ a current_layer xref_data new_layer update_current_layer update_xref_data)

	(setq current_layer (getvar "CLAYER"))
	; Once you have error handling setup, insert this line:(setq current_cmdecho (getvar "CMDECHO"))
	;(command "CMDECHO" "0" "")

	(command "_.xattach" "~")
	(while (/= (getvar "CmdActive") 0)
	(command pause)
	);-while

	(setq xref_data (entget (entlast)))
	(setq new_layer (cdr (assoc 2 xref_data)))
	(setq new_layer (strcat "0_" new_layer))
	(command "-layer" "make" new_layer "") 
	(setq update_current_layer (getvar "CLAYER"))

	(setq update_xref_data (subst (cons 8 update_current_layer) (assoc 8 xref_data) xref_data))
	(entmod update_xref_data)

	(setvar "CLAYER" current_layer)
	; Once you have error handling setup, insert this line:(setvar "CMDECHO" current_cmdecho)

);-defun

;; Aliases for command:
(command "_.undefine" "_xattach")
(defun C:xattach () (C:XAL))
(defun C:_xattach () (C:XAL))
;;; XrefAttachAtLayer.LSP