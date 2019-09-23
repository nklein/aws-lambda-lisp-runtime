
CCL := ccl64

BOOTSTRAP_SOURCES := \
	cl-bootstrap/cl-bootstrap.asd \
	cl-bootstrap/src/package.lisp \
	cl-bootstrap/src/compat-ccl.lisp \
	cl-bootstrap/src/main.lisp

HELLO_FILES := \
	hello.asd \
	hello/package.lisp \
	hello/handler.lisp

LAYER_FILES := \
	bootstrap

all:	layer.zip hello.zip hello-bootstrap.zip
.PHONY: all

clean:
	rm -f bootstrap
	rm -f layer.zip
	rm -f hello.zip
	rm -f hello-bootstrap.zip
.PHONY: clean

layer.zip: bootstrap
	zip $@ $^

hello.zip: $(HELLO_FILES)
	zip $@ $^

hello-bootstrap.zip: bootstrap $(HELLO_FILES)
	zip $@ $^

bootstrap: $(BOOTSTRAP_SOURCES) make-bootstrap.lisp
	$(CCL) --load make-bootstrap.lisp \
		--eval "(make-bootstrap \"$@\")"
