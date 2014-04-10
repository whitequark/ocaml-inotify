open OUnit
open Lwt

let test_read tmpdir =
  Lwt_main.run (
    lwt inotify = Lwt_inotify.create () in
    lwt watch = Lwt_inotify.add_watch inotify tmpdir [Inotify.S_Create] in
    FileUtil.touch (Printf.sprintf "%s/test" tmpdir);
    lwt result = Lwt_inotify.read inotify in
    assert_equal (watch, [Inotify.Create], 0l, Some "test") result;
    return_unit)

let test_try_read tmpdir =
  Lwt_main.run (
    lwt inotify = Lwt_inotify.create () in
    lwt watch = Lwt_inotify.add_watch inotify tmpdir [Inotify.S_Create] in

    lwt result = Lwt_inotify.try_read inotify in
    OUnit.assert_equal None result;

    FileUtil.touch (Printf.sprintf "%s/test" tmpdir);
    lwt result = Lwt_inotify.read inotify in
    assert_equal (watch, [Inotify.Create], 0l, Some "test") result;

    lwt result = Lwt_inotify.try_read inotify in
    OUnit.assert_equal None result;

    return_unit)

let test_error tmpdir =
  Lwt_main.run (
    lwt inotify = Lwt_inotify.create () in
    catch (fun () -> ignore (Lwt_inotify.add_watch inotify tmpdir []);
                     assert_failure "must raise")
          (fun ex -> assert_equal (Unix.Unix_error (Unix.EINVAL, "inotify_add_watch", "")) ex;
                     return_unit))

let tests = "Test Lwt_inotify" >::: [
    "Test read"           >:: bracket Helper.setup test_read Helper.teardown;
    "Test try_read"       >:: bracket Helper.setup test_try_read Helper.teardown;
    "Test error handling" >:: bracket Helper.setup test_try_read Helper.teardown;
  ]

let _ =
  run_test_tt_main tests
