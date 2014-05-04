open Lwt

type t = {
  queue   : Inotify.event Queue.t;
  unix_fd : Unix.file_descr;
  lwt_fd  : Lwt_unix.file_descr;
}

let create () =
  catch (fun _ ->
    let unix_fd = Inotify.create () in
    return {
      queue   = Queue.create ();
      lwt_fd  = Lwt_unix.of_unix_file_descr unix_fd;
      unix_fd; }) fail

let add_watch inotify path selector =
  catch (fun _ ->
    return (Inotify.add_watch inotify.unix_fd path selector)) fail

let rm_watch inotify wd =
  catch (fun _ ->
    return (Inotify.rm_watch inotify.unix_fd wd)) fail

let rec read inotify =
  try
    return (Queue.take inotify.queue)
  with Queue.Empty ->
    Lwt_unix.wait_read inotify.lwt_fd >>= fun () ->
    catch (fun _ ->
      let events = Inotify.read inotify.unix_fd in
      List.iter (fun event -> Queue.push event inotify.queue) events;
      return_unit) fail >>= fun () ->
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
