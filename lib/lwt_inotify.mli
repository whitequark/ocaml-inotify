(** An [Lwt] wrapper for {!Inotify} module.

    Note, whenever it is possible we provide two version of an
    operation:
    - [f'] - a pure non-blocking operation;
    - [f] - the same operation lifted into the Lwt monad.
*)

(** Type of inotify descriptors. *)
type t

(** [create ()] returns a new inotify descriptor. *)
val create    : unit -> t Lwt.t
val create'   : unit -> t
(** @since 2.5 *)

(** [add_watch desc path events] sets up [desc] to watch for [events] occuring
    to [path], and returns a watch descriptor. *)
val add_watch  : t -> string -> Inotify.selector list -> Inotify.watch Lwt.t
val add_watch' : t -> string -> Inotify.selector list -> Inotify.watch
(** @since 2.5 *)


(** [rm_watch desc watch] stops [desc] from watching [watch]. *)
val rm_watch  : t -> Inotify.watch -> unit Lwt.t
val rm_watch' : t -> Inotify.watch -> unit
(** @since 2.5 *)

(** [read desc] waits for an event to occur at [desc]. *)
val read      : t -> Inotify.event Lwt.t

(** [try_read desc] returns [Some event] if [desc] has queued events,
    or [None] otherwise. *)
val try_read  : t -> Inotify.event option Lwt.t

(** [close desc] frees [desc]. *)
val close     : t -> unit Lwt.t
