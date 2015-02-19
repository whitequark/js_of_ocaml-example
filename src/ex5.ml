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
          for i = 0 to elts##length - 1 do
            Buffer.add_string buf "<tr>";
            begin match Js.Opt.to_option (elts##item (i)) with
            | None -> ()
            | Some elt ->
              let td cat =
                Buffer.add_string buf "<td>";
                begin match Js.Opt.to_option (elt##getElementsByTagName (Js.string cat))##item (0) with
                  | None -> Buffer.add_string buf "&nbsp;"
                  | Some hd ->
                    begin match Js.Opt.to_option hd##firstChild with
                      | None -> Buffer.add_string buf "&nbsp;"
                      | Some hd ->
                        begin match Js.Opt.to_option hd##nodeValue with
                          | None -> Buffer.add_string buf "&nbsp;"
                          | Some hd -> Buffer.add_string buf (Js.to_string hd)
                        end
                    end
                end;
                Buffer.add_string buf "</td>";
              in
              td "TITLE";
              td "ARTIST";
            end;
            Buffer.add_string buf "</tr>";
          done;
      end;
      Buffer.add_string buf "</table>";
      (Dom_html.getElementById "txtCDInfo")##innerHTML <- Js.string (Buffer.contents buf)
    | _ -> ()
  in
  xmlhttp##onreadystatechange <- Js.wrap_callback onreadystatechange;
  xmlhttp##_open (Js.string "GET", Js.string "cd_catalog.xml", Js._true);
  xmlhttp##send (Js.null)

let () = Js.Unsafe.global##loadXMLDoc <- Js.wrap_callback loadXMLDoc
