;;;; readtable.lisp

(cl:in-package "https://github.com/g000001/srfi-58")


(in-readtable :common-lisp)


(defreadtable :srfi-58
  (:merge :standard)
  (:dispatch-macro-char #\# #\a #'sharp-a)
  (:case :upcase))


;;; *EOF*
