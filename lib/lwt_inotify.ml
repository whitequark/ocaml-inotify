open Lwt

type t = {
  queue   : Inotify.event Queue.t;
  unix_fd : Unix.file_descr;
  lwt_fd  : Lwt_unix.file_descr;
}

let create () =
  try_lwt
    let unix_fd = Inotify.init () in
    return {
      queue   = Queue.create ();
      lwt_fd  = Lwt_unix.of_unix_file_descr unix_fd;
      unix_fd; }

let add_watch inotify path selector =
  try_lwt
    return (Inotify.add_watch inotify.unix_fd path selector)

let rm_watch inotify wd =
  try_lwt
    return (Inotify.rm_watch inotify.unix_fd wd)

let rec read inotify =
  try
    return (Queue.take inotify.queue)
  with Queue.Empty ->
    Lwt_unix.wait_read inotify.lwt_fd >>
    begin try_lwt
      let events = Inotify.read inotify.unix_fd in
      List.iter (fun event -> Queue.push event inotify.queue) events;
      return_unit
    end >>
    read inotify

let rec try_read inotify =
  try
    return (Some (Queue.take inotify.queue))
  with Queue.Empty ->
    if Lwt_unix.readable inotify.lwt_fd
    then read inotify >|= fun x -> Some x
    else return_none

let close inotify =
  Lwt_unix.close inotify.lwt_fd
