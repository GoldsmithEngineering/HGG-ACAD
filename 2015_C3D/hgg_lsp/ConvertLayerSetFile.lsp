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

(defun C:CONVERTLAYERSETFILE (file file_list line_number las_file bad_layers layer_state)
  "Processes multiple files for conversion."

  (init 1 "y" "n")
  (set ans (getkword "/nCreate files in respective directories? (y n)"))
  (setq default_filename (eq ans "y"))
  (if (setq file_list (LM:GETFILES "Layerset files to convert" "" "ls3"))
    (foreach file file_list
       (if (setq ls3_file (open file "r"))
         (progn
           (print (concatenate "\nLS3 File \"" file "\" loaded."))
           (if default_filename
             (setq las_filename (vl-string-subst "las" "ls3" file))
             (setq las_filename (getfiled "Specify location to save layer state" "" "las" 0))
             )
           (if (setq las_file (open las_filename "w"))
             (progn
               (while (setq line (read-line ls3_file))
                 (if (setq new_line (C:PARSELAYERSETLINE line))
                   ;; write new_line to las_file
                   ;;   else:
                   ;;     print error
                   ;;     add layer_state to bad_layers
                   )
                 )
               (close ls3_file)
               (close las_file)
               ;; prompt: file converted w/ bad_layers if needed.
               )
             (print (print (concatenate "\nWARNING: Error creating \"" las_filename "\"."))); replace with generic *error
             )
           )
         (print (print (concatenate "\nWARNING: Error reading \"" file "\"."))); replace with generic *error
         )
      )
    )
  )

(defun C:PARSELAYERSETLINE (line)
  "Takes in a line of a layer set file and parses it to a layer_state list or returns nill if ~
   line does not match form."
   ;; if line starts with ';'
   ;; (c:processheader line)
   ;; else
   ;; split up strings with delimitter ';'
   ;; and setup layer state string appropriately
  )

(defun C:PROCESSHEADER ()
  "Setup las_file to match ls3 properties (Like Author and Description)"
  ;; split up strings with delimitter ';'
  ;; and setup layer state properties appropriately
  )
 
