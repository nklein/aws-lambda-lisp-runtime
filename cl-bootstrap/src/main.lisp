
(in-package #:cl-bootstrap)

(defun load-handler (handler-name)
  (let ((asd (make-pathname :directory (getenv "LAMBDA_TASK_ROOT")
			    :name handler-name
			    :type "asd")))
    (asdf:load-asd asd))
  (asdf:require-system (string-downcase handler-name))
  (symbol-function (find-symbol "HANDLER"
				(string-upcase handler-name))))

(defun main ()
  (trace load-handler)
  (trace asdf:require-system)
  (trace asdf:load-system)
  (trace asdf::ensure-all-directories-exist)
  (trace getenv)
  (setf asdf:*user-cache* #P"/tmp/lisp-runtime/cache")
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
					"/response")))
	(multiple-value-bind (response content-type)
	      (funcall handler body)
	   (drakma:http-request response-url
				:method :POST
				:content-type (or content-type
						  "application/json")
				:content response))))))
