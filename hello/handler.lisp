
(in-package #:hello)

(defun hello-handler (body)
  (declare (ignore body))
  (values "Hello, world!"
	  "text/plain"))
