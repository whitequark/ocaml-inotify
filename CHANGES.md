
## 2.6

add an Eio backend in a new inotify-eio package (@patricoferris, @akirak, @clecat)

## 2.5

add @since tags
dune: add dependency to unix library
adds pure operators

## 2.4.1

Add version.
remove <features.h>
chore: CI for gh-pages

## 2.4

add action to automatically publish docs
add status badge
try to use github actions
explicit dep on ocaml version
fix link for documentation
fix makefile issue
update README.md
build: port inotify from oasis to dune
test: correct thread type error
opam: add ocamlbuild as a dependency
Fix 4.02 build.

## 2.3

Always allocate a buffer of the maximum size for reading.
Update `make release` to use opam-publish.

add multidistro Travis testing support

## 2.2

Add watch_of_int to support symmetric deserializers
Remove non-functional OS X stubs, drop ancient glibc support
OS X is not a supported platform
Add test information to the opam file
Actually fix CI.
Lint opam file.
Fix CI.

## 2.1

Add `make release` for OASIS.
README: Use ppx style in example code.
opam: Add oasis as build dependency.
Update for latest findlib.
Move findlib pin to master.
Update README.
Improve docs.
Use less horrible desugared syntax in place of try_lwt.
Remove camlp4 syntax from test_inotify_lwt.ml.
bytes → Bytes.t; bytes is not available on pre-4.02.
Use patched findlib
Use trunk findlib.
OASIS is required on CI.
-safe-string would break on pre-4.02.
Add opam file.
Add Document and SourceRepository sections in _oasis.
Use oasis dynamic mode.
Fix leftover >> by lwt extension.
OCaml 4.02 compatibility.
Remove dependency on camlp4.
Enable more warnings.

## 2.0

Only build tests if --enable-tests is passed.
Add dependency installation instructions to README.
Use ENOENT to test error reporting.
Migrate to OUnit 2.
Add Travis config.
Bump version to 2.0 due to incompatible changes.
Report offending path when raising in inotify_add_watch.
Update README.
Rewrite Inotify.read in idiomatic OCaml and make it more efficient.
Use more sensible names for Inotify items.
Rewrite C stubs and properly raise Unix.Unix_error.
Add Lwt_inotify.try_read.
Perform proper unit testing.

## 1.5

Update version number.
Update Makefile to ignore tests on Darwin.
Update version number.
Implement Lwt wrapper.

## 1.4

Remove oasis autogens.
Updated oasis setup.
Initial.
