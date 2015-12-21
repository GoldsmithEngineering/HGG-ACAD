;;; ConvertLayerSetFile.LSP -- Custom command designed to convert ls3 files into las files.
;;
;;; Copyright (C) 2015, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <szabolcs1992@gmail.com>
;;; Created: 22 August 2015
;;; Modified: 20 December 2015
;;; Version: 1.0.1
;;; Keywords: ls3, convert, las, layerset, layerstate
;;;
;;; Commentary: This command is used to convert layerset (.ls3) files into layerstate (.las) files.
;;;             This allows for compatibility for Goldsmith Engineering from the depreciated
;;;             layerset custom program.
;;;
;;; To Do:
;;; (S.P.) @12-20-2015) - Finish layer_state processing.
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
          (print (concatenate "\n" las_filename " created."))
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
      ; Are we on the first line?
      (if (equal (vl-string-elt line 0) (ascii ";"))

        ; then:
        (progn
          (write-line "0/nLAYERSTATEDICTIONARY/n0/nLAYERSTATE/n1/n" las_file)
          (vl-string-trim ";" line)

          ; Parse ls3 description and use as las name. 09 = HT or tab in ascii
          (write-line (strcat (_READ_TO_DELIMITER line 09) "\n") las_file)
          (write-line "91\n2047\n302\n" las_file)
          ; Parse ls3 author and use as las description.
          (write-line (strcat "Author: "(_READ_TO_DELIMITER line 09) "\n") las_file)
          (write-line "290\n1\n302\n" las_file)
          )

        ; else:
        (progn
          (while (not (equal line "/n"))
            (append layer_state (_READ_TO_DELIMITER line 09))
            (if(_PRINT_LAYER_STATE layer_state); if success.
                (_PRINT_LAYER_STATE layer_state); then
                (print (strcat "Error in processing layer: " (car layer_state)))
              )
            )
          )
        )
      )
      (_PROCESS_LS3FILE ls3_file las_file)
    )
  )

(defun _PRINT_LAYER_STATE (layer_state)
  "Prints a layer state to the autocad format with the appriopriate '\n's. Returns nil on error"
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

(defun _READ_TO_DELIMITER (raw_string delimiter_character_code / parsed_string delimiter_position)
  "Returns the string up to delimiter_code and removes it from raw_string."
  (setq delimiter_position (vl-string-position delimiter_character_code raw_string))
  (setq parsed_string (substr raw_string 1 delimiter_position))
  (setq raw_string (substr raw_string (+ 2 delimiter_position) (strlen raw_string)))
  (parsed_string)
  )
 
