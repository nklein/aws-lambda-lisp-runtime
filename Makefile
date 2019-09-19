
CCL := ccl64

BOOTSTRAP_SOURCES := \
	cl-bootstrap/cl-bootstrap.asd \
	cl-bootstrap/src/package.lisp \
	cl-bootstrap/src/compat-ccl.lisp \
	cl-bootstrap/src/main.lisp

LAYER_FILES := \
	bootstrap

all:	layer.zip
.PHONY: all

clean:
	rm -f bootstrap
	rm -f layer.zip
.PHONY: clean

layer.zip: $(LAYER_FILES)
	zip $@ $^

bootstrap: $(BOOTSTRAP_SOURCES) make-bootstrap.lisp
	$(CCL) --load make-bootstrap.lisp \
		--eval "(make-bootstrap \"$@\")"
