
(in-package #:dynamodb)

(defclass ddb-query (zaws:request zaws:json-auth-v3)
  ((action :initarg :action
           :accessor action))
  (:default-initargs :host "dynamodb.us-east-1.amazonaws.com"
    :content-type "application/x-amz-json-1.0"
    :method :post
    :uri-path "/"))

(defmethod zaws:prepare-for-signing :after ((request ddb-query))
  (zaws:ensure-header "x-amz-target"
                      (format nil "DynamoDB_20111205.~A"
                              (action request))
                      request))

(defun dynamodb-handler (body)
  (declare (ignore body))
  (let ((req (make-instance 'ddb-query
                            :action "ListTables"
                            :content "{}")))
    (let ((rsp (zaws:submit req)))
      (values (format nil "~S~%~A" rsp (map 'string
                                            #'code-char
                                            (zaws:content rsp)))
              "text/plain"))))
