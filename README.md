OCaml Inotify bindings [![build](https://github.com/whitequark/ocaml-inotify/actions/workflows/main.yml/badge.svg)](https://github.com/whitequark/ocaml-inotify/actions/workflows/main.yml)
======================

This package contains bindings for Linux's filesystem monitoring
interface, [inotify][man].

  [man]: http://man7.org/linux/man-pages/man7/inotify.7.html

Installation
------------

The bindings are available via [OPAM](https://opam.ocaml.org):

    $ opam install inotify

Alternatively, you can do it manually:

    # If you want to use lwt_inotify
    $ opam install lwt
    # If you want to use eio_inotify
    $ opam install eio
    $ opam install .

Usage
-----

Unix-style interface (findlib package `inotify`):

``` ocaml
let inotify = Inotify.create () in
let watch   = Inotify.add_watch inotify "dir" [Inotify.S_Create] in
print_endline (Inotify.string_of_event (List.hd (Inotify.read inotify)))
(* watch=1 cookie=0 events=CREATE "file" *)
```

Lwt-style interface (findlib package `inotify.lwt`):

``` ocaml
Lwt_main.run (
  let%lwt inotify = Lwt_inotify.create () in
  let%lwt watch   = Lwt_inotify.add_watch inotify "dir" [Inotify.S_Create] in
  let%lwt event   = Lwt_inotify.read inotify in
  Lwt_io.printl (Inotify.string_of_event event))
  (* watch=1 cookie=0 events=CREATE "file" *)
```

Eio-style interface (findlib package `inotify-eio`):

``` ocaml
Eio_main.run @@ fun _env ->
  let inotify = Eio_inotify.create () in
  let _watch   = Eio_inotify.add_watch inotify "dir" [Inotify.S_Create] in
  let event   = Eio_inotify.read inotify in
  print_endline (Inotify.string_of_event event)
  (* watch=1 cookie=0 events=CREATE "file" *)
```

Note that Lwt-style & Eio-style interfaces returns events one-by-one, but the Unix-style one returns
them in small batches.

Documentation
-------------

The API documentation is available at [GitHub pages](http://whitequark.github.io/ocaml-inotify/).

License
-------

[LGPL 2.1 with linking exception](LICENSE.txt)
