
(in-package #:error)

(defun handler (body)
  (declare (ignore body))
  (error "Problem"))
