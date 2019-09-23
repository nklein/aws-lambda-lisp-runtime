
(asdf:defsystem #:hello
  :description "Test function for AWS Lambda bootstrap"
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190919"
  :depends-on ()
  :components
   ((:module "hello"
     :components ((:file "package")
                  (:file "handler" :depends-on ("package"))))))
