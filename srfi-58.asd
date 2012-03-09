;;;; srfi-58.asd -*- Mode: Lisp;-*-

(cl:in-package :asdf)

(defsystem :srfi-58
  :serial t
  :depends-on (:fiveam
               :srfi-63
               :named-readtables)
  :components ((:file "package")
               (:file "srfi-58")
               (:file "readtable")
               (:file "test")))

(defmethod perform ((o test-op) (c (eql (find-system :srfi-58))))
  (load-system :srfi-58)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :srfi-58.internal :srfi-58))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))
