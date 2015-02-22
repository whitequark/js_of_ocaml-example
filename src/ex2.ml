let loadXMLDoc () =
  let xmlhttp = XmlHttpRequest.create () in
  let onreadystatechange () =
    match xmlhttp##readyState, xmlhttp##status with
    | XmlHttpRequest.DONE, 200 ->
      let xmlDoc = xmlhttp##responseXML in
      let buf = Buffer.create 16 in
      let iter f x = Js.Opt.iter x f in
      iter
        (fun xmlDoc ->
           let elts = xmlDoc##getElementsByTagName (Js.string "ARTIST") in
           for i = 0 to elts##length - 1 do
             iter
               (fun elt ->
                  iter
                    (fun elt ->
                       iter
                         (fun elt ->
                            Buffer.add_string buf (Js.to_string elt);
                            Buffer.add_string buf "<br>")
                         elt##nodeValue)
                    elt##firstChild)
               (elts##item (i))
           done)
        xmlDoc;
      (Dom_html.getElementById "myDiv")##innerHTML <- Js.string (Buffer.contents buf)
    | _ -> ()
  in
  xmlhttp##onreadystatechange <- Js.wrap_callback onreadystatechange;
  xmlhttp##_open (Js.string "GET", Js.string "cd_catalog.xml", Js._true);
  xmlhttp##send (Js.null)

let () = Js.Unsafe.global##loadXMLDoc <- Js.wrap_callback loadXMLDoc
