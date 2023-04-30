(*
                    CS51 Final Project
                      Shane Kissinger
 *)

(* Description: This file starts the application and controls the GUI.*)


module G = Graphics ;;
open Graphics ;; 
open Graph ;; 
exception Program_quit ;; 

let loading () = 
  begin
    G.set_color G.white;
    G.fill_rect 0 0 70 20; 
    G.moveto 5 5 ; 
    G.set_color G.blue;
    G.set_text_size 75;
    G.draw_string "Loading...";
    G.synchronize ()
  end ;; 

let main_loop () = 
  (* let clicked = ref false in  *)
  (* let active = ref true in *)
  let x_min = ref Config.xmin in
  let x_max = ref Config.xmax in
  let y_min = ref Config.ymin in
  let y_max = ref Config.ymax in

  (* let x_start_box = ref 0 in 
  let y_start_box = ref 0 in 
  let x_end_box = ref 0 in 
  let y_end_box = ref 0 in  *)
  
  let max_iteration = ref Config.max_step in 
  let current_image = 
    ref (Array.make Config.height (Array.make Config.width 0)) in 

  (* let coord_to_pixel (x_coord : float) (y_coord : float) : int * int = 
    let xpixel = 
      int_of_float (((x_coord -. !x_min) /. (!x_max -. !x_min)) *. float width) in 
    let ypixel = 
      int_of_float (((y_coord -. !y_min) /. (!y_max -. !y_min)) *. float height) in 
    xpixel, ypixel 
  in *)
  let pixel_to_coord (xpixel : int) (ypixel : int) : float * float = 
    let delta_x, delta_y = 
      ((!x_max -. !x_min) /. float Config.width, (!y_max -. !y_min) /. float Config.height) in 
    let xcoord = (delta_x *. float xpixel +. !x_min) in 
    let ycoord = (delta_y *. float ypixel +. !y_min) in 
    (xcoord, ycoord)
  in 
  let ui_loop (fractal : image) =  
    let e = G.wait_next_event [Key_pressed; Button_up; Button_down] in
    if e.key = 'q' then raise Program_quit
    else if e.key = 'e' then 
      max_iteration := int_of_float (1.5 *. float !max_iteration)
    else 
      G.set_color G.black; 
      G.set_line_width 5; 
      let box = Controller.view fractal in 
      G.draw_poly box;
      G.synchronize ();
      loading (); 
      let xpixel_start, ypixel_start = box.(0) in 
      let xpixel_end, ypixel_end = box.(2) in 
      let new_xmin, new_ymin = pixel_to_coord xpixel_start ypixel_start in 
      let new_xmax, new_ymax = pixel_to_coord xpixel_end ypixel_end in
      x_min := new_xmin; 
      x_max := new_xmax; 
      y_min := new_ymin; 
      y_max := new_ymax; 
      max_iteration := int_of_float (1.5 *. float !max_iteration);
  in
  while true do 
    G.clear_graph (); 
    current_image := depict_fractal Config.width 
                                  Config.height 
                                  !x_min 
                                  !x_max 
                                  !y_min
                                  !y_max
                                  Config.color
                                  !max_iteration
                                  !current_image;
    let fractal = G.make_image !current_image in 
    G.draw_image fractal 0 0 ; 
    G.synchronize (); 
    ui_loop fractal;
  done ;;  
    

let () = 
  G.open_graph ""; 
  G.resize_window Config.width Config.height;
  G.set_window_title "Fractal Viewer";
  G.auto_synchronize false;
  main_loop (); 
  G.close_graph ();; 







(* 
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
  let max_iteration = ref Config.max_step in 
  let current_image = 
    ref (Array.make Config.height (Array.make Config.width 0)) in 

  while true do 
  (* view fractal *)
    current_image := depict_fractal Config.width 
                                    Config.height 
                                    !x_min 
                                    !x_max 
                                    !y_min
                                    !y_max
                                    Config.color
                                    !max_iteration
                                    !current_image;
    (* view fractal *)
    G.clear_graph (); 
    let fractal = G.make_image !current_image in 
    G.draw_image fractal 0 0 ; 
    G.synchronize (); 
    (* user selecting area to zoom into *)
    let pixel_selection = Controller.view fractal in 
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
    max_iteration := int_of_float (1.15 *. float !max_iteration);
    Controller.loading ();
  done;;
 *)

let () = 
  main_loop ();; 
