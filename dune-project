(lang dune 3.9)
(generate_opam_files true)
(version 2.6)

(name inotify)
(license "LGPL-2.1-only WITH OCaml-LGPL-linking-exception")
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

(package
  (name inotify-eio)
  (synopsis "Inotify backend for eio")
  (description "Inotify backend for eio")
  (depends
   base-unix
   base-bytes
   (inotify (= :version))
   (fileutils (and :with-test (>= 0.4.4)))
   (ounit2 (and :with-test (>= 2.0)))
   (ocaml (>= 5.0))
   (odoc :with-doc)
   eio
   (eio_main :with-test)
   (iomux (>= 0.3))))
