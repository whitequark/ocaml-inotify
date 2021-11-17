build:
	dune build -p inotify

test: build
	dune runtest

doc:
	dune build @doc

install:
	dune build @install
	dune install

uninstall:
	dune uninstall

clean:
	dune clean

gh-pages: doc
	git clone `git config --get remote.origin.url` .gh-pages --reference .
	git -C .gh-pages checkout --orphan gh-pages
	git -C .gh-pages reset
	git -C .gh-pages clean -dxf
	cp -t .gh-pages/ api.docdir/*
	git -C .gh-pages add .
	git -C .gh-pages commit -m "Update Pages"
	git -C .gh-pages push origin gh-pages -f
	rm -rf .gh-pages

release:
	dune-release

.PHONY: gh-pages release
