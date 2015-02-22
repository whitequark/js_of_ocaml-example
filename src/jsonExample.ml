class type page_status =
  object
    method enabled: bool Js.t Js.readonly_prop
    method explanation: string Js.readonly_prop
  end

class type global_features =
  object
    method main_page_: string Js.readonly_prop
    method pages: < .. > Js.t Js.readonly_prop
  end

type 'a response =
  | OK of 'a Js.t
  | KO of string

let get_response x =
  let x = Json.unsafe_input (Js.string x) in
  let resp = (Js.Unsafe.coerce x)##_OK in
  if Js.Optdef.test resp then OK resp
  else KO (Js.Unsafe.coerce x)##_KO

let onload _ =
  let doc = Dom_html.document in
  let div = Dom_html.createDiv doc in
  let global_pages =
    [ "page1";
      "page2";
      "page3";
      "page4";
    ]
  in
  let _ =
    let form_arg = `Fields (ref ["data", `String (Json.output (jsnew Js.array_empty ()))]) in
    Lwt.bind
      (XmlHttpRequest.perform_raw_url
         ~content_type:"application/json; charset=UTF-8"
         ~headers:["Accept", "application/json, text/javascript, */*; q=0.01";
                   "X-Requested-With", "XMLHttpRequest"]
         ~form_arg
         "global_features")
      (fun {XmlHttpRequest.content; _} ->
         let buf = Buffer.create 64 in
         Buffer.add_string buf (Printf.sprintf "<b>JSON response:</b>%s<br>" content);
         begin match get_response content with
         | OK (gf:global_features Js.t) ->
           Buffer.add_string buf (Printf.sprintf "Main page: %s<br>" gf##main_page_);
           Buffer.add_string buf "<table border=1>";
           Buffer.add_string buf "<tr><th>Internal name</th><th>Enabled</th><th>Explanation</th></tr>";
           let f internal_name =
             Buffer.add_string buf "<tr>";
             Buffer.add_string buf (Printf.sprintf "<td>%s</td>" internal_name);
             begin match Js.Optdef.to_option (Js.Unsafe.get (gf##pages) (Js.string internal_name)) with
               | None -> Buffer.add_string buf (Printf.sprintf "<td>N/A</td><td>N/A</td>")
               | Some (status:page_status Js.t) ->
                 Buffer.add_string buf (Printf.sprintf "<td>%b</td><td>%s</td>" (Js.to_bool status##enabled) status##explanation)
             end;
             Buffer.add_string buf "</tr>";
           in
           List.iter f global_pages;
           Buffer.add_string buf "</table>"
         | KO msg ->
           Buffer.add_string buf msg;
           Buffer.add_string buf "<br>";
         end;
         div##innerHTML <- Js.string (Buffer.contents buf);
         Lwt.return ())
  in
  Dom.appendChild doc##body div;
  Js._false

let () =
  Dom_html.window##onload <- Dom_html.handler onload
