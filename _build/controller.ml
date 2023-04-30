(*
                    CS51 Final Project
                      Shane Kissinger
 *)

(* Description: This file handles all of the user interaction with the UI. *)
module G = Graphics ;;
open Config ;; 

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


let ui_loop (x_min : float ref) 
            (x_max : float ref)
            (y_min : float ref)
            (y_max : float ref)
            (max_iteration : int ref)
            (quit : bool ref) : unit = 
  let fractal_bkg = G.get_image 0 0 Config.width Config.height in
  let pane = Array.make 4 (0, 0) in 
  let clicks = ref 0 in 
  let init_x, init_y = (ref 0, ref 0) in 
  let end_x, end_y = (ref Config.width, ref Config.height) in 

  let update_selection () = 
    begin
      pane.(0) <- !init_x, !init_y; 
      pane.(1) <- !end_x, !init_y; 
      pane.(2) <- !end_x, !end_y; 
      pane.(3) <- !init_x, !end_y;
      G.clear_graph (); 
      G.draw_image fractal_bkg 0 0; 
      G.set_color G.black; 
      G.set_line_width 5; 
      G.draw_poly pane;
      G.synchronize ();
    end
  in
  
  let select_pane () : (int * int) array = 
    while !clicks <= 2 do 
      let e = G.wait_next_event [Button_up; Button_down; Mouse_motion; Key_pressed] in 
      if e.button && (!clicks <> 0) then 
        begin 
          end_x := e.mouse_x; 
          end_y := e.mouse_y; 
          incr clicks; 
          update_selection ()
        end 
      else if e.button && (!clicks = 0)then 
        begin
          init_x := e.mouse_x; 
          init_y := e.mouse_y; 
          end_x := e.mouse_x; 
          end_y := e.mouse_y;
          incr clicks; 
          update_selection ()
        end 
      else if !clicks <> 0 then 
        begin 
          end_x := e.mouse_x; 
          end_y := e.mouse_y; 
          update_selection ()
        end
    done;
    pane ; 
  in 

  let e = G.wait_next_event [Key_pressed; Button_up; Button_down] in
    if e.key = 'q' then quit := true
    else if e.key = 'e' then 
      max_iteration := int_of_float (1.5 *. float !max_iteration)
    else 
      G.set_color G.black; 
      G.set_line_width 5; 
      let pane = select_pane () in 
      G.draw_poly pane;
      G.synchronize ();
      loading (); 
      let xpixel_start, ypixel_start = pane.(0) in 
      let xpixel_end, ypixel_end = pane.(2) in 
      let new_xmin, new_ymin = 
        Graph.pixel_to_coord xpixel_start 
                             ypixel_start 
                             !x_min
                             !x_max
                             !y_min
                             !y_max in 
      let new_xmax, new_ymax = 
        Graph.pixel_to_coord xpixel_end 
                             ypixel_end 
                             !x_min
                             !x_max
                             !y_min
                             !y_max in
      x_min := new_xmin; 
      x_max := new_xmax; 
      y_min := new_ymin; 
      y_max := new_ymax; 
      max_iteration := int_of_float (1.5 *. float !max_iteration);;



(* 
let ui_loop () =  
  let e = G.wait_next_event [Key_pressed; Button_up; Button_down] in
  if e.key = 'q' then raise Program_quit
  else if e.key = 'e' then 
    max_iteration := int_of_float (1.5 *. float !max_iteration)
  else 
    G.set_color G.black; 
    G.set_line_width 5; 
    let box = drag_rect () in 
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


let drag_rect () : (int * int) array = 
  let fractal_bkg = G.get_image 0 0 width height in
  let box = Array.make 4 (0, 0) in 
  let clicks = ref 0 in 
  let init_x, init_y = (ref 0, ref 0) in 
  let end_x, end_y = (ref 0, ref 0) in 
  while !clicks <= 2 do 
    let e = G.wait_next_event [Button_up; Button_down; Mouse_motion; Key_pressed] in 
    if e.button && (!clicks <> 0) then 
      begin 
        end_x := e.mouse_x; 
        end_y := e.mouse_y; 
        incr clicks; 
        box.(0) <- !init_x, !init_y; 
        box.(1) <- !end_x, !init_y; 
        box.(2) <- !end_x, !end_y; 
        box.(3) <- !init_x, !end_y;
        G.clear_graph (); 
        G.draw_image fractal_bkg 0 0; 
        G.set_color G.black; 
        G.set_line_width 5; 
        G.draw_poly box;
        G.synchronize ();
      end 
    else if e.button && (!clicks = 0)then 
      begin
        init_x := e.mouse_x; 
        init_y := e.mouse_y; 
        end_x := e.mouse_x; 
        end_y := e.mouse_y;
        incr clicks; 
        box.(0) <- !init_x, !init_y; 
        box.(1) <- !end_x, !init_y; 
        box.(2) <- !end_x, !end_y; 
        box.(3) <- !init_x, !end_y;
        G.draw_image fractal_bkg 0 0; 
        G.set_color G.black; 
        G.set_line_width 5; 
        G.draw_poly box;
        G.synchronize ();
      end 
    else if !clicks <> 0 then 
      begin 
        end_x := e.mouse_x; 
        end_y := e.mouse_y; 
        box.(0) <- !init_x, !init_y; 
        box.(1) <- !end_x, !init_y; 
        box.(2) <- !end_x, !end_y; 
        box.(3) <- !init_x, !end_y;
        G.clear_graph (); 
        G.draw_image fractal_bkg 0 0; 
        G.set_color G.black; 
        G.set_line_width 5; 
        G.draw_poly box;
        G.synchronize ();
      end
  done;
  box ;;   *)