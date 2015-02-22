build:
	ocamlbuild -use-ocamlfind -plugin-tag 'package(js_of_ocaml.ocamlbuild)' \
						 src/example.js
	ocamlbuild -use-ocamlfind -plugin-tag 'package(js_of_ocaml.ocamlbuild)' \
						 src/ex1.js
	ocamlbuild -use-ocamlfind -plugin-tag 'package(js_of_ocaml.ocamlbuild)' \
						 src/ex1b.js
	ocamlbuild -use-ocamlfind -plugin-tag 'package(js_of_ocaml.ocamlbuild)' \
						 src/ex2.js
	ocamlbuild -use-ocamlfind -plugin-tag 'package(js_of_ocaml.ocamlbuild)' \
						 src/ex5.js
	ocamlbuild -use-ocamlfind -plugin-tag 'package(js_of_ocaml.ocamlbuild)' \
						 src/jsonExample.js

clean:
	ocamlbuild -clean

.PHONY: build clean
