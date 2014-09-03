BUILD=ocamlbuild -use-ocamlfind -plugin-tag 'package(js_of_ocaml.ocamlbuild)'
DEBUG=-tags 'pretty, noinline, debug'
OUT=src/example.js

build:
	${BUILD} \
	${DEBUG} \
 	${OUT}

dist: clean
	${BUILD} \
	-tags 'opt(3)' \
	${OUT}

sublime:
	eval `opam config env` && ${BUILD} ${DEBUG} ${OUT}

clean:
	ocamlbuild -clean

.PHONY: build dist sublime clean
