
(asdf:defsystem #:error
  :description "Test function for AWS Lambda bootstrap to test error handling"
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190923"
  :depends-on ()
  :components
   ((:module "error"
     :components ((:file "package")
                  (:file "handler" :depends-on ("package"))))))
