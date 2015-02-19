let () =
  let doc = Dom_html.document in
  let div = Dom_html.createDiv doc in
  let h2 = Dom_html.createH2 doc in
  let button = Dom_html.createButton ~_type:(Js.string "button") doc in
  h2##textContent <- Js.some (Js.string "Let AJAX change this text");
  div##id <- Js.string "myDiv";
  button##textContent <- Js.some (Js.string "Change Content");
  let _ =
    Lwt.bind (Lwt_js_events.make_event Dom_html.Event.click button)
      (fun _ -> Lwt.bind (XmlHttpRequest.get "ajax_info.txt")
          (fun {XmlHttpRequest.content; _} -> div##innerHTML <- Js.string content; Lwt.return ()))
  in
  ignore (div##appendChild ((h2 :> Dom.node Js.t)));
  ignore (doc##body##appendChild ((div :> Dom.node Js.t)));
  ignore (doc##body##appendChild ((button :> Dom.node Js.t)));
  ()
