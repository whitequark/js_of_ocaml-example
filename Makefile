build:
	ocamlbuild -use-ocamlfind -plugin-tag 'package(js_of_ocaml.ocamlbuild)' \
						 src/example.js

clean:
	ocamlbuild -clean

.PHONY: build clean
