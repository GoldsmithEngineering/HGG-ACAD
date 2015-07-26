;;; acad.LSP -- AutoCAD file that specifies setup and auto loading for functions.
;;
;;; Copyright (C) 2015, Creative Commons License.
;;;
;;; Author: Szabolcs Pasztor <szabolcs1992@gmail.com>
;;; Created: 05 July 2015
;;; Modified: 26 July 2015
;;; Version: 1.0.1
;;; Keywords: acad, load, setup, lsp
;;;
;;; Commentary: This file is used to setup AutoCAD on a first time install such that AutoCAD
;;;             functions with the standard tools and setup desired by Goldsmith Engineering.
;;;             It is designed to do the following: ;;;             - Recognizes if this is a first time install (relative to the version of the file)
;;;             - If it is, setup all of the supported paths and settings to match the companies 
;;;               standards.
;;;             - Set the following variables to ensure similar work-flow:
;;;                 FONTALT = "LER.SHX"
;;;                 INDEXCTL = 3
;;;                 ISAVEPERCENT = 0
;;;                 XLOADCTL = 2
;;;                 DIMASSOC = 2
;;;                 INSUNIS = 0
;;;                 FULLPLOTPATH - 0
;;;                 MAXACTVP = 64
;;;                 PLINETYPE = 2
;;;                 SDI = 0
;;;                 NAVVCUBEDDISPLAY = 0
;;;                 MAXSORT = 10000
;;;                 TEXTFILL = 1
;;;                 DCTMAIN = "enu"
;;;                 MENUBAR = 1
;;;                 ATTDIA = 1
;;;                 ATTMODE = 1
;;;                 UCSICON = 0
;;;                 PROXYGRAPHICS = 0
;;;
;;; To Do:
;;;     (S.P. @ 07-05-2015)         Create a function for initial loading (defun SETUP)
;;;     (S.P. @ 07-05-2015)         Clean up unnecessary / legacy code.
;;;     (S.P. @ 07-05-2015)         Add finished custom functions to auto load.
;;;     (S.P. @ 07-05-2015)         Cross check aliases that are changed and set.
;;;
;;; Revisions:
;;;     1.0.1 (S.P. @ 07-05-2015)   Added Documentation and cross checked all calls.
;;;     1.0.1 (S.P. @ 07-26-2015)   Defined MYSTARTUP for initial loading.
;;;
;;; Code:

(defun C:LOAD_VARS
    "Sets all of the default AutoCAD system variables."
    (setvar "FONTALT" "LER.SHX")    ; Add Leroy as alternative font.
    (setvar "INDEXCTL" 3)           ; Layer and spatial indexes are created.
    (setvar "ISAVEPERCENT" 0)       ; Makes every save a full save (for higher performance).
    (setvar "XLOADCTL" 2)           ; Turns on demand-loading. Copies of referenced drawings are
                                    ; opened and ; locked referenced drawings are not locked (for
                                    ; higher performance.)
    (setvar "DIMASSOC" 2)           ; Allows exploded dimensions to retain their association.
    (setvar "INSUNITS" 0)           ; Sets the units for insertions to unitless.
    (setvar "FULLPLOTPATH" 0)       ; Sends the full path of the drawing file to the plotter.
    (setvar "MAXACTVP" 64)          ; Set max viewports to 64 (maximum value)
    (setvar "PLINETYPE" 2)          ; Polylines in AutoCAD Release 14 or older drawings are
                                    ; converted when opened; PLINE creates optimized polylines.
    (setvar "SDI" 0)                ; Allows for multiple drawings to be opened in AutoCAD.
    (setvar "navvcubedisplay" 0)    ; Turn off viewcube for 2d and 3d visual styles.
    (setvar "maxsort" 10000)        ; Sets the maximum number of items such as file names, layer
                                    ; names, and block names that are sorted alphabetically in
                                    ; dialog boxes, drop-down lists, and palettes. 
    (setvar "textfill" 1)           ; Displays text as filled images.
    (setvar "dctmain" "enu")        ; Set main dictionary to American English.
    (setvar "menubar" 1)            ; Displays the menu bar.
    (setvar "ATTDIA" 1)             ; Uses a dialog box for insert command.
    (setvar "ATTMODE" 1)            ; Visibly attributes are displayed and invisible are not.
    (setvar "UCSICON" 0)            ; The USC Icon is hidden.
    (setvar "PROXYGRAPHICS" 0)      ; Saves images of proxy objects into drawing

    ;; Add check to see if all system variables are set.
    ;;
    ;; Psuedo code:
    ;;
    ;; for each element in dictionary of system variables:
    ;;  if var = element var i++
    ;;
    ;; if i = # of all system variables to set
    ;;  return true
    ;; else:
    ;;  return false
)

(defun-q MYSTARTUP
    "Startup function to be appended to S::STARTUP."

    (command "._UNDEFINE" "PLOT")
    (command "._UNDEFINE" "LL")
    (command "._INSERT" "*Acad" "0,0,0" "" "")
)

(setq S::STARTUP (append S::STARTUP MYSTARTUP))
 
(load "PLTSTAMP")

;; DEFINED FUNCTIONS:
(defun C:AC   () (if (null C:ACRES)     (load "ACRES"))     (C:ACRES)    (princ))
(defun C:BI   () (if (null C:BLKINFO)   (load "BLKINFO"))   (C:BLKINFO)  (princ))
(defun C:CR   () (if (null C:COPYROT)   (load "COPYROT"))   (C:COPYROT)  (princ))
(defun C:CT   () (if (null C:CURVETIC)  (load "CURVETIC"))  (C:CURVETIC) (princ))
(defun C:F180 () (if (null C:FLIP180)   (load "FLIP180"))   (C:FLIP180)  (princ))
(defun C:F270 () (if (null C:FLIP270)   (load "FLIP270"))   (C:FLIP270)  (princ))
(defun C:F45  ()  (if (null C:FLIP45)   (load "FLIP45"))    (C:FLIP45)   (princ))
(defun C:F90  () (if (null C:FLIP90)    (load "FLIP90"))    (C:FLIP90)   (princ))
(defun C:FF   () (if (null C:FFILLET)   (load "FFILLET"))   (C:FFILLET)  (princ))
(defun C:FL   () (if (null C:FLATTEN)   (load "FLATTEN"))   (C:FLATTEN)  (princ))
(defun C:LM   () (if (null C:LMAKE)     (load "LMAKE"))     (C:LMAKE)    (princ))
(defun C:MVS  () (if (null C:MVSETUP)   (load "MVSETUP"))   (C:MVSETUP)  (princ))
(defun C:NR   () (if (null C:NUMBER)    (load "NUMBER"))    (C:NUMBER)   (princ))
(defun C:PD   () (if (null C:PLUD)      (load "PLUD"))      (C:PLUD)     (princ))
(defun C:PRO   () (if (null C:PROFILES)   (load "PROFILES"))   (C:PROFILES)  (princ))
(defun C:QT   () (if (null C:QTOTAL)    (load "QTOTAL"))    (C:QTOTAL)   (princ))
(defun C:SN   () (if (null C:STATION)   (load "STATION"))   (C:STATION)  (princ))
(defun C:TF   () (if (null C:TEXTFLIP)  (load "TEXTFLIP"))  (C:TEXTFLIP) (princ))
(defun C:TI   () (if (null C:TEXTINC)   (load "TEXTINC"))   (C:TEXTINC)  (princ))
(defun C:TL   () (if (null C:TLINE)     (load "TLINE"))     (C:TLINE)    (princ))
(defun C:TRN  () (if (null C:TEXTRND)   (load "TEXTRND"))   (C:TEXTRND)  (princ))

;; HGG DEFINED FUNCTIONS:
(defun C:CNN   () (if (null C:CLEAN)     (load "CLEAN"))     (C:CNN)    (princ))
(defun C:PB   () (if (null C:NESTEDPROBE)    (load "NESTEDPROBE"))    (C:PB)   (princ))
(defun C:SSS  () (if (null C:SUPERQUICKSAVE)    (load "SUPERQUICKSAVE"))    (C:SSS)   (princ))
(defun C:XAL  () (if (null C:XREFATTACHATLAYER)   (load "XREFATTACHATLAYER"))   (C:XAL)  (princ))

(PRINC)

(load "K:\\common\\Brian_Goldsmith\\_Config\\acad2016.lsp" "--> Failed to Load: acad2016")
(load "K:\\common\\Brian_Goldsmith\\_Config\\ACADDOCCreatorV1-1.lsp" "--> Failed to Load: ACADDOCCreatorV1-1")
(load "K:\\common\\Brian_Goldsmith\\_Config\\acad2016.lsp" "--> Failed to Load: acad2016")
(load "K:\\common\\Brian_Goldsmith\\_Config\\ACADDOCCreatorV1-1.lsp" "--> Failed to Load: ACADDOCCreatorV1-1")
