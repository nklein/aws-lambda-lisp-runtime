
CCL := ccl64

BOOTSTRAP_SOURCES := \
	cl-bootstrap/cl-bootstrap.asd \
	cl-bootstrap/src/package.lisp \
	cl-bootstrap/src/compat-ccl.lisp \
	cl-bootstrap/src/main.lisp

hello_FILES := \
	hello.asd \
	hello/package.lisp \
	hello/handler.lisp

error_FILES := \
	error.asd \
	error/package.lisp \
	error/handler.lisp

dynamodb_FILES := \
	dynamodb.asd \
	dynamodb/package.lisp \
	dynamodb/handler.lisp

LAYER_FILES := \
	bootstrap

SAMPLE_FUNCTIONS := \
	hello \
	error \
	dynamodb

all:	layer.zip $(patsubst %,%.zip,$(SAMPLE_FUNCTIONS))
.PHONY: all

clean:
	rm -f bootstrap
	rm -f layer.zip
.PHONY: clean

bootstrap: $(BOOTSTRAP_SOURCES) make-bootstrap.lisp
	$(CCL) --load make-bootstrap.lisp \
		--eval "(make-bootstrap \"$@\")"

layer.zip: $(LAYER_FILES)
	zip $@ $^

define ZIP_template =
$(1).zip: $$($(1)_FILES)
	zip $$@ $$^

$(1)-bootstrap.zip: bootstrap $$($(1)_FILES)
	zip $$@ $$^

clean-$(1):
	rm -f $(1).zip
	rm -f $(1)-bootstrap.zip
.PHONY: clean-$(1)

clean: clean-$(1)
endef

$(foreach func,$(SAMPLE_FUNCTIONS),$(eval $(call ZIP_template,$(func))))
