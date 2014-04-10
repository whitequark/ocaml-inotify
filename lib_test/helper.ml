let () =
  Random.self_init ()

let setup () =
  let tmpdir = Printf.sprintf "%s/ocaml-inotify-%d"
                              Filename.temp_dir_name
                              (Random.int 100000) in
  Unix.mkdir tmpdir 0o755;
  tmpdir

let teardown tmpdir =
  FileUtil.rm ~recurse:true [tmpdir]
