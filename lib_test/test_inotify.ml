open OUnit

(* Test that basic events work *)
let test_s_create tmpdir =
  let inotify = Inotify.init () in
  Unix.set_nonblock inotify;

  let watch = Inotify.add_watch inotify tmpdir [Inotify.S_Create] in
  FileUtil.touch (Printf.sprintf "%s/test" tmpdir);
  assert_equal [watch, [Inotify.Create], 0l, Some "test"] (Inotify.read inotify)

(* Test that cookie works *)
let test_s_move tmpdir =
  let inotify = Inotify.init () in
  Unix.set_nonblock inotify;

  let watch = Inotify.add_watch inotify tmpdir [Inotify.S_Move] in
  FileUtil.touch (Printf.sprintf "%s/foo" tmpdir);
  FileUtil.mv (Printf.sprintf "%s/foo" tmpdir) (Printf.sprintf "%s/bar" tmpdir);
  match Inotify.read inotify with
  | [from_watch, [Inotify.Moved_from], from_cookie,  Some "foo";
     to_watch,   [Inotify.Moved_to],   to_cookie,    Some "bar"]
     when watch = from_watch && watch = to_watch && from_cookie = to_cookie ->
    ()
  | _ -> assert_failure "move"

let tests = "Test Inotify" >::: [
    "Test S_Create watch" >:: bracket Helper.setup test_s_create Helper.teardown;
    "Test S_Move watch"   >:: bracket Helper.setup test_s_move Helper.teardown
  ]

let _ =
  run_test_tt_main tests
