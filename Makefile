default: build

setup.ml: _oasis
	oasis setup

build: setup.ml
	ocaml setup.ml -configure
	ocaml setup.ml -build

test:
ifeq ($(shell uname -s),Darwin)
	@echo "No inotify tests on Darwin"
else
	ocamlfind ocamlc \
          -linkpkg \
          -o test/test-inotify \
          -package inotify \
          test/test_inotify.ml
	test/runtests.sh
endif

install: setup.ml
	ocamlfind remove inotify
	ocaml setup.ml -install

clean:
	rm -rf \
          *.native \
          _build \
          test/test-inotify \
          {lib,test}/*.{cmi,cmo,cma,cmx}

.PHONY: build install test clean
