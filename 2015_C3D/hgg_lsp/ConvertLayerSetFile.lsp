;;; ConvertLayerSetFile.LSP -- Custom command designed to convert ls3 files into las files.
;;
;;; Copyright (C) 2015, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <szabolcs1992@gmail.com>
;;; Created: 22 August 2015
;;; Modified: 22 August 2015
;;; Version: 1.0.1
;;; Keywords: ls2, convert, las, layerset, layerstate
;;;
;;; Commentary: This command is used to convert layerset (.ls3) files into layerstate (.las) files.
;;;             This allows for compatibility for Goldsmith Engineering from the depreciated
;;;             layerset custom program.
;;;
;;; To Do:
;;; (S.P.) @ 08-22-2015) - Implement psuedo code.
;;;                      - Detail out C:PARSELAYERSETLINE
;;;                      - Detail out C:PROCESSHEADER
;;;
;;; Revisions:
;;;
;;; Code:

(defun C:CONVERTLAYERSETFILE (file file_list line_number las_file bad_layers layer_state)
  "Sets all of the default AutoCAD system variables and prompts an error if one or more ~
   variables were not set."

  (file_list (LM:GETFILES "Layerset files to convert" "" "ls3"))

  ;; Prompt: New files will be created as LAS files in respective directories. Confirm with user.
  (loop for file in file_list
        do(progn(
                 ;; line_number = 0
                 ;; open file "read only mode"
                 ;; prompt: ls3 file loaded.
                 ;; create las_file
                 ;; name based upon ls3 file name
                 ;; setup las_file to match ls3 properties
                 ;; loop:
                 ;;   read line n
                 ;;   parse line to layer_state
                 ;;   if no error:
                 ;;     convert layer_state to string
                 ;;     write string to las_file
                 ;;   else:
                 ;;     print error
                 ;;     add layer_state to bad_layers
                 ;;   line_number++
                 ;; close file
                 ;; close las_file
                 ;; prompt: file converted w/ bad_layers if needed.
                 )
           )
        )
  )

(defun C:PARSELAYERSETLINE (layer_state)
  "Takes in a line of a layer set file and parses it to a layer_state list or returns nill if ~
   line does not match form."
  )

(defun C:PROCESSHEADER ()
  )
 
