(*
                    CS51 Final Project
                      Shane Kissinger
 *)

(* Description: This file runs the program and handles user interaction. *)

(*
Step 1: Simplify and organize code while keeping same functionality
Step 2: Try to make more efficient
Step 3: Add functional / recursive elements.
Step 4: Add classes.    
*)
open ComplexNum ;; 
module G = Graphics ;;
open Config ;; 
open Graph ;; 
open Mandelbrot ;;



let main_loop () = 
  G.open_graph ""; 
  G.resize_window Config.width Config.height;
  G.set_window_title "Fractal Viewer";
  G.auto_synchronize false;

  (* initialize parameters *)
  let x_min = ref Config.xmin in
  let x_max = ref Config.xmax in
  let y_min = ref Config.ymin in
  let y_max = ref Config.ymax in
  let max_iteration = ref Config.max_step in 
  let quit_loop = ref false in 

  while not !quit_loop do 
    G.clear_graph (); 
    Graph.depict_fractal width
                         height
                         !x_min
                         !x_max 
                         !y_min 
                         !y_max
                         color
                         !max_iteration;
    (* G.draw_image (Graph.depict_fractal width
                         height
                         !x_min
                         !x_max 
                         !y_min 
                         !y_max
                         color
                         !max_iteration) 0 0 ; *)
    G.synchronize (); 
    Controller.ui_loop x_min 
                       x_max 
                       y_min 
                       y_max
                       max_iteration
                       quit_loop; 
  done ;; 
  
let () = 
  main_loop ();; 