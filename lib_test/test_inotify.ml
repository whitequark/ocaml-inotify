open OUnit2

(* Test that basic events work *)
let test_s_create ctxt =
  let tmpdir = bracket_tmpdir ctxt in
  let inotify = Inotify.create () in
  Unix.set_nonblock inotify;

  let watch = Inotify.add_watch inotify tmpdir [Inotify.S_Create] in
  FileUtil.touch (Printf.sprintf "%s/test" tmpdir);
  assert_equal [watch, [Inotify.Create], 0l, Some "test"] (Inotify.read inotify)

(* See https://github.com/whitequark/ocaml-inotify/issues/8 *)
let test_s_create_blocking ctxt =
  let tmpdir = bracket_tmpdir ctxt in
  let inotify = Inotify.create () in

  let watch = Inotify.add_watch inotify tmpdir [Inotify.S_Create] in
  () |> Thread.create (fun () ->
    Unix.sleep 1;
    FileUtil.touch (Printf.sprintf "%s/test" tmpdir)) |> ignore;
  assert_equal [watch, [Inotify.Create], 0l, Some "test"] (Inotify.read inotify)

(* Test that cookie works *)
let test_s_move ctxt =
  let tmpdir = bracket_tmpdir ctxt in
  let inotify = Inotify.create () in
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

(* Test that error handling works *)
let test_error ctxt =
  let tmpdir = bracket_tmpdir ctxt in
  let inotify = Inotify.create () in
  let tmpfile = Printf.sprintf "%s/nonexistent" tmpdir in
  assert_raises (Unix.Unix_error (Unix.ENOENT, "inotify_add_watch", tmpfile))
                (fun () -> Inotify.add_watch inotify tmpfile [Inotify.S_Modify])

(* Test that nonblocking polling works *)
let test_nonblock ctxt =
  let tmpdir = bracket_tmpdir ctxt in
  let inotify = Inotify.create () in
  Unix.set_nonblock inotify;

  let _ = Inotify.add_watch inotify tmpdir [Inotify.S_Create] in
  assert_raises (Unix.Unix_error (Unix.EAGAIN, "read", ""))
                (fun () -> Inotify.read inotify)

let suite = "Test Inotify" >::: [
    "Test S_Create watch"   >:: test_s_create;
    "Test blocking watch"   >:: test_s_create_blocking;
    "Test S_Move watch"     >:: test_s_move;
    "Test error handling"   >:: test_error;
    "Test nonblocking mode" >:: test_nonblock;
  ]

let _ =
  run_test_tt_main suite
