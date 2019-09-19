
(defun make-bootstrap (filename)
  (load "cl-bootstrap/cl-bootstrap.asd")
  (asdf:load-system :cl-bootstrap)
  (let ((main (find-symbol "MAIN" "CL-BOOTSTRAP")))
    (ccl:save-application filename
			  :toplevel-function (symbol-function main)
			  :prepend-kernel t)))
