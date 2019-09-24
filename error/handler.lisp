
(in-package #:error)

(defun error-handler (body)
  (declare (ignore body))
  (error "Problem"))
