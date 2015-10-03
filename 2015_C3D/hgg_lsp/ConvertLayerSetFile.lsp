;;; ConvertLayerSetFile.LSP -- Custom command designed to convert ls3 files into las files.
;;
;;; Copyright (C) 2015, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <szabolcs1992@gmail.com>
;;; Created: 22 August 2015
;;; Modified: 26 September 2015
;;; Version: 1.0.1
;;; Keywords: ls3, convert, las, layerset, layerstate
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

(defun C:CONVERTLAYERSETFILE ( / file_list default_filename)
  "Processes multiple files for conversion."

  (init 1 "y" "n")
  (set ans (getkword "/nCreate files in respective directories? [Y]es [N]o:"))
  (setq default_filename (eq ans "y"))
  (setq file_list (LM:GETFILES "Layerset files to convert" "" "ls3"))
  (_PROCESS_FILES file_list default_filename)
  )

(defun _PROCESS_FILES (file_list default_filename / ls3_file las_filename las_file)
  "Recursively iterates through the files specified to process."
  (if (and (/= file_list nil) (setq ls3_file (open (car file_list) "r")a)); Consider using cond to split up statements and allow for output upon sucess
    (progn
      (print (concatenate "\nLS3 File \"" file "\" loaded."))
      (if default_filename
        (setq las_filename (vl-string-subst "las" "ls3" file))
        (setq las_filename (getfiled "Specify location to save layer state file:" "" "las" 0))
        )
      (if (setq las_file (open las_filename "w"))
        (progn
          (_PROCESS_LS3FILE (ls3_file las_file))
          (close ls3_file)
          (close las_file)
          (print (concatenate "\n" las_filename" " created.")
          )
        (print (print (concatenate "\nWARNING: Error creating \"" las_filename "\"."))); replace with generic *error
        )
      )
    (print (print (concatenate "\nWARNING: Error reading \"" file "\"."))); replace with generic *error
    (PROCESS_FILES (cdr file_list) default_filename); Recursive call
    )
  )

(defun _PROCESS_LS3FILE (ls3_file las_file / line)
  "Recursively iterates through the lines in the LS3 File to process."
  (if (setq line (read-line ls3_file))
    (progn
      ;; if line starts with ';'
      ;; (c:processheader line)
      ;; else
      ;; split up strings with delimitter ';'
      ;; and setup layer state string appropriately
      ;; write new_line to las_file
      ;;   else:
      ;;     print error
      ;;     add layer_state to bad_layers
      )
    ;; prompt: file converted w/ bad_layers if needed.
    )
  )

(defun _PROCESSHEADER ()
  "Setup las_file to match ls3 properties (Like Author and Description)"
  ;; split up strings with delimitter ';'
  ;; and setup layer state properties appropriately
  )
 
