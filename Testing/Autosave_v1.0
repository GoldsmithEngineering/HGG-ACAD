; =========================================================
;   AUTOSAVE.LSP             By:   Jeff Pilcher
;
;   This is an AutoLISP routine for use with the
;   AutoCAD drafting software.
;
;   I am providing this routine to other users of
;   AutoCAD under the SHAREWARE concept. I would
;   like to recover some of the cost of my time
;   spent developing this and other AutoLISP
;   routines for AutoCAD, by asking for voluntary
;   payments.
;
;   If you find this routine is useful to you in
;   doing paying work, please send $5 to:
;
;              Jeffrey S. Pilcher
;
;              Production Systems
;              P.O. Box 218
;              Richmond, IL  60071
;
;              (815) 678-4562
;
;   Obviously $5 is not going to make me rich, or break
;   your bank account.  It will however, show me that
;   someone out there appreciates my efforts, and give
;   me the incentive to write more useful routines.
;
;   I would be very interested in seeing any routines
;   written by you or anyone else. In other words, an
;   exchange of routines would make me as happy as a
;   $5 payment, (well, almost as happy).
;
;   Feel free to pass this routine on to other AutoCAD
;   users, but PLEASE, do not remove these comments.
;
;   Good luck, have fun, and LONG LIVE AutoDESK !!!
;
; =========================================================
;
;
;   This is a routine to automatically save your drawing at
;   regular intervals during the editing session.
;
;   There are a lot of autosave routines out there, but I think
;   this is the most straight forward of the bunch.
;
;   AUTOSAVE.LSP main features:
;
;          1) Can be turned on or off as you see fit.
;
;          2) You specify how often you want to AUTOSAVE.
;
;          3) When it is not time to AUTOSAVE, it tells
;             you how much time is left so you know exactly
;             what is happenning.
;
;          4) When it is AUTOSAVING, it tells you the name
;             of the drawing being AUTOSAVED.
;
;   INSTALLATION:
;
;     To utilize this routine you should include the code portion
;     in your ACAD.LSP file.
;
;     After you have installed AUTOSAVE.LSP in your ACAD.LSP file
;     you will need to include the command "(c:setauto)" as the
;     last statement in your ACAD.LSP file.  This will cause
;     AutoCAD to prompt the user with the message:
;
;         Do you want to do AUTOSAVES ?
;
;     upon entering the drawing editor.
;
;     Then include the command AUTOSAVE  under many of the menu
;     picks in your tablet menu.
;
;
;   OPERATION:
;
;     When you enter the drawing editor, and as the ACAD.LSP
;     file is being loaded, the operator will be asked if he/she
;     would like to do AUTOSAVES:
;
;          Do you want to do AUTOSAVES ?
;
;     A response of [ y ] or [ Y ] will turn AUTOSAVE on, AutoCAD
;     will tell the operator that AUTOSAVE is on with the prompt:
;
;          AUTOSAVE is on.
;
;     Any other response will turn AUTOSAVE off, AutoCAD will
;     tell the operator that AUTOSAVE is off with the prompt:
;
;          AUTOSAVE is off.
;
;     If the operator has chosen to do AUTOSAVES by responding
;     [ y ] or [ Y ] he/she will be asked how often to AUTOSAVE
;     with the prompt:
;
;          How often would you like to AUTOSAVE, in minutes <15>:
;
;     The operator should at this time enter a number indicating
;     how often they would like AutoCAD to AUTOSAVE thier drawing.
;     The default is 15 minutes. If 15 minutes is acceptable,
;     simply hit <ENTER>.
;
;     Upon picking one of the tablet picks which contains the
;     AUTOSAVE command, AutoCAD will check to see how long it has
;     been since it last AUTOSAVED your drawing.  If the time
;     since the last AUTOSAVE has exceeded the desired interval,
;     AutoCAD will automatically save your drawing for you, and
;     tell you what is happenning with the prompt:
;
;          AUTOSAVING:  <dwgname>
;          Please stand by ....
;
;     (never again will you loose 4 hours of work due to a systems
;     crash or power failure).
;
;     If the time since the last AUTOSAVE has not exceeded the
;     desired interval, AutoCAD will tell you with the prompt:
;
;          Not time yet .... xx.x minutes left.
;
;     As you can see, it will tell how much time is left until the
;     next AUTOSAVE.
;
;
;   EXTRA FEATURES:
;
;     The AUTOSAVE routine can be turned on or off at any time you
;     desire while in the drawing editor by typing [ SETAUTO ], at
;     the command prompt, and answering the prompt:
;
;          Do you want to do AUTOSAVES ?
;
;     with the proper response. This prompt is the same prompt you
;     get when you first enter the drawing editor. Therefore you
;     will also be asked to enter a time interval for the AUTOSAVE
;     program. So not only can you turn AUTOSAVVES on or off, but,
;     you can also change the time interval whenever you like.
;
;
(setq saveLocation nil)

(defun setauto ()
  (setq answer (strcase (getstring "\nDo you want to do AUTOSAVES ?  ")))
  (if (> (strlen answer) 1)
    (setq answer (substr answer 1 1))
  )
  (if (= answer "Y")
    (progn
      (prompt "\nAUTOSAVE is on.")
      (print)
      (setq minutes (getreal "\nHow often would you like to AUTOSAVE, in minutes <15>: "))
      (if (= minutes nil)
        (setq minutes 15.0)
      )
      (setq saveLocation (getstring "\nSpecify the location for autosave <SAVEFILEPATH>: "))
      (if (= saveLocation nil)
        (setq saveLocation (getvar "SAVEFILEPATH"))
      )
    )
    (prompt "\nAUTOSAVE is off.")
  )
  (print)
)
(defun C:autosave ()
  (if (= answer "Y")
    (saveit)
    (prompt "\nAUTOSAVE is turned off !")
  )
  (print)
)
(defun saveit ()
  (if (= D1 nil)
    (setq D1 (getvar "DATE"))
  )
  (if (> (* (- (getvar "DATE") D1) 1440.0) minutes)
    (progn
      (setvar "cmdecho" 0)
      (prompt (strcat "\nAUTOSAVING:  " (getvar "dwgname")))
      (prompt "\nPlease stand by .... ")
      (print)
      (command "SAVE" "")
      (prompt "\nAUTOSAVE complete.")
      (prompt "\nThank you for waiting.")
      (setq D1 (getvar "DATE"))
      (setvar "cmdecho" 1)
    )
    (progn
      (prompt "\nNot time yet .... ")
      (princ (rtos (- minutes (* (- (getvar "DATE") D1) 1440.0)) 2 1))
      (princ " minutes left.")
    )
  )
  (print)
)
;
(setauto)
