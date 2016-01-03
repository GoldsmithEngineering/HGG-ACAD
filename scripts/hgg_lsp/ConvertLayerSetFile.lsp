;;; ConvertLayerSetFile.LSP -- Custom command designed to convert ls3 files into las files.
;;
;;; Copyright (C) 2016, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <szabolcs1992@gmail.com>
;;; Created: 22 August 2015
;;; Modified: 03 January 2016
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

;;; ---------------------------------------------------------------------------
;;; Function(s):
;;; ---------------------------------------------------------------------------
(defun C:CONVERTLAYERSETFILE ( / file_list default_filename)
  """This function asks a user through a dialog box to specify which files they want to convert
 from .ls3 to .las. Then it calls a sub function (_PROCESS_FILES) which iterates through the list
 of files and converts them appropriately."""

  (init 1 "y" "n")
  (set ans (getkword "/nCreate files in respective directories? [Y]es [N]o:"))
  (setq default_filename (eq ans "y"))
  (setq file_list (LM:GETFILES "Layerset files to convert" "" "ls3"))
  (_PROCESS_FILES file_list default_filename)
  )

;;; ---------------------------------------------------------------------------
;;; Sub Function(s):
;;; ---------------------------------------------------------------------------
(defun _PROCESS_FILES (file_list default_filename / ls3_file las_filename las_file)
  "Recursively iterates through the files specified to process."
  ; Consider using cond to split up statements and allow for output upon success
  (if (and (/= file_list nil) (setq ls3_file (open (car file_list) "r")a))
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
        ; replace with generic *error:
        (print (print (concatenate "\nWARNING: Error creating \"" las_filename "\".")))
        )
      )
    ; replace with generic *error:
    (print (print (concatenate "\nWARNING: Error reading \"" ls3_file "\".")))
    (PROCESS_FILES (cdr file_list) default_filename); Recursive call
    )
  )

(defun _PROCESS_LS3FILE (ls3_file las_file / line layers layer_state)
  "Recursively iterates through the lines in the LS3 File to process."
  (while (setq line (read-line ls3_file))
    (progn
      ; Are we on the first line?
      (if (equal (vl-string-elt line 0) (ascii ";"))

        ; then:
        (progn
          (write-line "0/nLAYERSTATEDICTIONARY/n0/nLAYERSTATE/n1/n" las_file)
          (vl-string-trim ";" line)

          ; Parse ls3 description and use as las name. 09 = HT or tab in ascii
          (write-line (strcat (_READ_TO_DELIMITER line 09) "\n") las_file)
          (write-line "91\n2047\n301\n" las_file)
          ; Parse ls3 author and use as las description.
          (write-line (strcat "Author: "(_READ_TO_DELIMITER line 09) "\n") las_file)
          (write-line "290\n1\n302\n" las_file)
          )

        ; else:
        (progn
          (setq layer_state _PARSE_LAYER_STATE(line)
          ; Is the layer state the current layer?
            (if (equal (last layer_state) 1)
               (cons layer_state layers)
               (append layers layer_state)
              )
            )
          ); else
        ); if
      )
    )
  (write-line (strcat (car (car layers)) "\n")); write current layer.
  (foreach layer layers
    ; Create a list of layer_state's with #1 being the current layer.
    (if(_PRINT_LAYER_STATE layer); if success.
        (_PRINT_LAYER_STATE layer); then
        (print (strcat "Error in processing layer: " (car layer)))
      )
    )
  )

(defun _LS3_STATE_PARSE_STRING (raw_string / ls3_state)
  """
  Creates a layer state with a specific structure from a parsed ls3 line.

  The structure is as follows:
    layer_state[0] = Layer name
    layer_state[1] = Layer state as bit where bits are as follows:
                      1 = Is Frozen
                      2 = Is New VP Frozen
                      4 = Is Locked
                      8 = N/A
                      16 = Is Xref Dependent
                      32 = N/A
                      64 = Is Plottable
                      128 = Is VP Frozen
    layer_state[2] = Color of layer * -1 if layer is off.
    layer_state[3] = Linetype
    layer_state[4] = Line Weight
    layer_state[5] = Plot Style
    layer_state[6] = Is Current Layer (1 if it is, 0 if not)
    layer_state[7] = Error Code as follows:
                       0 = No Error
                       1 = Invalid amount size (# of states) for Layer State
                       2 = Bad value for a state (i.e. color > 255)
  """
  (while (not (equal raw_string "\n"))
    (setq ls3_state (append ls3_state (_READ_TO_DELIMITER raw_stringe 09)))
    )
  (_LS3_STATE_CHECK_FOR_ERROR ls3_state)
  )

(defun _LS3_STATE_CHECK_FOR_ERROR (ls3_state / has_error )
  )

(defun _LAS_STATE_FROM_LS3 (ls3_state)
  """
  Converts a ls3 type layer state to a LAS type layer state.

  The LAS type layer state has the following structure:
    ls3_state[0] = Layer Name as a string.
    ls3_state[1] = Layer state as bits where bits are as follows:
                    1 = Is Off
                    2 = Is Frozen
                    4 = Is Locked
                    8 = Is Plottable
                    16 = Is New VP Frozen
                    32 = Is Vp Frozen
                    64 = N/A
                    128 = N/A
    ls3_state[2] = Color of layer (1 - 255)
    ls3_state[3] = Line weight in 100's of mm, i.e. 211 = 2.11mm
    ls3_state[4] = Line Type as a string.
    ls3_state[5] = Plot Style
    ls3_state[6] = Transperancy
    ls3_state[7] = Error Flag
  """
  (append
    (car ls3_state); name
    (or; Bitwise math for state:
        (> (nth 2 ls3_state) 0)
        (lsh (and ls3_state 1) 1)
        (and ls3_state 4)
        (lsh (and ls3_state 64) -3)
        (lsh (and ls3_state 2) 3)
        (lsh (and ls3_state 128) -2)
      )
    (abs (nth 2 ls3_state)); color
    (nth 4 ls3_state); line weight
    (nth 3 ls3_state); line type
    (nth 5 ls3_state); plot style
    (33554687); Transperancy assumed to be 0.
    (last ls3_state); error flag
    )
  )

(defun _LAS_STATE_PRINT (ls3_state)
  "Prints a layer state to the autocad format with the appriopriate '\n's. Returns nil on error"
  (setq n 0)
  (foreach state ls3_state
    (progn
      (cond
        ((= n 1) (print (strcat "8\n" state)))
        ((= n 2)
          (progn
            )
        )
        )
      (setq n (1+ n))
      )
    )
  )

;;; ---------------------------------------------------------------------------
;;; Helper Function(s):
;;; ---------------------------------------------------------------------------
(defun _READ_TO_DELIMITER (raw_string delimiter_character_code / parsed_string delimiter_position)
  "Returns the string up to delimiter_code and removes it from raw_string."
  (setq delimiter_position (vl-string-position delimiter_character_code raw_string))
  (setq parsed_string (substr raw_string 1 delimiter_position))
  (setq raw_string (substr raw_string (+ 2 delimiter_position) (strlen raw_string)))
  (parsed_string)
  )
