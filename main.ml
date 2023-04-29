(*
                    CS51 Final Project
                      Shane Kissinger
 *)

(* Description: This file starts the application and controls the GUI.*)

open Config ;; 
module G = Graphics ;;
open Graph ;; 

let main_loop () = 
  (* initialize window *)
  G.open_graph ""; 
  G.resize_window Config.width Config.height;
  G.set_window_title "Fractal Viewer";
  G.auto_synchronize false;
  Controller.loading (); 

  (* initialize parameters *)
  let x_min = ref Config.xmin in
  let x_max = ref Config.xmax in
  let y_min = ref Config.ymin in
  let y_max = ref Config.ymax in
  let max_iteration = ref max_step in 
  let current_image = 
    Array.make Config.height (Array.make Config.width 0) in 

  while true do 
  (* view fractal *)
  depict_fractal Config.width 
                 Config.height 
                 !x_min 
                 !x_max 
                 !y_min
                 !y_max
                 Config.color
                 !max_iteration 
                 current_image;
  (* view fractal *)
  G.draw_image (G.make_image current_image) 0 0 ; 
  G.synchronize (); 
  (* user selecting area to zoom into *)
  let pixel_selection = Controller.view current_image in 
  let xpixel_start, ypixel_start = pixel_selection.(0) in 
  let xpixel_end, ypixel_end = pixel_selection.(2) in 
  let new_xmin, new_ymin = 
    Controller.pixel_to_coord xpixel_start 
                              ypixel_start 
                              !x_min 
                              !x_max 
                              !y_min 
                              !y_max in 
  let new_xmax, new_ymax = 
    Controller.pixel_to_coord xpixel_end 
                              ypixel_end 
                              !x_min 
                              !x_max 
                              !y_min 
                              !y_max in 
  x_min := new_xmin; 
  x_max := new_xmax; 
  y_min := new_ymin; 
  y_max := new_ymax; 
  max_iteration := int_of_float (1.5 *. float !max_iteration);
  done;;


let () = 
  main_loop ();; 
