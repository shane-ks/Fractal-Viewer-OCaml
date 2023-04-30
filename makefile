all: complexNum graph mandelbrot config main controller

complexNum: complexNum.ml
	ocamlbuild -r -use-ocamlfind complexNum.byte

graph: graph.ml
	ocamlbuild -pkg graphics -r -use-ocamlfind graph.byte

mandelbrot: mandelbrot.ml
	ocamlbuild -r -use-ocamlfind mandelbrot.byte

config: config.ml
	ocamlbuild -r -use-ocamlfind config.byte

main: main.ml
	ocamlbuild -pkg graphics -r -use-ocamlfind main.byte

controller: controller.ml
	ocamlbuild -pkg graphics -r -use-ocamlfind controller.byte

clean:
	rm -rf _build *.byte