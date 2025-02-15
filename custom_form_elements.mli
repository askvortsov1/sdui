open! Core
open! Bonsai_web
module Form = Bonsai_web_ui_form

val textarea
  :  ?validate:(string -> string)
  -> ?attrs:Vdom.Attr.t list
  -> ?label:string
  -> unit
  -> (string Form.t * Vdom.Node.t) Computation.t

val int_form
  :  ?input_attrs:Vdom.Attr.t list
  -> ?container_attrs:Vdom.Attr.t list
  -> title:string
  -> default:Int63.t
  -> step:int
  -> length:Css_gen.Length.t
  -> min:Int63.t
  -> max:Int63.t
  -> validate_or_correct:(string -> (Int63.t, Int63.t) Result.t)
  -> unit
  -> (Int63.t Form.t * Vdom.Node.t) Computation.t

val bool_form
  :  ?input_attrs:Vdom.Attr.t list
  -> ?container_attrs:Vdom.Attr.t list
  -> title:string
  -> default:bool
  -> unit
  -> (bool Form.t * Vdom.Node.t) Computation.t

module Label_modifications : sig
  val muted_label : Vdom.Attr.t

  module Variables : sig
    val set_all : border:string -> fg:string -> Vdom.Attr.t
  end
end
