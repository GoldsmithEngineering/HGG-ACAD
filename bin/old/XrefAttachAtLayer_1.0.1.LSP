; For those who xref drawings to use a backgrounds for their detailing or modeling work...
;
; This will load an xref and put it on its own locked layer.
; The new layer will be named by prepending an "XR-" to the drawing name of the xref
; The routine finishes by returning the user to the current working layer
;
; I wrote this because my layer management in loading xrefs eventually becomes an ankle biter.
; I don't always remember to get the xref on a locked layer.  When I do this step, I don't always
; remember to get out of the locked layer before returning to the model.  This routine prevents
; this "shoot-myself-in-the-foot" behavior by handling all of the layer management in the
; background.  "lnl" is my acronym for load and lock.

(defun C:XAL (/ a current_layer xref_data new_layer update_current_layer update_xref_data)                                

  (setq current_layer (getvar "CLAYER"))

  (command "_xattach" "~")

  (while (/= (getvar "CmdActive") 0) (command pause))

  (setq xref_data (entget (entlast)))

  (setq new_layer (cdr (assoc 2 xref_data)))

  (setq new_layer (strcat "0_" new_layer))

  (command "-layer" "make" new_layer "")
  
  (setq update_current_layer (getvar "CLAYER"))

  (setq update_xref_data (subst (cons 8 update_current_layer) (assoc 8 xref_data) xref_data))

  (entmod update_xref_data)

  (setvar "CLAYER" current_layer)

);-defun
