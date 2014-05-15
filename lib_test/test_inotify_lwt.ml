open OUnit2
open Lwt

let test_read ctxt =
  let tmpdir = bracket_tmpdir ctxt in
  Lwt_main.run (
    Lwt_inotify.create () >>= fun inotify ->
    Lwt_inotify.add_watch inotify tmpdir [Inotify.S_Create] >>= fun watch ->
    FileUtil.touch (Printf.sprintf "%s/test" tmpdir);
    Lwt_inotify.read inotify >>= fun result ->
    assert_equal (watch, [Inotify.Create], 0l, Some "test") result;
    return_unit)

let test_try_read ctxt =
  let tmpdir = bracket_tmpdir ctxt in
  Lwt_main.run (
    Lwt_inotify.create () >>= fun inotify ->
    Lwt_inotify.add_watch inotify tmpdir [Inotify.S_Create] >>= fun watch ->

    Lwt_inotify.try_read inotify >>= fun result ->
    OUnit.assert_equal None result;

    FileUtil.touch (Printf.sprintf "%s/test" tmpdir);
    Lwt_inotify.read inotify >>= fun result ->
    assert_equal (watch, [Inotify.Create], 0l, Some "test") result;

    Lwt_inotify.try_read inotify >>= fun result ->
    OUnit.assert_equal None result;

    return_unit)

let test_error ctxt =
  let tmpdir = bracket_tmpdir ctxt in
  Lwt_main.run (
    Lwt_inotify.create () >>= fun inotify ->
    let tmpfile = Printf.sprintf "%s/nonexistent" tmpdir in
    catch (fun () -> ignore_result (Lwt_inotify.add_watch inotify tmpfile [Inotify.S_Modify]);
                     assert_failure "must raise")
          (fun ex -> assert_equal (Unix.Unix_error (Unix.ENOENT, "inotify_add_watch", tmpfile)) ex;
                     return_unit))

let suite = "Test Lwt_inotify" >::: [
    "Test read"           >:: test_read;
    "Test try_read"       >:: test_try_read;
    "Test error handling" >:: test_error;
  ]

let _ =
  run_test_tt_main suite
