
(defun make-bootstrap (filename)
  (load "cl-bootstrap/cl-bootstrap.asd")
  (ql:quickload :cl-bootstrap)
  (asdf:clear-configuration)
  (asdf:clear-source-registry)
  (let ((main (find-symbol "MAIN" "CL-BOOTSTRAP")))
    (ccl:save-application filename
			  :toplevel-function (symbol-function main)
			  :prepend-kernel t)))
