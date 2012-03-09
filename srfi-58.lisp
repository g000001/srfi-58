;;;; srfi-58.lisp

(cl:in-package :srfi-58.internal)

(defvar *eof* (list nil))

(defun eof-object? (c)
  (eq *eof* c))


;;; Read integer up to first non-digit
(defun read..try-number (port &rest  ic)
  (let ((chr0 (char-code #\0)))
    (labels ((iter (arg)
               (let ((c (peek-char nil port nil *eof* T)))
                 (cond ((eof-object? c) NIL)
                       ((digit-char-p c)
                        (iter (+ (* 10 (or arg 0))
                                 (- (char-code (read-char port)) chr0))))
                       (:else arg)))))
      (iter (and (not (null ic)) (- (char-code (car ic)) chr0))))))

(defun bomb (pc wid)
  (error (format nil
                 "~@{~A~^ ~}"
                 'array 'syntax? "#" 'rank "A" pc wid)))

(defun read-array-type (port)
  (case (char-downcase (peek-char nil port nil *eof* T))
    ((#\:) (read-char port)
     (let* ((typ (labels ((iter (arg)
                           (declare (optimize (debug 0) (space 3)))
                           (if (= 4 (length arg))
                               (intern (coerce (reverse arg) 'string))
                               (let ((c (read-char port)))
                                 (and (not (eof-object? c))
                                      (iter (cons (char-upcase c) arg)))))))
                  (iter 'nil)))
            (wid (and typ (not (eq 'bool typ)) (read..try-number port))))
       (flet ((check-suffix (chrs)
                ;; (print (list :chrs chrs))
                (let ((chr (read-char port)))
                  (if (and (characterp chr)
                           (not (member (char-downcase chr) chrs)))
                      (error "array-type?: ~A ~A ~A" typ wid chr)))))
         (let ((prot (assoc typ `((floC
                                   (128 . ,#'a:floc128b)
                                   (64  . ,#'a:floc64b)
                                   (32  . ,#'a:floc32b)
                                   (16  . ,#'a:floc16b))
                                  (floR
                                   (128 . ,#'a:flor128b)
                                   (64  . ,#'a:flor64b)
                                   (32  . ,#'a:flor32b)
                                   (16  . ,#'a:flor16b))
                                  (fixZ
                                   (64 . ,#'a:fixz64b)
                                   (32 . ,#'a:fixz32b)
                                   (16 . ,#'a:fixz16b)
                                   (8  . ,#'a:fixz8b))
                                  (fixN
                                   (64 . ,#'a:fixn64b)
                                   (32 . ,#'a:fixn32b)
                                   (16 . ,#'a:fixn16b)
                                   (8  . ,#'a:fixn8b))
                                  (char . #'vector)
                                  (bool . #'vector))
                            :test #'equal)))
           ;; (print (list :prot prot :typ typ))
           (if prot (setq prot (cdr prot)))
       (cond ((consp prot)
              (setq prot (assoc wid (cdr prot)))
              (if (consp prot) (setq prot (cdr prot)))
              (if wid (check-suffix (if (and (floatp prot) (realp prot))
                                        '(#\b #\d)
                                        '(#\b)))))
             (prot)
             (:else (check-suffix '())))
       prot))))
    (otherwise NIL)))

#|(defun list->uniform-array (&rest args)
  args)|#

;;; We come into read..array with number or #f for RANK.
#|(defun read..array (rank dims port reader)
  (let ((rank (or rank
                  (and (char-equal reader #\a)
                       1))))
    (labels ((iter (dims)
                   (declare (optimize (debug 0) (space 3)))
                   (let ((dim (read..try-number port)))
                     (if dim
                         (iter (cons dim dims))
                         (case (peek-char nil port)
                           ((#\*) (read-char port) (iter dims))
                           ((#\:)
                            (let ((typ (read-array-type port)))
                              (list->uniform-array rank dims typ (read port) )))
                           (oterwise
                            (list->uniform-array rank dims nil (read port) )))))))
      (iter dims) )))|#

(defun read..array (rank dims port reader)
  (declare (ignore reader))
  (labels ((iter (dims)
                 (declare (optimize (debug 0) (space 3)))
                 (let ((dim (read..try-number port)))
                   (if dim
                       (iter (cons dim dims))
                       (case (peek-char nil port)
                         ((#\*) (read-char port) (iter dims))
                         ((#\:)
                          (let ((typ (read-array-type port)))
                            (list->uniform-array rank
                                                 (reverse dims)
                                                 typ
                                                 (read port) ) ))
                         (oterwise
                          (list->uniform-array rank
                                               (reverse dims)
                                               nil
                                               (read port) ) ))))))
    (iter dims) ))

(defun list->uniform-array (rank dims type list)
  (let ((rank (or rank (let ((dim (length dims)))
                         (if (zerop dim) 1 dim) ) )))
    (srfi-63:list->array rank (funcall type) list) ))

(defun read..sharp (c port read)
  (let ((rank read))
  (case c
    ((#\a #\A) (read..array rank '() port c))
    ((#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9)
     (let* ((num (read..try-number port c))
            (chr (peek-char nil port)))
       (case chr
         ((#\a #\A) (read-char port)
          (read..array num '() port c))
         ((#\*) (read-char nil port)
          (read..array rank (list num) port c))
         (:else
          (read..array 1 (list num) port c)))))
    (otherwise
     (error "unknown # object ~A" c)))))

(defun sharp-a (stream char arg)
  (read..sharp char stream arg))

;;; eof
