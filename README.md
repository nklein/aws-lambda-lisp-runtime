
Still in development. Use at your own peril.

    aws lambda publish-layer-version
	--layer-name lisp-runtime
	--zip-file fileb://layer.zip

    aws lambda create-function
	--function-name lisp-hello
	--zip-file fileb://hello.zip
	--handler hello
	--layers <arn from layer-publish above>
	--runtime provided
	--role <arn of a lambda execution role>

    aws lambda invoke --function-name lisp-hello response.txt

