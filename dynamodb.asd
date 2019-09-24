
(asdf:defsystem #:dynamodb
  :description "Test function for AWS Lambda bootstrap using authenticated AWS calls"
  :author "Patrick Stein <pat@nklein.com>"
  :version "0.1.20190923"
  :depends-on (#:zaws)
  :components
   ((:module "dynamodb"
     :components ((:file "package")
                  (:file "handler" :depends-on ("package"))))))
