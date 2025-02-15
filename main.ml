open! Core
open! Bonsai_web
open Bonsai.Let_syntax
module Form = Bonsai_web_ui_form

module Style = [%css stylesheet {|
  body {
    padding: 0;
    margin: 0;
  }
|}]

let host_and_port = Value.return "http://localhost:7860"

let blurry_transparent_background =
  View.Theme.override_constants_for_computation ~f:(fun constants ->
    let make_transparent pct c =
      `Name
        (sprintf
           "color-mix(in oklab, transparent %d%%, %s)"
           pct
           (Css_gen.Color.to_string_css c))
    in
    { constants with
      primary =
        { constants.primary with
          background = make_transparent 20 constants.primary.background
        }
    ; extreme =
        { constants.primary with
          background = make_transparent 50 constants.extreme.background
        }
    })
;;

let component =
  let%sub { form; form_view } =
    blurry_transparent_background (Parameters.component ~host_and_port)
  in
  let%sub { queue_request; view = gallery } =
    Gallery.component ~host_and_port ~set_params:(form >>| Form.set)
  in
  let%sub submit_effect =
    let%sub form = Bonsai.yoink form in
    let%arr form = form
    and queue_request = queue_request in
    Some
      (match%bind.Effect form with
       | Inactive -> Effect.Ignore
       | Active form ->
         (match Form.value form with
          | Error e -> Effect.print_s [%sexp (e : Error.t)]
          | Ok query -> queue_request query))
  in
  let%arr form_view = form_view
  and submit_effect = submit_effect
  and gallery = gallery in
  let on_submit = Option.value submit_effect ~default:Effect.Ignore in
  Vdom.Node.div [ form_view ~on_submit; gallery ]
;;

let () =
  Bonsai_web.Start.start
    (View.Theme.set_for_app
       (Value.return (Kado.theme ~style:Dark ~version:Bleeding ()))
       component)
;;
