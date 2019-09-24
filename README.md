AWS Lambda Lisp Runtime
=======================

This package can be built and used as a layer to provide a Common Lisp runtime for AWS Lambda.

This package also includes several example functions that demonstrate the runtime in action.


Building
--------

To build this package, one needs an Amazon EC2 instance (or other machine) running the Amazon Linux 2 distribution.
This instance also needs [Clozure Common Lisp][ccl] installed along with [Quicklisp][quick]

[ccl]: https://ccl.clozure.com/
[quick]: https://quicklisp.org/

Once those are installed, one can use `make` to build the runtime and the examples:

    make

Deploying The Runtime
---------------------

If you have Lambda access from your EC2 instance, you can deploy the built runtime by typing:

    aws lambda publish-layer-version
        --layer-name lisp-runtime
        --zip-file fileb://layer.zip

Alternately, from the AWS web console, you can navigate to the `Layers` panel on the `Lambda` service page.
From there, you can press `Create Layer` and upload the `layer.zip` file.

You will need the layer's `Version ARN` to use it with the sample functions.
The `Version ARN` is returned from the `publish-layer-version` command.
It is also visible on the `Layers` panel of the `Lambda` service page on the AWS web console.

Deploying The Sample Functions
------------------------------

If you have Lambda access from your EC2 instance, you can deploy the built runtime by typing:

    aws lambda create-function
        --function-name lisp-hello
        --zip-file fileb://hello.zip
        --handler HELLO:HELLO-HANDLER
        --layers <arn from layer-publish above>
        --runtime provided
        --role <arn of a lambda execution role>

This will create a new AWS Lambda function called `lisp-hello`.
This function is handled by the method `hello-handler` in the `hello` package.
The runtime will load the `hello.asd` file, find the `HELLO` package, and find the `HELLO-HANDLER` function within that package.
The `role` is the ARN of the role the AWS Lambda function will use while running.
So, if you are making a function that requires read-only S3 access, the `role` should identify a role with that access.

Alternately, from the AWS web console, you can navigate to the `Functions` panel on the `Lambda` service page.
From there, you can press `Create Function`.
Select the `Author from scratch` option at the top.
Provide a name for your function.
Select `Provide your own bootstrap` from the `Runtime` dropdown.
Select the execution role you desire.
Press `Create function`.

Once the function is created, you can click on the `Layers` box in the `Designer` window.
This will open up a box below the `Designer` window that will let you `Add a layer` and select your lisp runtimer layer.
You will have to select `Provide a layer version ARN` and provide the `Version ARN` for the layer.

In the `Function code` section, you can select `Upload a .zip file` from the `Code entry type` drop-down menu and upload the `hello.zip` file.
Make sure to set the `Handler` in the `Function code` section to `HELLO:HELLO-HANDLER`.

The other sample function handlers are:
* `error.zip` has handler `ERROR:ERROR-HANDLER` which throws a Lisp error to exercise the Lambda error mechanism
* `dynamodb.zip` has handler `DYNAMODB:DYNAMODB-HANDLER` which calls the method `dynamodb:ListTables` to exerices invoking AWS actions from within the Lambda handler.

Invoking The Sample Functions
-----------------------------

If you have Lambda access from your EC2 instance, you can deploy the built runtime by typing:

    aws lambda invoke
        --function-name lisp-hello
        response.txt

The output from the AWS Lambda function will be written to  `response.txt`.
