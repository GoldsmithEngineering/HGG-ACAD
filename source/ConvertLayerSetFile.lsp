;;(s* HGG/ConvertLayerSetFile
;;; NAME
;;;   ConvertLayerSetFile -- Custom command designed to convert ls3 files into las files. (v1.0.1)
;;; COPYRIGHT
;;;   Copyright (C) 2016, Szabolcs Pasztor, All Rights Reserved.
;;; LICENSE
;;;   GPL
;;; TAGS
;;;   ls3, convert, las, layerset, layerstate, layer
;;; PURPOSE
;;;   This command is used to convert layer-set (.ls3) files into layer-state (.las) files. This
;;;   allows for compatibility for Goldsmith Engineering from the depreciated layer-set custom
;;;   program.
;;; AUTHOR
;;;   Szabolcs Pasztor <szabolcs1992@gmail.com>
;;; CREATION DATE
;;;   22 August 2015
;;; MODIFICATION HISTORY
;;;   08 January 2016 -- Added RoboDoc Support
;;; STATUS
;;;   Development
;;; NOTES
;;; - I have yet to find "official" specific rules in styling LISP code therefore all code follows
;;;   the Google Common Lisp Style Guide for styling rules with exceptions outlined below.
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
;;; BUGS
;;; TODO
;;;   S.P.@12-20-15 -- Finish layer-state processing.
;;;   S.P.@01-06-16 -- Document Code.
;;;   S.P.@01-06-16 -- Implement RoboDoc Support
;;;   S.P.@01-06-16 -- Implement layer-state accessing (nth # layer-state) using global
;;;                    variables as mock enums to remove the magic numbers.
;;;   S.P.@01-06-16 -- Go through code and complete functions.
;;;   S.P.@01-06-16 -- Make flowchart of process to understand wtf is going on.
;;;   S.P.@01-06-16 -- Debug in Visual Lisp
;;; SEE ALSO
;;;   For info on the style guide:
;;;   |html https://google.github.io/styleguide/lispguide.xml
;;;   For help in understanding the documentation tags see:
;;;   |html https://rfsber.home.xs4all.nl/Robo/
;;)

;;(g* HGG/ConvertLayerSetFile/HGG:+default-las-state+
;;; NAME
;;;   Default-LAS-state -- The default layer state of LAS type.
;;; DECLARATION
(setq +default-LAS-state+ (list "" 64 7 "Continuous" -3 "Color_7" 0 0 ))
;;; TODO
;;;   S.P.@01-07-16 -- Refactor to include "HGG" mock name space.
;;)
(load "GetFilesv1-4.lsp"
      (progn
        (princ "ERROR: GetFilesv1-4.lsp not found in load path. Function will now exit.")
        (exit)
        )
      )

;;(f* HGG/ConvertLayerSetFile/HGG:Convert-Ls3-File
;;; NAME
;;;   Convert-Ls3-File -- Convert a Ls3 file to a LAS file through a dialog box. (V0.0.1)
;;; PURPOSE
;;;   This function asks a user through a dialog box to specify which files they want to convert
;;;   from .ls3 to .las. Then it calls a sub function (HGG:Convert-Ls3-File:Process-Files) which
;;;   iterates through the list of files and converts them appropriately.
;;; DECLARATION
(defun HGG:Convert-Ls3-File ( / file-list custom-dir-p)
;;; VARIABLES:
;;;   ans -- The answer for input from the user.
;;;   file-list -- The list of ls3 files to process.
;;;   custom-dir-p -- 'nil' if a custom file directory is requested.
;;; EXAMPLE
;;;   :> Command: HGG:CONVERT-LS3-FILE
;;; CALLS
;;;   HGG:Convert-Ls3-File:Process-Files
;;;   LM:GETFILES
;;; TODO
;;; SOURCE
  (initget "Yes" "No")
  (set ans (getkword "/nCreate files in respective directories? [Y]es [N]o, default is Yes:"))
  (setq custom-dir-p (if (or (= ans "Yes") (not ans) ) nil ans))
  (setq file-list (LM:GETFILES "Layerset files to convert" "" "ls3"))
  (HGG:Convert-Ls3-File:Process-Files file-list custom-dir-p)
  )
;;)

;;(f* HGG/ConvertLayerSetFile/HGG:Convert-Ls3-File:Process-Files
;;; NAME
;;;   HGG:Convert-Ls3-File:Process-Files -- Recusively processeses the ls3 files.
;;; PURPOSE
;;;   From a file list using the default filename, this function will recursively go through
;;;   the file list and create a LAS type file for each member in the list.
;;; DECLARATION
(defun HGG:Convert-Ls3-File:Process-Files (file-list default-filename / ls3-file las-filename las-file)
;;; ARGUMENTS
;;;   file-list -- List of files to convert from ls3 to las.
;;;   default-filename -- A predicate wannabe used to determine if the default filename
;;; VARIABLES
;;;   ls3-file -- The ls3-file being read to create the las-file.
;;;   las-filename -- The path of the las-file to write to.
;;;   las-file -- The las-file that is being written to.
;;; EXAMPLE
;;;   (HGG:CONVERT-Ls3-File:Process-Files new_file-list is_default)
;;; CALLS
;;;   HGG:CONVERT-Ls3-File:Process-Files
;;;   HGG:Convert-Ls3-File:Process-File
;;; CALLED BY
;;;   HGG:CONVERT-Ls3-File:Process-Files
;;;   HGG:Convert-Ls3-File
;;; TODO
;;;   S.P.@01-05-16 -- Update the behavior of default-filename to act more like a
;;;                    custom-file-dir-p.
;;;   S.P.@01-03-16 -- Consider using cond to split up statements and allow for output upon
;;;                    success.
;;; SOURCE
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
;;)

;;(f* HGG/ConvertLayerSetFile/HGG:Convert-Ls3-File:Process-Files
;;; NAME
;;;   HGG:Convert-Ls3-File:Process-Files -- From a ls3 file, builds a las file.
;;; PURPOSE
;;;   Writes to las-file in the format specified in NOTES by parsing each line in the ls3-file.
;;;   This function will also princ an error message when the parsing has failed somehow and will
;;;   print the layerstate with the failed values set to the default found in HGG:+default-state+.
;;; DECLARATION
(defun HGG:Convert-Ls3-File:Process-File (ls3-file las-file / line layers layer-state)
;;; ARGUMENTS
;;;   ls3-file -- The *.ls3 file to be read.
;;;   las-file -- The *.las file to be written to.
;;; VARIABLES
;;;   line -- The current line being read in ls3-file.
;;;   layers -- A list of all of the layers in the drawing with their corresponing layer-state.
;;;   layer-state -- The layer-state in LAS format. See documentation for function
;;;                  HGG:Convert-Ls3-File:Ls3-State:From-Ls3 for format.
;;; EXAMPLE
;;;   (HGG:Convert-Ls3-File:Process-File ls3-file-to-read-from las-file-to-write-to)
;;; CALLS
;;;   HGG:Convert-Ls3-File:Ls3-State:Parse-string
;;;   HGG:Convert-Ls3-File:Ls3-State:State-Print
;;;   HGG:Read-To-Delimiter
;;; CALLED BY
;;;   HGG:CONVERT-Ls3-File:Process-Files
;;; NOTES
;;; TODO
;;;   S.P.@01-05-16 -- Make sure it works!
;;;   S.P.@01-05-16 -- Make layer-state a LAS type state. Right now it is a LS3 type state
;;;                    because it is calling HGG:Convert-Ls3-File:Ls3-State:Parse-string
;;;                    which returns a LS3 type state!
;;; SOURCE
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
;;)

;;(f* HGG/ConvertLayerSetFile/HGG:Convert-Ls3-File:Ls3-State:Parse-String
;;; NAME
;;;   HGG:Convert-Ls3-File:Ls3-State:Parse-String
;;; PURPOSE
;;;   Builds a LS3 type state from a string to parse. This function is used for parsing invdividual
;;;   LS3 type strings into a ls3 type layer state list.
;;; DECLARATION
(defun HGG:Convert-Ls3-File:Ls3-State:Parse-string (string / ls3-state)
;;; ARGUMENTS
;;;   string -- The string to be parsed representing the layer state.
;;; VARIABLES
;;;   ls3-state -- An LS3 type state.
;;; RETURN VALUE
;;;   The layer state in a LAS type format. See HGG:Convert-Ls3-File:Ls3-State:From-Ls3 for more
;;;   info.
;;; EXAMPLE
;;;   (HGG:Convert-Ls3-File:Ls3-State:Parse-String line-from-ls3-file)
;;; CALLS
;;;   HGG:Convert-Ls3-File:Ls3-State:Check-For-Errors
;;;   HGG:Read-To-Delimiter
;;; CALLED BY
;;;   HGG:Convert-Ls3-File:Process-File
;;; NOTES
;;;   The LS3 format is based upon the format of a layer state in the *.ls3 file. Reverse
;;;   engineering the format and putting it into a list format yields the below form of a list.
;;;   Because AutoLISP is a shitty language, the list is being used much like a struct with the
;;;   location of each member having a very important identiy.
;;;
;;;   The typical structure of string found in a *.ls3 file:
;;;
;;;
;;;   The Structure of an ls3-state (see +default-ls3-state+ for default values):
;;;   (nth 0 ls3-state) :> "Layer name"
;;;   (nth 1 ls3-state) :> Integer being used for bit representation of states.
;;;                        The bits are as follows:
;;;                          1 = Is Frozen
;;;                          2 = Is New VP Frozen
;;;                          4 = Is Locked
;;;                          8 = N/A
;;;                          16 = Is Xref Dependent
;;;                          32 = N/A
;;;                          64 = Is Plottable
;;;                          128 = Is VP Frozen
;;;   (nth 2 ls3-state) :> Integer representing color of layer from 1 - 255 and * -1 if the layer
;;;                        is off.
;;;   (nth 3 ls3-state) :> Linetype
;;;   (nth 4 ls3-state) :> Line Weight
;;;   (nth 5 ls3-state) :> Plot Style
;;;   (nth 6 ls3-state) :> Is Current Layer (1 if it is, 0 if not)
;;;   (nth 7 ls3-state) :> Error Code as follows:
;;;                          0 = No Error
;;;                          1 = Invalid amount size (# of states) for Layer State
;;;                          2 = Bad value for a state (i.e. color > 255) with # being a state
;;;                              numbered 0 - 6.
;;;                          3 = Multiple states were found to be invalid.
;;;                          4 = Unknown error
;;; TODO
;;;   S.P.@01-05-16 -- For reducing complexity, have this function return the layer state
;;;                    in a LS3 type format. Makes it more testable as well.
;;;   S.P.@01-06-16 -- Try to remove the local variable and just build the list to check as you go.
;;; SOURCE
  (while (not (equal string "\n"))
    (setq ls3-state (append ls3-state (HGG:Read-To-Delimiter string 09)))
    )
  (HGG:Convert-Ls3-File:Ls3-State:Check-For-Errors ls3-state)
  )
;;)

;;(f* HGG/ConvertLayerSetFile/HGG:Convert-Ls3-File:Ls3-State:Check-For-Errors
;;; NAME
;;;   HGG:Convert-Ls3-File:Ls3-State:Check-For-Errors
;;; PURPOSE
;;;   Validates a LAS type later-state and sets the error code on the returned las-state.
;;; DECLARATION
(defun HGG:Convert-Ls3-File:Ls3-State:Check-For-Errors (ls3-state is_new_state
                                   / _err:no-error_ _err:invalid-size_
                                   _err:bad-value_ _state:max-length_ _state:factors_
                                   _state:bit-max_ _state:bit-min_ _state:color-max_ _state:color-min_)
;;; ARGUMENTS
;;;   ls3-state -- The layer -state in LS3 Type format.
;;;   is_new_state -- A predicate to indicate whether this is a brand new state or not.
;;; VARIABLES
;;;   _err:no-error_ -- (Constant) The error code for No Error.
;;;   _err:invalid-size_ -- (Constant) The error code for a layer sate of invalid size.
;;;   _err:bad-value_ -- (Constant) The error code for a layer state with a bad value.
;;;   _state:max-length_ -- (Constant) The max number of properties in a layer state.
;;;   _state:factors_ -- (Constant) The possible bits that could be on in the layer state.
;;;   _state:bit-max_ -- (Constant) The maximum value that a layer state bit could have.
;;;   _state:bit-min_ -- (Constant) The minimum value that a layer state bit could have.
;;;   _state:color-max_ -- (Constant) The maximum value that a color in a layer state could have.
;;;   _state:color-min_ -- (Constant) The minimum value that a color in a layer state could have.
;;; RETURN VALUE
;;;   The layer state in type LS3 format with an error flag set and states defaulted to normal
;;;   if an error was found.
;;; EXAMPLE
;;; CALLS
;;;   HGG:Get-First-N
;;;   HGG:Replace-N
;;;   +default-state+
;;; CALLED BY
;;; NOTES
;;;   The LAS type structure has an error code stored in (nth 7 las-state). This is the error code
;;;   that is set. See [FUNC] for more detail on the LAS type structure.
;;;
;;;   Excerpt:
;;;   (nth 7 ls3-state) :> Error Code as follows:
;;;                          0 = No Error
;;;                          1 = Invalid amount size (# of states) for Layer State
;;;                          2 = Bad value for a state (i.e. color > 255) with # being a state
;;;                              numbered 0 - 6.
;;;                          3 = Multiple states were found to be invalid.
;;;                          4 = Unknown error
;;;
;;;   Note that if an error was found in the las-state, the states are set to their default values.
;;;   This may change in the future if the user wishes to give permision on this feature.
;;; TODO
;;;   S.P.@01-07-16 -- Remove dependency on "is_new_state".
;;;   S.P.@01-06-16 -- Make local constants global.
;;; SOURCE
  (setq _err:no-error_ 0)
  (setq _err:invalid-size_ 1)
  (setq _err:bad-value_ 20)
  (setq _state:max-length_ 8)
  (if (= is_new_state 1) (1- _state:max-length_))
  (setq _state:factors_ (1 2 4 16 64 128))
  (setq _state:bit-max_ (+ _state:factors_))
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
;;)

;;(f* HGG/ConvertLayerSetFile/HGG:Convert-Ls3-File:Ls3-State:From-Ls3
;;; NAME
;;;   HGG:Convert-Ls3-File:Ls3-State:From-Ls3
;;; PURPOSE
;;;   Converts a ls3 type layer state to a LAS type layer state.
;;; DECLARATION
(defun HGG:Convert-Ls3-File:Ls3-State:From-Ls3 (ls3-state)
;;; ARGUMENTS
;;;   ls3-state -- An LS3 type layer state to be converted.
;;; RETURN VALUE
;;;   A LAS type layer state that has the following structure:
;;;     (nth # las-state) :> [group code], [value]
;;;     (nth 0 las-state) :>   8, Layer Name as a string.
;;      (nth 1 las-state) :>  90, Layer state saved as a bit where bit values are as follows:
    ;;                             1 = Is Off
    ;;                             2 = Is Frozen
    ;;                             4 = Is Locked
    ;;                             8 = Is Plottable
    ;;                             16 = Is New VP Frozen
    ;;                             32 = Is Vp Frozen
    ;;                             64 = N/A
    ;;                             128 = N/A
;;      (nth 2 las-state) :>  62, Color of layer (1 - 255)
;;      (nth 3 las-state) :> 370, Line weight in 100's of mm, i.e. 211 = 2.11mm
;;      (nth 4 las-state) :>   6, Line Type as a string.
;;      (nth 5 las-state) :>   2, Plot Style
;;      (nth 6 las-state) :> 440, Transperancy
;;      (nth 7 las-state) :> Error Flag
;;; EXAMPLE
;;;   (setq ls3-state (list "Test layer" 64 7 "Continuous" 211 Color_7 0 0))
;;;   (princ (HGG:Convert-Ls3-File:Ls3-State:From-Ls3 ls3-state))
;;;   ;:> ((8 "Test Layer") (90 8) (62 7) (370 211) (6 "Continuous) (2 Color_7) (440 33554687) 0)
;;; CALLS
;;; CALLED BY
;;; NOTES
;;; TODO
;;; SOURCE
  (append
    (list 8 (car ls3-state)); Layer Name with group code.
    (list 90; Group code
          (logior; Bitwise math for state:
            (> (nth 2 ls3-state) 0)
            (lsh (logand ls3-state 1) 1)
            (logand ls3-state 4)
            (lsh (logand ls3-state 64) -3)
            (lsh (logand ls3-state 2) 3)
            (lsh (logand ls3-state 128) -2)
            )
          )
    (list 62 (abs (nth 2 ls3-state))); Layer color with group code.
    (list 370 (nth 4 ls3-state)); Layer line weight with group code.
    (list 6 (nth 3 ls3-state)); Layer line type with group code.
    (list 2 (nth 5 ls3-state)); Layer plot style with group code.
    (list 440 33554687); Layer transperancy assumed to be 0 with group code.
    (list (last ls3-state)); error flag
    )
  )
;;)

;;(f* HGG/ConvertLayerSetFile/HGG:Convert-Ls3-File:Ls3-State:State-Print
;;; NAME
;;;   HGG:Convert-Ls3-File:Ls3-State:State-Print
;;; PURPOSE
;;;   Prints a layer state to the AutoCAD format with the appropriate '\n's. Returns nil on error.
;;; DECLARATION
(defun HGG:Convert-Ls3-File:Ls3-State:State-Print (las-state / _state:printable-attribute-size_
                                                             attribute string-to-return)
;;; ARGUMENTS
;;;   las-state -- The layer state to print.
;;; VARIABLES
;;;   _state:printable-attribute-size_ -- (Constant) The size of an attribute that can be printed.
;;;                                       This should always be two because a LAS type state with
;;;                                       an printable attribute is defined as:
;;;                                         ([group code] [value])
;;;                                       An attribute without a group code is just meta data.
;;;   attribute -- An attribute of the layer state ie. the layer name.
;;;   string-to-return -- The string to return.
;;; RETURN VALUE
;;;   A giant string that represents the layer to be printed to stdout.
;;; EXAMPLE
;;;   (setq ls3-state (list "Test layer" 64 7 "Continuous" 211 Color_7 0 0))
;;;   (setq las-state (HGG:Convert-Ls3-File:Ls3-State:From-Ls3 ls3-state))
;;;   (princ (HGG:Convert-Ls3-File:Ls3-State:State-Print))
;;;   ;:> 
;;;   ;:> 8
;;;   ;:> Test Layer
;;;   ;:> 90
;;;   ;:> 8
;;;   ;:> 62
;;;   ;:> 7
;;;   ;:> 370
;;;   ;:> 211
;;;   ;:> 6
;;;   ;:> Continuous
;;;   ;:> 2
;;;   ;:> Color_7
;;;   ;:> 440
;;;   ;:> 33554687
;;; CALLS
;;; CALLED BY
;;; NOTES
;;; TODO
;;;   S.P.@01-08-16 -- Finish Function
;;; SOURCE
;;)
  (setq _state:printable-attribute-size_ 2)
  (setq string-to-return "")
  (foreach attribute las-state
    (if (= (length attribute  _state:printable-attribute-size_)
      (setq (strcat string-to-return "\n" (vl-princ-to-string (car attribute)) "\n"
                    (vl-princ-to-string (cdr attribute)))
      )
    )
  (string-to-return)
  )
;; Program continuation:
(vl-load-com)
(princ)
;;; ConvertLayerSetFile.LSP
