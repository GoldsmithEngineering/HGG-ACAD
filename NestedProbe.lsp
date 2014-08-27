;;; NestedProbe.LSP -- Calls the "laytblprp" command with the nested argument.
;;
;;; Copyright (C) 2014, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <spasztor@goldsmithengineering.com>
;;; Created: 27 August 2014
;;; Version: 1.0
;;; Keywords: pb, probe, nested, layer, xref
;;;
;;; This file is part of GNU Emacs
;;;
;;; Code:
(defun c:PB nil
	(command "laytblprp" "nested")
)
;;; NestedProbe.LSP