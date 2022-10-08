type t = {
  queue   : Inotify.event Queue.t;
  unix_fd : Unix.file_descr;
}

let create () =
  try
    let unix_fd = Inotify.create () in
    {
      queue   = Queue.create ();
      unix_fd; }
  with exn ->
    raise exn

let add_watch inotify path selector =
  Inotify.add_watch inotify.unix_fd path selector

let rm_watch inotify wd =
  Inotify.rm_watch inotify.unix_fd wd

let rec read inotify =
  try
    Queue.take inotify.queue
  with Queue.Empty ->
    Eio_unix.await_readable inotify.unix_fd;
    let events = Inotify.read inotify.unix_fd in
    List.iter (fun event -> Queue.push event inotify.queue) events;
    read inotify

let with_timeout d = Eio.Fiber.first (fun () -> Eio_unix.sleep d; Error `Timeout)

let rec try_read inotify =
  try
    Some (Queue.take inotify.queue)
  with Queue.Empty ->
    (* Not quite the same... we block *)
    match with_timeout 0.2 (fun () -> Ok (Eio_unix.await_readable inotify.unix_fd)) with
    | Ok () -> Some (read inotify)
    | _ -> None

let close inotify =
  Unix.close inotify.unix_fd
