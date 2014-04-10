open OUnit
open Lwt

let test_read tmpdir =
  Lwt_main.run (
    let inotify = Lwt_inotify.create () in
    let watch = Lwt_inotify.add_watch inotify tmpdir [Inotify.S_Create] in
    FileUtil.touch (Printf.sprintf "%s/test" tmpdir);
    Lwt_inotify.read inotify >>= fun result ->
    assert_equal (watch, [Inotify.Create], 0l, Some "test") result;
    return_unit)

let test_try_read tmpdir =
  Lwt_main.run (
    let inotify = Lwt_inotify.create () in
    let watch = Lwt_inotify.add_watch inotify tmpdir [Inotify.S_Create] in

    Lwt_inotify.try_read inotify >>= fun result ->
    OUnit.assert_equal None result;

    FileUtil.touch (Printf.sprintf "%s/test" tmpdir);
    Lwt_inotify.read inotify >>= fun result ->
    assert_equal (watch, [Inotify.Create], 0l, Some "test") result;

    Lwt_inotify.try_read inotify >>= fun result ->
    OUnit.assert_equal None result;

    return_unit)

let tests = "Test Lwt_inotify" >::: [
    "Test read"     >:: bracket Helper.setup test_read Helper.teardown;
    "Test try_read" >:: bracket Helper.setup test_try_read Helper.teardown;
  ]

let _ =
  run_test_tt_main tests
