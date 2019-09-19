
(in-package #:hello.GET)

(defun handler (body)
  (declare (ignore body))
  (values "Hello, world!"
	  "text/plain"))
