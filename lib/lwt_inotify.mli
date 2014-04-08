(** An [Lwt] wrapper for [Inotify] module. *)

(** Type of inotify descriptors. *)
type t

(** [create ()] returns a new inotify descriptor. *)
val create    : unit -> t

(** [add_watch id path events] sets up [id] to watch for [events] occuring
    to [path], and returns a watch descriptor. *)
val add_watch : t -> string -> Inotify.select_event list -> Inotify.wd

(** [rm_watch id wd] stops [id] from watching [wd]. *)
val rm_watch  : t -> Inotify.wd -> unit

(** [read id] waits for an event to occur at [id]. *)
val read      : t -> Inotify.event Lwt.t

(** [close id] frees [id]. *)
val close     : t -> unit Lwt.t
