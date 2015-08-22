;;; acad.LSP -- AutoCAD file that specifies setup and auto loading for functions.
;;
;;; Copyright (C) 2015, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <szabolcs1992@gmail.com>
;;; Created: 05 July 2015
;;; Modified: 22 August 2015
;;; Version: 1.0.1
;;; Keywords: acad, load, setup, lsp
;;;
;;; Commentary: This file is used to setup AutoCAD on a first time install such that AutoCAD
;;;             works with the standard tools and setup desired by Goldsmith Engineering.
;;;             It is designed to do the following:
;;;             - Recognizes if this is a first time install (relative to the version of the file)
;;;             - If it is, setup all of the supported paths and settings to match the companies 
;;;               standards.
;;;             - Set the variables found in "_Load_Variables" to ensure similar work-flow:
;;;
;;; To Do:
;;;
;;; Revisions:
;;;     1.0.1 (S.P. @ 07-05-2015)   Added Documentation and cross checked all calls.
;;;     1.0.1 (S.P. @ 07-26-2015)   Defined MYSTARTUP for initial loading.
;;;     1.0.1 (S.P. @ 08-16-2015)   Finished _Load_Variables
;;;     1.0.1 (S.P. @ 08-22-2015)   Finished TODO items.
;;;
;;; Code:

(defun C:_Load_Variables (/ i)
  "Sets all of the default AutoCAD system variables and prompts an error if one or more ~
   variables were not set."
  (let _acad_vars '(
    ("FONTALT" "LER.SHX")    ; Add Leroy as alternative font.
    ("INDEXCTL" 3)           ; Layer and spatial indexes are created.
    ("ISAVEPERCENT" 0)       ; Makes every save a full save (for higher performance).
    ("XLOADCTL" 2)           ; Turns on demand-loading. Copies of referenced drawings are
                             ; opened and ; locked referenced drawings are not locked (for
                             ; higher performance.)
    ("DIMASSOC" 2)           ; Allows exploded dimensions to retain their association.
    ("INSUNITS" 0)           ; Sets the units for insertions to unitless.
    ("FULLPLOTPATH" 0)       ; Sends the full path of the drawing file to the plotter.
    ("MAXACTVP" 64)          ; Set max viewports to 64 (maximum value)
    ("PLINETYPE" 2)          ; Polylines in AutoCAD Release 14 or older drawings are
                             ; converted when opened; PLINE creates optimized polylines.
    ("SDI" 0)                ; Allows for multiple drawings to be opened in AutoCAD.
    ("navvcubedisplay" 0)    ; Turn off viewcube for 2d and 3d visual styles.
    ("maxsort" 10000)        ; Sets the maximum number of items such as file names, layer
                             ; names, and block names that are sorted alphabetically in
                             ; dialog boxes, drop-down lists, and palettes. 
    ("textfill" 1)           ; Displays text as filled images.
    ("dctmain" "enu")        ; Set main dictionary to American English.
    ("menubar" 1)            ; Displays the menu bar.
    ("ATTDIA" 1)             ; Uses a dialog box for insert command.
    ("ATTMODE" 1)            ; Visibly attributes are displayed and invisible are not.
    ("UCSICON" 0)            ; The USC Icon is hidden.
    ("PROXYGRAPHICS" 0)      ; Saves images of proxy objects into drawing
    )
  )

  (let _variables_set 0)
  (loop for i in acad_vars
    (if (= (getvar i) (cdr (assoc i)))
      (incf _variables_set)
      (progn
        (setvar i (cdr (assoc i)))
        (if (= (getvar i) (cdr (assoc i)))
          (incf _variables_set)
          )
        )
      )
    )
  (if (/= _variables_set (length acad_vars))
    (prompt "Some system variables were set improperly. ~
             Contact your AutoCAD administrator for help.")
  )

(defun C:_Load_Functions
  "Sets all of the custom AutoCAD Functions and prompts an error for a function if the function ~
   was unable to be loaded."

  ;; DISCONTINUED CODE (I believe not implemented in support path):
  ;;(defun C:AC   () (if (null C:ACRES)     (load "ACRES"))     (C:ACRES)    (princ))
  ;;(defun C:BI   () (if (null C:BLKINFO)   (load "BLKINFO"))   (C:BLKINFO)  (princ))
  ;;(defun C:CR   () (if (null C:COPYROT)   (load "COPYROT"))   (C:COPYROT)  (princ))
  ;;(defun C:CT   () (if (null C:CURVETIC)  (load "CURVETIC"))  (C:CURVETIC) (princ))
  ;;(defun C:F180 () (if (null C:FLIP180)   (load "FLIP180"))   (C:FLIP180)  (princ))
  ;;(defun C:F270 () (if (null C:FLIP270)   (load "FLIP270"))   (C:FLIP270)  (princ))
  ;;(defun C:F45  ()  (if (null C:FLIP45)   (load "FLIP45"))    (C:FLIP45)   (princ))
  ;;(defun C:F90  () (if (null C:FLIP90)    (load "FLIP90"))    (C:FLIP90)   (princ))
  ;;(defun C:FF   () (if (null C:FFILLET)   (load "FFILLET"))   (C:FFILLET)  (princ))
  ;;(defun C:FL   () (if (null C:FLATTEN)   (load "FLATTEN"))   (C:FLATTEN)  (princ))
  ;;(defun C:LM   () (if (null C:LMAKE)     (load "LMAKE"))     (C:LMAKE)    (princ))
  ;;(defun C:MVS  () (if (null C:MVSETUP)   (load "MVSETUP"))   (C:MVSETUP)  (princ))
  ;;(defun C:NR   () (if (null C:NUMBER)    (load "NUMBER"))    (C:NUMBER)   (princ))
  ;;(defun C:PD   () (if (null C:PLUD)      (load "PLUD"))      (C:PLUD)     (princ))
  ;;(defun C:PRO   () (if (null C:PROFILES)   (load "PROFILES"))   (C:PROFILES)  (princ))
  ;;(defun C:SN   () (if (null C:STATION)   (load "STATION"))   (C:STATION)  (princ))
  ;;(defun C:TF   () (if (null C:TEXTFLIP)  (load "TEXTFLIP"))  (C:TEXTFLIP) (princ))
  ;;(defun C:TI   () (if (null C:TEXTINC)   (load "TEXTINC"))   (C:TEXTINC)  (princ))
  ;;(defun C:TL   () (if (null C:TLINE)     (load "TLINE"))     (C:TLINE)    (princ))
  ;;(defun C:TRN  () (if (null C:TEXTRND)   (load "TEXTRND"))   (C:TEXTRND)  (princ))
  ;;(command "._UNDEFINE" "PLOT")
  ;;(command "._UNDEFINE" "LL")
  ;;(command "._INSERT" "*Acad" "0,0,0" "" "")
  (let acad_funcs '(
                    ;; Functions to add before project deployment:
                    ;; - PLTSTAMP
                    ;; - CLOSETRAVERSE
                    ;; - CONVERTLAYERSETFILE
                    ;; - QTOTAL
                    ("CLEAN" C:CNN)
                    ("NESTEDPROBE" C:PB)
                    ("SUPERQUICKSAVE" C:SSS)
                    ("XREFATTACHATLAYER" C:XAL)
                    ("TRANSFERELEVATIONS" C:TRANSFERELEVATIONS)
                    ("EXPORTELEVATIONS" C:EXPORTELEVATIONS)
                    ("IMPORTELEVATIONS" C:IMPORTELEVATIONS)
                    )
    )

  (loop for i in acad_funcs
    (progn
      (defun (cdr (assoc i)) ()
        (if (null (cdr (assoc i)))
          (load i)
          (prompt (concatenate 'string "Function " i
                               " unable to load. Contact your AutoCAD administrator for help.")
                  )
          )
        (cdr (assoc i))
        )
      )
    )
  )

(defun-q MYSTARTUP
    "Startup function to be appended to S::STARTUP."

    (_Load_Variables)
    (_Load_Functions)
  )

(setq S::STARTUP (append S::STARTUP MYSTARTUP))
 
