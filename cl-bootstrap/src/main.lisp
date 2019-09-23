
(in-package #:cl-bootstrap)

(defun load-handler (handler-name)
  (let ((asd (make-pathname :directory (getenv "LAMBDA_TASK_ROOT")
			    :name handler-name
			    :type "asd")))
    (asdf:load-asd asd))
  (asdf:require-system (string-downcase handler-name))
  (symbol-function (find-symbol "HANDLER"
				(string-upcase handler-name))))

(defun handle-one-request (handler runtime request-url)
  (multiple-value-bind (body status headers)
        (drakma:http-request request-url
			     :keep-alive t
			     :close nil)
    (declare (ignore status))
    (let* ((request-id (drakma:header-value :lambda-runtime-aws-request-id
					    headers))
	   (base-url (concatenate 'string
				  "http://"
				  runtime
				  "/2018-06-01/runtime/invocation/"
				  request-id))
	   (response-url (concatenate 'string base-url "/response")))
	(handler-case
            (multiple-value-bind (response content-type)
	          (funcall handler body)
	      (drakma:http-request response-url
			           :method :POST
			           :content-type (or content-type
					             "application/json")
			           :content response
			           :keep-alive t
			           :close nil))
	  (t (e)
	     (let ((error-url (concatenate 'string base-url "/error")))
	       (drakma:http-request error-url
			            :method :POST
			            :content-type "text/plain"
			            :content (format nil "~A~%" e)
			            :keep-alive t
				    :close nil)))))))

(defun main-unchecked (runtime)
  (setf asdf:*user-cache* #P"/tmp/lisp-runtime/cache")
  (let* ((handler (load-handler (getenv "_HANDLER")))
	 (request-url (concatenate 'string
				   "http://"
				   runtime
				   "/2018-06-01/runtime/invocation/next")))
    (loop :while t
	  :do (ignore-errors
		(handle-one-request handler runtime request-url)))))

(defun main ()
  (let ((runtime (getenv "AWS_LAMBDA_RUNTIME_API")))
    (handler-case
        (main-unchecked runtime)
      (t (e)
	 (let ((error-url (concatenate 'string
				       "http://"
				       runtime
				       "/2018-06-01/runtime/init/error")))
	   (drakma:http-request error-url
				:method :POST
				:content-type "text/plain"
				:content (format nil "~A~%" e)
				:keep-alive t
				:close nil))))))
