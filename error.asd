
(asdf:defsystem #:error
  :description "Test function for AWS Lambda bootstrap"
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190919"
  :depends-on ()
  :components
   ((:module "error"
     :components ((:file "package")
		  (:file "handler" :depends-on ("package"))))))
