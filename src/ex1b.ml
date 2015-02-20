let onload _ =
  let doc = Dom_html.document in
  let div = Dom_html.createDiv doc in
  let h2 = Dom_html.createH2 doc in
  let button = Dom_html.createButton ~_type:(Js.string "button") doc in
  h2##textContent <- Js.some (Js.string "Let AJAX change this text");
  button##textContent <- Js.some (Js.string "Change Content");
  let _ =
    let state = ref false in
    Lwt_js_events.clicks button
      (fun _ev _ ->
         state := not !state;
         if !state then
           Lwt.bind (XmlHttpRequest.get "ajax_info.txt")
             (fun {XmlHttpRequest.content; _} -> div##innerHTML <- Js.string content; Lwt.return ())
         else begin
           div##innerHTML <- Js.string "";
           Dom.appendChild div h2;
           Lwt.return()
         end)
  in
  Dom.appendChild div h2;
  Dom.appendChild doc##body div;
  Dom.appendChild doc##body button;
  Js._false

let () =
  Dom_html.window##onload <- Dom_html.handler onload
