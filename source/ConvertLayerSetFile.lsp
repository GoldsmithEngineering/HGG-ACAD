;;; ConvertLayerSetFile.LSP -- Custom command designed to convert ls3 files into las files.
;;;
;;; Copyright (C) 2016, Szabolcs Pasztor, All Rights Reserved.
;;;
;;; Author
;;;   Szabolcs Pasztor <szabolcs1992@gmail.com>
;;;
;;; Created:
;;;   22 August 2015
;;;
;;; Modified:
;;;   06 January 2016
;;;
;;; Version:
;;;   1.0.1
;;;
;;; Keywords:
;;;   ls3, convert, las, layerset, layerstate, layer
;;;
;;; Purpose:
;;;   This command is used to convert layer-set (.ls3) files into layer-state (.las) files. This
;;;   allows for compatibility for Goldsmith Engineering from the depreciated layer-set custom
;;;   program.
;;;
;;; Notes:
;;; - I have yet to find "official" specific rules in styling LISP code therefore all code follows
;;;   the Google Common Lisp Style Guide for styling rules with exceptions outlined below.
;;;   For info on the style guide see: https://google.github.io/styleguide/lispguide.xml
;;;
;;;   1)  Because AutoLISP doesn't have organizational structures like name-spaces and key object
;;;       types like classes or structs/enums, the colon is used to "emulate", for simplicity, a
;;;       class like structure. Typical function naming structure is as follows:
;;;
;;;         HGG:[Main-Function-Name]:[Sub-Function-Name]:[Sub-Function-Helper-Name]
;;;
;;;       Similarly for variables:
;;;
;;;         [topic]:[atom=descriptor]
;;;
;;;       It looks a little crazy but I need to know what the fuck I am working with in this crazy
;;;       language.
;;;
;;;   2) All Functions have the first letter of every word capitalized.
;;;
;;;   3) Local Constants should start and end with underscore characters.
;;;
;;; - This file also uses ROBODoc for documentation generation because of the lack of
;;;   documentation tags in AutoLisp.
;;;
;;;   For help in understanding the documentation tags see: http://rfsber.home.xs4all.nl/Robo/
;;;
;;; ToDo:
;;;   (S.P.) @12-20-2015) - Finish layer-state processing.
;;;   (S.P.) @01-06-2016) - Document Code.
;;;   (S.P.) @01-06-2016) - Implement RoboDoc Support
;;;   (S.P.) @01-06-2016) - Implement layer-state accessing (nth # layer-state) using global
;;;                         variables as mock enums to remove the magic numbers.
;;;   (S.P.) @01-06-2016) - Go through code and complete functions.
;;;   (S.P.) @01-06-2016) - Make flowchart of process to understand wtf is going on.
;;;   (S.P.) @01-06-2016) - Debug in Visual Lisp
;;;
;;; Revisions:
;;;
;;; Code:

;;; --------------------------------------------------------------------------
;;; Global Variable(s):
;;; -------------------------------------------------------------------------
(setq +default-LAS-state+ (list "" 64 7 "Continuous" -3 "Color_7" 0 0 ))

;;; ---------------------------------------------------------------------------
;;; Function(s):
;;; ---------------------------------------------------------------------------

;;;;;;;f; HGG/Convert-Ls3-File
;;; NAME
;;;   Convert-Ls3-File -- Convert a Ls3 file to a LAS file through a dialog box. (V0.0.1)
;;;
;;; SYNOPSIS
;;;   Command: HGG:CONVERT-LS3-FILE
;;;
;;; FUNCTION
;;;   This function asks a user through a dialog box to specify which files they want to convert
;;;   from .ls3 to .las. Then it calls a sub function (HGG:Convert-Ls3-File:Process-Files) which
;;;   iterates through the list of files and converts them appropriately.
;;;
;;; USES
;;;   (HGG:Convert-Ls3-File:Process-Files)
;;;   (LM:GETFILES)
;;;
;;; Local Variables:
;;;   (file-list) - The list of ls3 files to process.
;;;   (default-filename) - 'nil' if a custom file directory is provided.
;;;
;;; Returns:
;;;   None.
;;;
;;; ToDo:
;;;   (S.P.) @(01-05-16) - Update the behavior of default-filename to act more like a custom-file-dir-p
;;;
;;;;;;;;;
(defun HGG:Convert-Ls3-File ( / file-list default-filename)
  (init 1 "y" "n")
  (set ans (getkword "/nCreate files in respective directories? [Y]es [N]o:"))
  (setq default-filename (eq ans "y"))
  (setq file-list (LM:GETFILES "Layerset files to convert" "" "ls3"))
  (HGG:Convert-Ls3-File:Process-Files file-list default-filename)
  )

;;; ---------------------------------------------------------------------------
;;; Sub Function(s):
;;; ---------------------------------------------------------------------------
;;; |========
;;;   Recusively processeses the ls3 files.
;;;
;;;   [Multi-line summary]
;;;
;;; Calls:
;;;   (HGG:Convert-Ls3-File:Process-Files)
;;;   (HGG:Convert-Ls3-File:Process-File)
;;;
;;; Parameters:
;;;   (file-list) - List of files to convert from ls3 to las
;;;   (default-filename) - nil if a custom path is not to be used.
;;;
;;; Local Variables:
;;;   (ls3-file) - The currently loaded *.ls3 file.
;;;   (las-filename) - Name of the *.las file to save to.
;;;   (las-file) - The currently loaded *.las file.
;;;
;;; Returns:
;;;   None.
;;;
;;; ToDo:
;;;   (S.P.) @(01-05-16) - Update the behavior of default-filename to act more like a
;;;                        custom-file-dir-p
;;;   (S.P.) @(01-03-16) - Consider using cond to split up statements and allow for output upon
;;;                        success
;;;
;;; Revisions:
;;; ========|
(efun HGG:Convert-Ls3-File:Process-Files (file-list default-filename / ls3-file las-filename las-file)
  (if (and (/= file-list nil) (setq ls3-file (open (car file-list) "r")a))
    (progn
      (print (concatenate "\nLS3 File \"" ls3-file "\" loaded."))
      (if default-filename
        (setq las-filename (vl-string-subst "las" "ls3" ls3-file))
        (setq las-filename (getfiled "Specify location to save layer state file:" "" "las" 0))
        )
      (if (setq las-file (open las-filename "w"))
        (progn
          (HGG:Convert-Ls3-File:Process-File (ls3-file las-file))
          (close ls3-file)
          (close las-file)
          (print (concatenate "\n" las-filename " created."))
          )
        ;; replace with generic *error:
        (print (print (concatenate "\nWARNING: Error creating \"" las-filename "\".")))
        )
      )
    ;; replace with generic *error:
    (print (print (concatenate "\nWARNING: Error reading \"" ls3-file "\".")))
    (HGG:Convert-Ls3-File:Process-Files (cdr file-list) default-filename); Recursive call
    )
  )

;;; |========
;;;   Recursively iterates through the lines in ls3-file to process.
;;;
;;;   [Multi-line summary]
;;;
;;; Calls:
;;;   (HGG:Convert-Ls3-File:Ls3-State:Parse-string)
;;;   (HGG:Convert-Ls3-File:Ls3-State:State-Print)
;;;   (HGG:Read-To-Delimiter)
;;;
;;; Parameters:
;;;   (ls3-file) - The *.ls3 file to be read.
;;;   (las-file) - The *.las file to be written to.
;;;
;;; Local Variables:
;;;   (line) - The current line being read in ls3-file.
;;;   (layers) - A list of all of the layers in the drawing with their corresponing layer-state.
;;;   (layer-state) - The layer-state in LAS format. See documentation for function
;;;                   HGG:Convert-Ls3-File:Ls3-State:From-Ls3 for format.
;;;
;;; Returns:
;;;   None.
;;;
;;; ToDo:
;;;   (S.P.) @(01-05-16) - Make sure it works!
;;;   (S.P.) @(01-05-16) - Make layer-state a LAS type state. Right now it is a LS3 type state
;;;                        because it is calling HGG:Convert-Ls3-File:Ls3-State:Parse-string
;;;                        which returns a LS3 type state!
;;;
;;; ========|
(defun HGG:Convert-Ls3-File:Process-File (ls3-file las-file / line layers layer-state)
  (while (setq line (read-line ls3-file))
    (progn
      ;; Are we on the first line?
      (if (equal (vl-string-elt line 0) (ascii ";"))

        ;; then:
        (progn
          (write-line "0/nLAYERSTATEDICTIONARY/n0/nLAYERSTATE/n1/n" las-file)
          (vl-string-trim ";" line)

          ;; Parse ls3 description and use as las name. 09 = HT or tab in ascii
          (write-line (strcat (HGG:Read-To-Delimiter line 09) "\n") las-file)
          (write-line "91\n2047\n301\n" las-file)
          ;; Parse ls3 author and use as las description.
          (write-line (strcat "Author: "(HGG:Read-To-Delimiter line 09) "\n") las-file)
          (write-line "290\n1\n302\n" las-file)
          )

        ;; else:
        (progn
          (setq layer-state (HGG:Convert-Ls3-File:Ls3-State:Parse-string line))
          ;; Is the layer state the current layer?
            (if (equal (last layer-state) 1
               (cons layer-state layers)
               (append layers layer-state)
              )
            )
          ); else
        ); if
      )
    )
  (write-line (strcat (car (car layers)) "\n")); write current layer.
  (foreach layer layers
    ;; Create a list of layer-state's with #1 being the current layer.
    (if(HGG:Convert-Ls3-File:Ls3-State:State-Print layer); if success.
        (HGG:Convert-Ls3-File:Ls3-State:State-Print layer); then
        (print (strcat "Error in processing layer: " (car layer)))
      )
    )
  )

;;; Creates a layer state in LS3 format from a parsed strin and returns that layer state.
;;;
;;; The LS3 format is based upon the format of a layer state in the *.ls3 file. Reverse
;;; engineering the format and putting it into a list format yields the below form of a list.
;;; Because AutoLISP is a shitty language, the list is being used much like a struct with the
;;; location of each member having a very important identiy.
;;;
;;; The typical structure of string found in a *.ls3 file:
;;;
;;;
;;; The Structure of an ls3-state (see +default-ls3-state+ for default values):
;;; (nth 0 ls3-state) :> "Layer name"
;;; (nth 1 ls3-state) :> Integer being used for bit representation of states.
;;;                      The bits are as follows:
;;;                        1 = Is Frozen
;;;                        2 = Is New VP Frozen
;;;                        4 = Is Locked
;;;                        8 = N/A
;;;                        16 = Is Xref Dependent
;;;                        32 = N/A
;;;                        64 = Is Plottable
;;;                        128 = Is VP Frozen
;;; (nth 2 ls3-state) :> Integer representing color of layer from 1 - 255 and * -1 if the layer
;;;                      is off.
;;; (nth 3 ls3-state) :> Linetype
;;; (nth 4 ls3-state) :> Line Weight
;;; (nth 5 ls3-state) :> Plot Style
;;; (nth 6 ls3-state) :> Is Current Layer (1 if it is, 0 if not)
;;; (nth 7 ls3-state) :> Error Code as follows:
;;;                        0 = No Error
;;;                        1 = Invalid amount size (# of states) for Layer State
;;;                        2 = Bad value for a state (i.e. color > 255) with # being a state
;;;                            numbered 0 - 6.
;;;                        3 = Multiple states were found to be invalid.
;;;                        4 = Unknown error
;;;
;;; Calls:
;;;    (HGG:Convert-Ls3-File:Ls3-State:Check-For-Errors)
;;;    (HGG:Read-To-Delimiter)
;;;
;;; Parameters:
;;;    (string) - The string to be parsed representing the layer state.
;;;
;;; Local Variables:
;;;    (ls3-state) - An LS3 type state.
;;;
;;; Returns:
;;;    The layer state in a LAS type format. See HGG:Convert-Ls3-File:Ls3-State:From-Ls3 for more
;;;    info.
;;;
;;; ToDo:
;;;
;;; Revisions:
;;;    (S.P.) @(01-05-16) - For reducing complexity, have this function return the layer state
;;;                         in a LS3 type format. Makes it more testable as well.
;;;
;;; Code:
(defun HGG:Convert-Ls3-File:Ls3-State:Parse-string (string / ls3-state)
  (while (not (equal string "\n"))
    (setq ls3-state (append ls3-state (HGG:Read-To-Delimiter string 09)))
    )
  (HGG:Convert-Ls3-File:Ls3-State:Check-For-Errors ls3-state)
  )

(defun HGG:Convert-Ls3-File:Ls3-State:Check-For-Errors (ls3-state is_new_state
                                   / _err:no-error_ _err:invalid-size_
                                   _err:bad-value_ _state:max-length_ _state:max-length_
                                   _state:bit-max_ _state:bit-min_ _state:color-max_ _state:color-min_)
  ;; Validates a LAS type later-state and sets the error code on the returned las-state.
  ;;
  ;; The LAS type structure has an error code stored in (nth 7 las-state). This is the error code
  ;; that is set. See [FUNC] for more detail on the LAS type structure.
  ;;
  ;; Excerpt:
  ;; (nth 7 ls3-state) :> Error Code as follows:
  ;;                        0 = No Error
  ;;                        1 = Invalid amount size (# of states) for Layer State
  ;;                        2 = Bad value for a state (i.e. color > 255) with # being a state
  ;;                            numbered 0 - 6.
  ;;                        3 = Multiple states were found to be invalid.
  ;;                        4 = Unknown error
  ;;
  ;; Note that if an error was found in the las-state, the states are set to their default values.
  ;; This may change in the future if the user wishes to give permision on this feature.
  ;;
  ;; Calls:
  ;;    (HGG:Get-First-N)
  ;;    (HGG:Replace-N)
  
  ;; Global Variables used:
  ;;    (+default-state_) - The default values for a LS3 type layer state.
  ;;
  ;; Parameters:
  ;;    (ls3-state) - The layer -state in LS3 Type format.
  ;;    (is_new_state) - A predicate to indicate whether this is a brand new state or not.
  ;;
  ;; Local Variables:
  ;;    None.
  ;;
  ;; Local Constants:
  ;;    (_err:no-error_) -
  ;;    (_err:invalid-size_) -
  ;;    (_err:bad-value_) -
  ;;    (_state:max-length_) -
  ;;    (_state:max-length_) -
  ;;    (_state:bit-max_) -
  ;;    (_state:bit-min_) -
  ;;    (_state:color-max_) -
  ;;    (_state:color-min_) -
  ;;
  ;; Returns
  ;;    The layer state in type LS3 format with an error flag set and states defaulted to normal
  ;;    if an error was found.
  ;;
  ;; ToDo:
  ;;    (S.P) @(01-07-16) - Remove dependency on "is_new_state".
  ;;    (S.P.) @01-06-2016) - Make local constants global.
  ;;
  ;; Revisions:
  ;;
  ;; Code:
  (setq _err:no-error_ 0)
  (setq _err:invalid-size_ 1)
  (setq _err:bad-value_ 20)
  (setq _state:max-length_ 8)
  (if (= is_new_state 1) (1- _state:max-length_))
  (setq _state:max-length_ (1 2 4 16 64 128))
  (setq _state:bit-max_ (+ _state:max-length_))
  (setq _state:bit-min_ 0)
  (setq _state:color-max_ 255)
  (setq _state:color-min_ 0)

  (cond
    ;; If ls3-state length is wrong.
    ((> (length ls3-state) _state:max-length_)
      (append
        (HGG:Get-First-N ls3-state _state:max-length_)
        (_err:invalid-size_)
        )
      )
    ((> (length ls3-state) _state:max-length_)
     (append
       (ls3-state)
       (reverse (cdr (HGG:Get-First-N
                       (reverse +default-las-state+) (- _state:max-length_ (length ls3-state))
                       )))
       (_err:invalid-size_)
       )
     )
    ;; If the state is an invalid state.
    ((or
        ;; State is a number
        (numberp (nth 1 ls3-state))
        ;; State is greater than max bit value or less than min bit value
        (< (nth 1 ls3-state) _state:bit-min_)
        (> (nth 1 ls3-state) _state:bit-max_)
        ;; State is a not a factor of 1 2 4 16 64 or 128.
        (equal (logand (nth 1 ls3-state) 8) 8)
        (equal (logand (nth 1 ls3-state) 32) 32)
        )
     (HGG:Replace-N
       (append (HGG:Get-First-N ls3-state _state:max-length_) (+ _err:bad-value_ 1))
       (nth 1 +default-las-state+)
       1
       )
     )
    ;; If color of layer invalid.
    ((or (> (nth 2 ls3-state) _state:color-max_) (< (nth 2 ls3-state) _state:color-min_))
     (HGG:Replace-N
       (append (HGG:Get-First-N ls3-state _state:max-length_) (+ _err:bad-value_ 2))
       (nth 2 +default-las-state+)
       2
       )
     )
    ;; Line Weight is a number
    ((not (numberp (nth 3 ls3-state)))
     (HGG:Replace-N
       (append (HGG:Get-First-N ls3-state _state:max-length_) (+ _err:bad-value_ 3))
       (nth 3 +default-las-state+)
       3
       )
     )
    ;; Line type is empty
    ((equal (nth 4 ls3-state) "")
     (HGG:Replace-N
       (append (HGG:Get-First-N ls3-state _state:max-length_) (+ _err:bad-value_ 4))
       (nth 4 +default-las-state+)
       4
       )
     )
    ;; Plot style string is in format of Color_###
    (
     (or
       (not (wcmatch (nth 5 ls3-state) "Color_*"))
       (atoi (vl-string-left-trim "Color_" (nth 5 ls3-state)))
       (> (atoi (vl-string-left-trim "Color_" (nth 5 ls3-state))) _state:color-max_)
       (< (atoi (vl-string-left-trim "Color_" (nth 5 ls3-state))) _state:color-min_)
       )
     (HGG:Replace-N
       (append (HGG:Get-First-N ls3-state _state:max-length_) (+ _err:bad-value_ 5))
       (nth 5 +default-las-state+)
       5
       )
     )
    ;; Current Layer is either 0 or 1
    ((equal (member (nth 6 ls3-state) '(0 1)) nil)
     (HGG:Replace-N
       (append (HGG:Get-First-N ls3-state _state:max-length_) (+ _err:bad-value_ 6))
       (nth 6 +default-las-state+)
       6
       )
     )
    )
  )

(defun HGG:Convert-Ls3-File:Ls3-State:From-Ls3 (ls3-state)
  """
  Converts a ls3 type layer state to a LAS type layer state.

  The LAS type layer state has the following structure:
    ls3-state[0] = Layer Name as a string.
    ls3-state[1] = Layer state as bits where bits are as follows:
                    1 = Is Off
                    2 = Is Frozen
                    4 = Is Locked
                    8 = Is Plottable
                    16 = Is New VP Frozen
                    32 = Is Vp Frozen
                    64 = N/A
                    128 = N/A
    ls3-state[2] = Color of layer (1 - 255)
    ls3-state[3] = Line weight in 100's of mm, i.e. 211 = 2.11mm
    ls3-state[4] = Line Type as a string.
    ls3-state[5] = Plot Style
    ls3-state[6] = Transperancy
    ls3-state[7] = Error Flag
  """
  ;; Converts a LS3 type layer-state to a LAS type layer-state.
  ;;
  ;; [Multi-line summary]
  ;;
  ;; Calls:
  ;;
  ;; Parameters:
  ;;
  ;; Local Variables:
  ;;
  ;; Returns:
  ;;
  ;; ToDo:
  ;;
  ;; Revisions:
  ;;
  ;; Code:
  (append
    (car ls3-state); name
    (logior; Bitwise math for state:
        (> (nth 2 ls3-state) 0)
        (lsh (logand ls3-state 1) 1)
        (logand ls3-state 4)
        (lsh (logand ls3-state 64) -3)
        (lsh (logand ls3-state 2) 3)
        (lsh (logand ls3-state 128) -2)
      )
    (abs (nth 2 ls3-state)); color
    (nth 4 ls3-state); line weight
    (nth 3 ls3-state); line type
    (nth 5 ls3-state); plot style
    33554687; Transperancy assumed to be 0.
    (last ls3-state); error flag
    )
  )

(defun HGG:Convert-Ls3-File:Ls3-State:State-Print (ls3-state)
  "Prints a layer state to the AutoCAD format with the appropriate '\n's. Returns nil on error"
  ;; [One-line summary]
  ;;
  ;; [Multi-line summary]
  ;;
  ;; Calls:
  ;;
  ;; Parameters:
  ;;
  ;; Local Variables:
  ;;
  ;; Returns:
  ;;
  ;; ToDo:
  ;;
  ;; Revisions:
  ;;
  ;; Code:
  (setq n 0)
  (foreach state ls3-state
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
(defun HGG:Get-First-N (lst n-max / n)
  "Returns the first n-max elements of a list."
  ;; [One-line summary]
  ;;
  ;; [Multi-line summary]
  ;;
  ;; Calls:
  ;;
  ;; Parameters:
  ;;
  ;; Local Variables:
  ;;
  ;; Returns:
  ;;
  ;; ToDo:
  ;;
  ;; Revisions:
  ;;
  ;; Code:
   (setq n -1)
   (repeat (>= n (- n-max 1))
     (progn
       (1+ n)
       (append (nth n lst))
       )
     )
  )

(defun HGG:Replace-N (lst new-value nth-element )
  "Returns a list with the n'th_element replaced with new-value"
  ;; [One-line summary]
  ;;
  ;; [Multi-line summary]
  ;;
  ;; Calls:
  ;;
  ;; Parameters:
  ;;
  ;; Local Variables:
  ;;
  ;; Returns:
  ;;
  ;; ToDo:
  ;;
  ;; Revisions:
  ;;
  ;; Code:
  (append
    (HGG:Get-First-N lst (- nth-element 1))
    new-value
    (HGG:Get-First-N (reverse lst) (- (length lst) nth-element))
    )
  )

(defun HGG:Read-To-Delimiter (string delimiter-character-code / parsed-string delimiter-position)
  "Returns the string up to delimiter_code and removes it from string."
  ;; [One-line summary]
  ;;
  ;; [Multi-line summary]
  ;;
  ;; Calls:
  ;;
  ;; Parameters:
  ;;
  ;; Local Variables:
  ;;
  ;; Returns:
  ;;
  ;; ToDo:
  ;;
  ;; Revisions:
  ;;
  ;; Code:
  (setq delimiter-position (vl-string-position delimiter-character-code string))
  (setq parsed-string (substr string 1 delimiter-position))
  (setq string (substr string (+ 2 delimiter-position) (strlen string)))
  parsed-string
  )

;; Program continuation:
(vl-load-com)
(princ)
;;; ConvertLayerSetFile.LSP