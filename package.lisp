;;;; package.lisp

(cl:in-package cl-user)


(defpackage "https://github.com/g000001/srfi-58"
  (:use
   cl
   named-readtables
   fiveam
   "https://github.com/g000001/srfi-63")
  (:shadowing-import-from
   "https://github.com/g000001/srfi-63"
   array-rank
   array-dimensions
   make-array ))


;;; *EOF*
