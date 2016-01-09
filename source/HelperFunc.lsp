;;(s* HGG/HelperFuncs
;;; NAME
;;;   HelperFuncs.lsp -- Helper functions used for general AutoLisp work.
;;; COPYRIGHT
;;;   Copyright (C) 2016, Szabolcs Pasztor, All Rights Reserved.
;;; LICENSE
;;;   GPL
;;; TAGS
;;;   list, helper, sub function, sub routine
;;; PURPOSE
;;;   AutoLisp does a shitty job with namespaces and importing modules so I am making my own
;;;   system. Thus, this is basically a header file with a variety of useful functions used fo
;;;   general purpose Autolisp work. Mainly it adds important list manipulation functions that I
;;;   would have thought existed but don't.
;;; AUTHOR
;;;   Szabolcs Pasztor <szabolcs1992@gmail.com>
;;; CREATION DATE
;;;   08 January 2016
;;; MODIFICATION HISTORY
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
;;;   S.P.@01-06-16 -- Debug in Visual Lisp
;;; SEE ALSO
;;;   For info on the style guide:
;;;   |html https://google.github.io/styleguide/lispguide.xml
;;;   For help in understanding the documentation tags see:
;;;   |html https://rfsber.home.xs4all.nl/Robo/
;;)

;;(f* HGG/HelperFuncs/HGG:Get-First-N
;;; NAME
;;;   HGG:Get-First-N -- Returns the first n-max elements of a list.
;;; PURPOSE
;;; DECLARATION
(defun HGG:Get-First-N (lst front-n / n)
;;; ARGUMENTS
;;;   lst -- Any list you can think of you want to manipulate.
;;;   front-n -- The number of elements you want to grab from the front of the list.
;;; VARIABLES
;;;   n -- An iterator used with the repeat in the place of for loops.
;;; RETURN VALUE
;;;   A list composed of the first "n-max" elements of lst.
;;; EXAMPLE
;;;   (setq random-stuff '(gold cash oranges rotten-bananana)
;;;   (setq goodie_bag (HGG:Get-First-N random-stuff 3))
;;;   (princ goodie_bag)
;;;   :> (gold cash oranges)
;;; CALLED BY
;;;   HGG:Replace-N
;;; SOURCE
   (setq n -1)
   (repeat (>= n (- front-n 1))
     (progn
       (1+ n)
       (append (nth n lst))
       )
     )
  )
;;)

;;(f* HGG/HelperFuncs/HGG:Replace-N
;;; NAME
;;;   HGG:Replace-N --  Returns a list with the n'th_element replaced with new-value.
;;; PURPOSE
;;; DECLARATION
(defun HGG:Replace-N (lst new-value nth-element )
;;; ARGUMENTS
;;;   lst --
;;;   new-value --
;;;   nth-element --
;;; RETURN VALUE
;;;   A list composed of lst with the nth-element replaced with new-value.
;;; EXAMPLE
;;;   (setq random-stuff '(gold cash oranges rotten-bananana)
;;;   (setq goodie_bag (HGG:Replace-N random-stuff tasty-bananana 4))
;;;   (princ goodie_bag)
;;;   :> (gold cash oranges tasty-bananana)
;;; CALLS
;;;   HGG:Get-First-N
;;; SOURCE
  (append
    (HGG:Get-First-N lst (- nth-element 1))
    new-value
    (HGG:Get-First-N (reverse lst) (- (length lst) nth-element))
    )
  )
;;)

;;(f* HGG/HelperFuncs/HGG:Read-To-Delimiter
;;; NAME
;;;   HGG:Read-To-Delimiter -- Returns the string up to delimiter_code and removes it from string.
;;; PURPOSE
;;; DECLARATION
(defun HGG:Read-To-Delimiter (string delimiter-character-code / parsed-string delimiter-position)
;;; ARGUMENTS
;;;   string -- The string you want to read
;;;   delimiter-character-code -- The  delimiter to read to in ASCII code.
;;; VARIABLES
;;; ` parsed-string -- The string after being parsed.
;;;   delimiter-position -- Character position in string of the delimiter.
;;; RETURN VALUE
;;; EXAMPLE
;;;   (setq gross-string "The\t quick brown fox jumps over the lispy dog.")
;;;   (first-word (HGG:Read-To-Delimiter gross-string 09)) ;09 = TAB or \t in ascii
;;;   (princ first-word)
;;;   :> "The"
;;;   (princ gross-string)
;;;   :> "The quick brown fox jumps over the lispy dog."
;;; TODO
;;;   S.P.@01-08-16 -- Make it lispy and remove parsed-string as a variable.
;;; SOURCE
;;)
  (setq delimiter-position (vl-string-position delimiter-character-code string))
  (setq parsed-string (substr string 1 delimiter-position))
  (setq string (substr string (+ 2 delimiter-position) (strlen string)))
  parsed-string
  )
