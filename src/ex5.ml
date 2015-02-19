let loadXMLDoc () =
  let xmlhttp = XmlHttpRequest.create () in
  let onreadystatechange () =
    match xmlhttp##readyState, xmlhttp##status with
    | XmlHttpRequest.DONE, 200 ->
      let xmlDoc = xmlhttp##responseXML in
      let buf = Buffer.create 16 in
      Buffer.add_string buf "<table border='1'><tr><th>Title</th><th>Artist</th></tr>";
      begin match Js.Opt.to_option xmlDoc with
        | None -> ()
        | Some xmlDoc ->
          let elts = xmlDoc##getElementsByTagName (Js.string "CD") in
          let f elt =
            let td cat =
              let cell =
                match Js.Opt.to_option (elt##getElementsByTagName (Js.string cat))##item (0) with
                | None -> "&nbsp;"
                | Some hd ->
                  begin match Js.Opt.to_option hd##firstChild with
                    | None -> "&nbsp;"
                    | Some hd ->
                      begin match Js.Opt.to_option hd##nodeValue with
                        | None -> "&nbsp;"
                        | Some hd -> Js.to_string hd
                      end
                  end
              in
              Buffer.add_string buf "<td>";
              Buffer.add_string buf cell;
              Buffer.add_string buf "</td>";
            in
            Buffer.add_string buf "<tr>";
            td "TITLE";
            td "ARTIST";
            Buffer.add_string buf "</tr>";
          in
          List.iter f (Dom.list_of_nodeList elts)
      end;
      Buffer.add_string buf "</table>";
      (Dom_html.getElementById "txtCDInfo")##innerHTML <- Js.string (Buffer.contents buf)
    | _ -> ()
  in
  xmlhttp##onreadystatechange <- Js.wrap_callback onreadystatechange;
  xmlhttp##_open (Js.string "GET", Js.string "cd_catalog.xml", Js._true);
  xmlhttp##send (Js.null)

let () = Js.Unsafe.global##loadXMLDoc <- Js.wrap_callback loadXMLDoc
