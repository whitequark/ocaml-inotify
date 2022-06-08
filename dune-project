(lang dune 2.9)
(generate_opam_files true)
(version 2.4)

(name inotify)
(license LGPL-2.1)
(authors "whitequark <whitequark@whitequark.org>")
(maintainers "whitequark <whitequark@whitequark.org>")
(homepage "https://github.com/whitequark/ocaml-inotify")
(documentation "https://whitequark.github.io/ocaml-inotify")
(bug_reports "https://github.com/whitequark/ocaml-inotify/issues")
(source (github whitequark/ocaml-inotify))

(package
  (name inotify)
  (synopsis "Inotify bindings for OCaml")
  (description "Inotify bindings for OCaml")
  (depends
   base-unix
   base-bytes
   (fileutils (and :with-test (>= 0.4.4)))
   (ounit2 (and :with-test (>= 2.0)))
   (lwt :with-test)
   (ocaml (>= 4.03))
   (odoc :with-doc))
  (depopts
    lwt))
