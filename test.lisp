(cl:in-package "https://github.com/g000001/srfi-58")


(in-readtable :srfi-58)


(def-suite* srfi-58)


#||
  array-prefix :: rank `A' [ dimensions ] [ `:' type-specifier ] |
                       [ `A' ] dimensions [ `:' type-specifier ]

  dimensions :: dimension | dimensions `*' dimension

  dimension :: nonnegative-integer

  rank :: nonnegative-integer

  type-specifier :: `flo' { `C' | `R' } flowidth `b' |
                    `fix' { `Z' | `N' } fixwidth `b' |
                    `flo' `Q' decwidth `d'

  flowidth :: `16' | `32' | `64' | `128'

  fixwidth :: `8' | `16' | `32' | `64'

  decwidth :: `32' | `64' | `128'
||#


(defun read-from-string/sharp-a (str)
  (let ((*readtable* (copy-readtable nil)))
     (set-dispatch-macro-character #\# #\A #'sharp-a)
     (read-from-string str)))


(test read$try-number
  (is (= 888 (with-input-from-string (in "888a")
               (read$try-number in))))
  (is (= 0 (with-input-from-string (in "0a")
             (read$try-number in)))))


(test 2*3
  (let ((a #2A:fixN16b((0 1 2) (3 5 4))))
    (is (= 2 (srfi-63:array-rank a)))
    (is (equal '(2 3) (srfi-63:array-dimensions a))))
  ;;
  (let ((a #2A2*3:fixN16b((0 1 2) (3 5 4))))
    (is (= 2 (srfi-63:array-rank a)))
    (is (equal '(2 3) (srfi-63:array-dimensions a))))
  ;;
  (let ((a #A2*3:fixN16b((0 1 2) (3 5 4))))
    (is (= 2 (srfi-63:array-rank a)))
    (is (equal '(2 3) (srfi-63:array-dimensions a)))))


#|(read$rom-string/sharp-a "#2A:fixN16b((0 1 2) (3 5 4))")|#


;=>  (:RANK 2 :DIMS NIL :TYPE 16 ((0 1 2) (3 5 4)))
;    28

#|(read$rom-string/sharp-a "#2A2*3:fixN16b((0 1 2) (3 5 4))")|#


;=>  (:RANK 2 :DIMS (3 2) :TYPE 16 ((0 1 2) (3 5 4)))
;    31

#|(read$rom-string/sharp-a "#A2*3:fixN16b((0 1 2) (3 5 4))")|#


;;; *EOF*
;=>  (:RANK NIL :DIMS (3 2) :TYPE 16 ((0 1 2) (3 5 4)))
;    30
