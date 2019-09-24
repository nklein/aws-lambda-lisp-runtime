
(asdf:defsystem #:cl-bootstrap
  :description "Package for bootstrapping AWS Lambda handlers in Lisp"
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190923"
  :depends-on (#:drakma #:zaws #:cl-json)
  :components
   ((:module "src"
     :components ((:file "package")
                  #+ccl (:file "compat-ccl" :depends-on ("package"))
                  (:file "main" :depends-on ("package"
                                             #+ccl "compat-ccl"))))))
