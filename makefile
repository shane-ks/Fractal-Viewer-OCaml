all: complexNum graph mandelbrot

complexNum: complexNum.ml
	ocamlbuild -r -use-ocamlfind complexNum.byte

graph: graph.ml
	ocamlbuild -pkg graphics -pkg unix -r -use-ocamlfind graph.byte

mandelbrot: mandelbrot.ml
	ocamlbuild -r -use-ocamlfind mandelbrot.byte

config: config.ml
	ocamlbuild -r -use-ocamlfind config.byte

clean:
	rm -rf _build *.byte