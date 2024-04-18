open OUnit2

let test_read ctxt =
  let tmpdir = bracket_tmpdir ctxt in
  Eio_main.run @@ fun _env ->
    let inotify = Eio_inotify.create () in
    let watch = Eio_inotify.add_watch inotify tmpdir [Inotify.S_Create] in
    FileUtil.touch (Printf.sprintf "%s/test" tmpdir);
    let result = Eio_inotify.read inotify in
    assert_equal (watch, [Inotify.Create], 0l, Some "test") result

let test_try_read ctxt =
  let tmpdir = bracket_tmpdir ctxt in
  Eio_main.run @@ fun _env ->
    let inotify = Eio_inotify.create () in
    let watch = Eio_inotify.add_watch inotify tmpdir [Inotify.S_Create] in

    let result = Eio_inotify.try_read inotify in
    OUnit.assert_equal None result;

    FileUtil.touch (Printf.sprintf "%s/test" tmpdir);
    let result = Eio_inotify.try_read inotify in
    assert_equal (Some (watch, [Inotify.Create], 0l, Some "test")) result;

    let result = Eio_inotify.try_read inotify in
    OUnit.assert_equal None result

let test_error ctxt =
  let tmpdir = bracket_tmpdir ctxt in
  Eio_main.run @@ fun _env ->
    let inotify = Eio_inotify.create () in
    let tmpfile = Printf.sprintf "%s/nonexistent" tmpdir in
    try
      let _watch = Eio_inotify.add_watch inotify tmpfile [Inotify.S_Modify] in
      assert_failure "must raise"
    with
      | ex -> assert_equal (Unix.Unix_error (Unix.ENOENT, "inotify_add_watch", tmpfile)) ex

let suite = "Test Eio_inotify" >::: [
    "Test read"           >:: test_read;
    "Test try_read"       >:: test_try_read;
    "Test error handling" >:: test_error;
  ]

let _ =
  run_test_tt_main suite
