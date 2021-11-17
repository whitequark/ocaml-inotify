(lang dune 2.9)
(generate_opam_files true)

(name inotify)
(license LGPL-2.1)
(authors "whitequark <whitequark@whitequark.org>")
(maintainers "whitequark <whitequark@whitequark.org>")
(homepage "https://github.com/whitequark/ocaml-inotify")
(documentation "http://whitequark.github.io/ocaml-inotify")
(bug_reports "https://github.com/whitequark/ocaml-inotify/issues")
(source (github maiste/ocaml-inotify))

(package
  (name inotify)
  (synopsis "Inotify bindings for OCaml")
  (description "Inotify bindings for OCaml")
  (depends
   base-unix
   base-bytes
   (fileutils (and :with-test (>= 0.4.4)))
   (ounit2 (and :with-test (>= 2.0)))
   (odoc :with-doc))
  (depopts
    lwt))
