;;(s* HGG/acad.LSP
;;; NAME
;;;   acad.lsp -- AutoCAD file that specifies setup and auto loading for functions. (V0.0.1) 
;;; COPYRIGHT
;;;   Copyright (C) 2016, Szabolcs Pasztor, All Rights Reserved
;;; LICENSE
;;;   GPL
;;; TAGS
;;;   acad, ls3, setup, startup, load
;;; PURPOSE
;;;   This file is used to setup AutoCAD on a first time install such that AutoCAD works with the
;;;   standard tools and setup desired by Goldsmith Engineering.
;;;   It is designed to do the following:
;;;     - Recognizes if this is a first time install (relative to the version of this file)
;;;     - If it is, setup all of the supported paths and settings to match the companies 
;;;       standards.
;;;     - Set the variables found in "_Load_Variables" to ensure similar work-flow:
;;; AUTHOR
;;;   Szabolcs Pasztor <szabolcs1992@gmail.com>
;;; CREATION DATE
;;;   05 July 2015
;;; MODIFICATION HISTORY
;;;   05 July 2015 -- Added Documentation and cross checked all calls.
;;;   26 July 2015 -- Defined MYSTARTUP for initial loading.
;;;   16 September 2015 -- Finished _Load_Variables
;;;   22 September 2015 -- Finished TODO items.
;;;   24 April 2016 -- Added RoboDoc Support
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
;;; SEE ALSO
;;;   For info on the style guide:
;;;   |html https://google.github.io/styleguide/lispguide.xml
;;;   For help in understanding the documentation tags see:
;;;   |html https://rfsber.home.xs4all.nl/Robo/
;;)

;;(f* HGG/ConvertLayerSetFile/HGG:Load-Variables
;;; NAME
;;;   HGG:Load_Variables -- A simple Autocad System Variable setup function. (V0.0.1)
;;; PURPOSE
;;;   Sets all of the default AutoCAD system variables and prompts an error if one or more variables
;;;   were not set.
;;; DECLARATION
(defun HGG:Load-Variables (/ +acad-vars+ acad-var vars-left-to-load total-vars-set)
;;; VARIABLES:
;;;   +acad-vars+ -- List of Autocad Variables to be set. Variables are defined as ("NAME" VALUE).
;;;   acad-var -- Current Autocad Variable being set.
;;;   vars-left-to-load -- List of Autocad Variables still left to be loaded.
;;;   total-vars-set -- Total number of variables loaded.
;;; EXAMPLE
;;;   :> Command: (HGG:Load-Variables)
;;; CALLS
;;; TODO
;;;   S.P.@04-24-16 -- Debug in Visual Lisp
;;; SOURCE
  (let +acad-vars+ '(
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
    ("FILEDIA" 1)            ; Sets the file dialog box to show whenever a file is being opened.
    )
  )

  (setq total-vars-set 0)
  (setq vars-left-to-load +acad-vars+)
  (repeat (length +acad-vars+)
    (setq acad-var (car vars-left-to-load))
    (if (= (getvar (car acad-var)) (cdr acad-var))
      (progn
        (setvar (car acad-var) (cdr acad-var))
        (if (= (getvar (car acad-var)) (cdr acad-var))
          (1+ total-vars-set)
          )
        )
      )
    (setq vars-left-to-load (cdr vars-left-to-load))
    )
  (if (/= total-vars-set (length +acad-vars+))
    (prompt "Some system variables were set improperly. ~
             Contact your AutoCAD administrator for help.")
    )
  )
;;)

;;(f* HGG/ConvertLayerSetFile/HGG:Load-Functions
;;; NAME
;;;   HGG:Load-Functions -- A simple Function loading function. (V0.0.1)
;;; PURPOSE
;;;   Loads all of the custom AutoCAD Functions and prompts an error for a function if the function
;;;   was unable to be loaded.
;;; DECLARATION
(defun HGG:Load-Functions (/ +acad-funcs+)
;;; VARIABLES:
;;; EXAMPLE
;;;   :> Command: (HGG:Load-Functions)
;;; CALLS
;;; TODO
;;;   S.P.@04-24-16 -- Debug in Visual Lisp
;;; SOURCE

  (let +acad-funcs+ '(
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

  (setq funcs-left-to-load +acad-funcs+)
  (repeat (length +acad-funcs+)
    (defun (cdr (car funcs-left-to-load)) ()
      (load (car (car funcs-left-to-load))
        (prompt 
          (strcat
            "Function "
            (car (car funcs-left-to-load))
            " unable to load. Contact your AutoCAD administrator for help."
            )
          )
        )
      )
    (cdr (car funcs-left-to-load))
    (setq funcs-left-to-load (cdr funcs-left-to-load))
    )
  )
;;)

;;(f* HGG/ConvertLayerSetFile/HGG:Load-Functions
;;; NAME
;;;   HGG:Startup -- Startup function to be appended to S::STARTUP. (V0.0.1)
;;; PURPOSE
;;;   The main driver that sets up AutoCAD to work as Goldsmith Engineering desires.
;;; DECLARATION
(defun-q HGG:Startup
;;; EXAMPLE
;;;   :> Command: (HGG:Load-Functions)
;;; CALLS
;;;   HGG:Load-Variables
;;;   HGG:Load-Functions
;;; TODO
;;;   S.P.@04-24-16 -- Debug in Visual Lisp
;;; SOURCE
    (HGG:Load-Variables)
    (HGG:Load-Functions)
  )
;;)

;; Program Continuation:
(setq S::STARTUP (append S::STARTUP HGG:Startup))
;;; acad.LSP
