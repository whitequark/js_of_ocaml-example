let loadXMLDoc () =
  let xmlhttp = XmlHttpRequest.create () in
  let onreadystatechange () =
    match xmlhttp##readyState, xmlhttp##status with
    | XmlHttpRequest.DONE, 200 ->
      (Dom_html.getElementById "myDiv")##innerHTML <- xmlhttp##responseText
    | _ -> ()
  in
  xmlhttp##onreadystatechange <- Js.wrap_callback onreadystatechange;
  xmlhttp##_open (Js.string "GET", Js.string "ajax_info.txt", Js._true);
  xmlhttp##send (Js.null)

let () = Js.Unsafe.global##loadXMLDoc <- Js.wrap_callback loadXMLDoc
