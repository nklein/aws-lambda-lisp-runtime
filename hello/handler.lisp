
(in-package #:hello)

(defun handler (body)
  (declare (ignore body))
  (values "Hello, world!"
	  "text/plain"))
