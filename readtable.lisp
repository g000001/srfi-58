;;;; readtable.lisp

(cl:in-package :srfi-58.internal)
(in-readtable :common-lisp)

(defreadtable :srfi-58
  (:merge :standard)
  (:dispatch-macro-char #\# #\a #'sharp-a)
  (:case :upcase))
