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
  (if (and (/= file_list nil) (setq ls3_file (open (car file_list) "r")a)); Consider using cond to split up statements and allow for output upon success
    (progn
      (print (concatenate "\nLS3 File \"" ls3_file "\" loaded."))
      (if default_filename
        (setq las_filename (vl-string-subst "las" "ls3" ls3_file))
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
    (print (print (concatenate "\nWARNING: Error reading \"" ls3_file "\"."))); replace with generic *error
    (PROCESS_FILES (cdr file_list) default_filename); Recursive call
    )
  )

(defun _PROCESS_LS3FILE (ls3_file las_file / line layer_state)
  "Recursively iterates through the lines in the LS3 File to process."
  (if (setq line (read-line ls3_file))
    (progn
      ;; if line starts with ';'
      (if (vl-string-search ";" line)
        (progn ;then
          (write-line "0/nLAYERSTATEDICTIONARY/n0/nLAYERSTATE/n1/n" las_file)
          (vl-string-trim ";" line)
          (setq parsed_string (substr line 1 (vl-string-position (ascii ";") line)))
          (write-line (concatenate parsed_string "\n" las_file))
          )
        (progn ;else
          (while (equal (read line) "/n")
            (cons (_READ_TO_DELIMITER line ";") layer_state)
            ;; layer_state is a list that has the following format:
            ;;    layer_state[0] = Layer name
            ;;    layer_state[1] = Layer state as bit where bits are as follows:
            ;;                      1 = Is Frozen
            ;;                      2 = VPDFLT (I think its is New VP Frozen)
            ;;                      4 = Is Locked
            ;;                      8 = Unused
            ;;                      16 = Is Xref Dependent
            ;;                      32 = Unused
            ;;                      64 = Is Plottable
            ;;                      128 = Is VP Frozen
            ;;    layer_state[2] = Color of layer * -1 if layer is off.
            ;;    layer_state[3] = Linetytpe
            ;;    layer_state[4] = Line Weight
            ;;    layer_state[5] = Plot Style
            ;;    layer_state[6] = Transperancy
            ;;    layer_state[7] = Is Current Layer (4 if it is, 0 if not)k
          )
        )
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

(defun _READ_TO_DELIMITER (raw_string delimiter / parsed_string delimiter_position)
  "Returns the string up to delimiter and removes it from raw_string."
  (setq delimiter_position (vl-string-position (ascii delimiter) raw_string))
  (setq parsed_string (substr raw_string 1 delimiter_position))
  (setq raw_string (substr raw_string (+ 2 delimiter_position) (strlen raw_string)))
  (parsed_string)
  )
 
