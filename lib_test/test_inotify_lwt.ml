open OUnit
open Lwt

let test_inotify_lwt tmpdir =
  Lwt_main.run (
    let inotify = Lwt_inotify.create () in
    let watch = Lwt_inotify.add_watch inotify tmpdir [Inotify.S_Create] in
    FileUtil.touch (Printf.sprintf "%s/test" tmpdir);
    Lwt_inotify.read inotify >>= fun result ->
    assert_equal (watch, [Inotify.Create], 0l, Some "test") result;
    return_unit)

let tests = "Test ocaml-inotify lwt" >::: [
    "Test inotify-lwt" >:: bracket Helper.setup test_inotify_lwt Helper.teardown;
  ]

let _ =
  run_test_tt_main tests
