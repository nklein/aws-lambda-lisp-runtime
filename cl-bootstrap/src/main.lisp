
(in-package #:cl-bootstrap)

(defun load-asd (handler-name)
  (let ((asd-path (make-pathname :directory (getenv "LAMBDA_TASK_ROOT")
				 :name handler-name
				 :type "asd")))
    (load asd-path)))

(defun load-handler (handler-name)
  (let ((package-name (string-upcase handler-name)))
    (load-asd handler-name)
    (asdf:load-system package-name)
    (symbol-function (find-symbol "HANDLER" package-name))))

(defun main ()
  (let* ((handler (load-handler (getenv "_HANDLER")))
	 (runtime (getenv "AWS_LAMBDA_RUNTIME_API"))
	 (request-url (concatenate 'string
				   "http://"
				   runtime
				   "/2018-06-01/runtime/invocation/next")))
    (multiple-value-bind (body status headers)
          (drakma:http-request request-url)
      (declare (ignore status))
      (let* ((request-id (drakma:header-value "Lambda-Runtime-Aws-Request-Id"
					     headers))
	     (response-url (concatenate 'string
					"http://"
					runtime
					"/2018-06-01/runtime/invocation/"
					request-id
					"/response"))
	     (response (funcall handler body)))
	(drakma:http-request response-url
			     :method :POST
			     :content response)))))
