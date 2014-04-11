open OUnit2
open Lwt

let scheduler_mutex = OUnitShared.Mutex.create OUnitShared.ScopeProcess

let (>::) name f =
  name >:: (fun ctxt ->
              OUnitShared.Mutex.with_lock ctxt.OUnitTest.shared scheduler_mutex
                (fun () -> f ctxt))

let test_read ctxt =
  let tmpdir = bracket_tmpdir ctxt in
  Lwt_main.run (
    lwt inotify = Lwt_inotify.create () in
    lwt watch = Lwt_inotify.add_watch inotify tmpdir [Inotify.S_Create] in
    FileUtil.touch (Printf.sprintf "%s/test" tmpdir);
    lwt result = Lwt_inotify.read inotify in
    assert_equal (watch, [Inotify.Create], 0l, Some "test") result;
    return_unit)

let test_try_read ctxt =
  let tmpdir = bracket_tmpdir ctxt in
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

let test_error ctxt =
  let tmpdir = bracket_tmpdir ctxt in
  Lwt_main.run (
    lwt inotify = Lwt_inotify.create () in
    catch (fun () -> ignore_result (Lwt_inotify.add_watch inotify tmpdir []);
                     assert_failure "must raise")
          (fun ex -> assert_equal (Unix.Unix_error (Unix.EINVAL, "inotify_add_watch", tmpdir)) ex;
                     return_unit))

let suite = "Test Lwt_inotify" >::: [
    "Test read"           >:: test_read;
    "Test try_read"       >:: test_try_read;
    "Test error handling" >:: test_error;
  ]

let _ =
  run_test_tt_main suite
