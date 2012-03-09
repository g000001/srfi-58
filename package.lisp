;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :srfi-58
  (:use)
  (:export))

(defpackage :srfi-58.internal
  (:use :srfi-58 :cl :named-readtables :fiveam))

