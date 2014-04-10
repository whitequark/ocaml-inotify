(** An [Lwt] wrapper for [Inotify] module. *)

(** Type of inotify descriptors. *)
type t

(** [create ()] returns a new inotify descriptor. *)
val create    : unit -> t Lwt.t

(** [add_watch id path events] sets up [id] to watch for [events] occuring
    to [path], and returns a watch descriptor. *)
val add_watch : t -> string -> Inotify.select_event list -> Inotify.wd Lwt.t

(** [rm_watch id wd] stops [id] from watching [wd]. *)
val rm_watch  : t -> Inotify.wd -> unit Lwt.t

(** [read id] waits for an event to occur at [id]. *)
val read      : t -> Inotify.event Lwt.t

(** [try_read id] returns [Some event] if [id] has one queued, or [None]. *)
val try_read  : t -> Inotify.event option Lwt.t

(** [close id] frees [id]. *)
val close     : t -> unit Lwt.t
