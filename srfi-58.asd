;;;; srfi-58.asd -*- Mode: Lisp;-*-

(cl:in-package :asdf)


(defsystem :srfi-58
  :version "20200314"
  :description "SRFI 58 for CL: Array Notation"
  :long-description "SRFI 58 for CL: Array Notation
https://srfi.schemers.org/srfi-58"
  :author "Aubrey Jaffer"
  :maintainer "CHIBA Masaomi"
  :serial t
  :depends-on (:fiveam
               :srfi-63
               :named-readtables)
  :components ((:file "package")
               (:file "srfi-58")
               (:file "readtable")
               (:file "test")))


(defmethod perform :after ((o load-op) (c (eql (find-system :srfi-58))))
  (let ((name "https://github.com/g000001/srfi-58")
        (nickname :srfi-58))
    (if (and (find-package nickname)
             (not (eq (find-package nickname)
                      (find-package name))))
        (warn "~A: A package with name ~A already exists." name nickname)
        (rename-package name name `(,nickname)))))


(defmethod perform ((o test-op) (c (eql (find-system :srfi-58))))
  (let ((*package*
         (find-package
          "https://github.com/g000001/srfi-58")))
    (eval
     (read-from-string
      "
      (or (let ((result (run 'srfi-58)))
            (explain! result)
            (results-status result))
          (error \"test-op failed\") )"))))


;;; *EOF*
