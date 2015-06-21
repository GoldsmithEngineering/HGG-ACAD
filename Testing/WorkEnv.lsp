;;; SuperQuickSave.LSP -- Saves autoCAD drawing with everything but the 0 layer frozen and everything (including regaps) purged.
;;
;;; Copyright (C) 2015, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <spasztor@goldsmithengineering.com>
;;; Created: 27 August 2014
;;; Modified: 02 March 2015
;;; Version: 1.0.3
;;; Keywords: 
;;;
;;; Commentary: This is a virtual environment wrapper designed to function much like
;;;				virtualenvwrapper located at: https://virtualenvwrapper.readthedocs.org/en/latest/index.html
;;;
;;;				The wrapper saves the following states to a virtual environment:
;;;				* RIBBONSTATE
;;;				* LAYERSTATE
;;;				* WORKSPACE
;;;				* CUI
;;;				* VPORT CONFIGURATION
;;;				* MODEL VS LAYOUT
;;;				* XREFS
;;;				* NAVBARDISPLAY
;;;
;;;
;;; Notes: 
;;;
;;; Revisions:
;;;		#.#.# (&.&. @ ##-##-####) - 
;;;
;;; Code:

;;; Managing Environments:
(defun c:mkvirtualenv (servar ENVNAME / *error*)
)

(defun c:lsvirtualenv ()
)

(defun c:showvirtualenv ()
)

(defun c:rmvirtualenv ()
)

(defun c:cpvirtualenv ()
)

(defun c:allvirtualenv ()
)

;;; Controlling the Active Environment:
(defun c:workon ()
)

(defun c:deactivate ()
)

;;; Project Directory Management:
(defun c:mkproject ()
)

(defun c:setvirtualenvproject ()
)

(defun c:cdproject ()
)

;;; Set properties of active virtual environment:
(defun c:setdfltlas ()
)

(defun c:rmdftlas ()
)

(defun c:setdfltxrefs ()
)

(defun c:rmdfltxrefs ()
)

;;; Helper functions:
(defun c:virtualenvwrapper ()
)
;;; VirtualEnvWrapper.LSP
