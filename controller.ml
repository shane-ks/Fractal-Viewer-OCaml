(*
                    CS51 Final Project
                      Shane Kissinger
 *)

(* Description: This file contains all of the functions handling 
   user interactions. *)

open Graph;; 
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

let pixel_to_coord (xpixel : int) 
                   (ypixel : int) 
                   (x_min : float)
                   (x_max : float)
                   (y_min : float)
                   (y_max : float)
                   : float * float = 
    let delta_x, delta_y = 
      ((x_max -. x_min) /. float Config.width, 
       (y_max -. y_min) /. float Config.height) in 
    let xcoord = (delta_x *. float xpixel +. x_min) in 
    let ycoord = (delta_y *. float ypixel +. y_min) in 
    (xcoord, ycoord) ;; 


let view (fractal : int array array) : (int * int) array = 
  let box = Array.make 4 (0, 0) in 
  let clicks = ref 0 in 
  let init_x, init_y = (ref 0, ref 0) in 
  let end_x, end_y = (ref 0, ref 0) in 
  let fractal_bkg = G.make_image fractal in 
  let update_rect () = 
    begin
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
  in
  while !clicks <= 2 do 
    let e = 
      G.wait_next_event [Button_up; Button_down; Mouse_motion; Key_pressed] in 
    if e.key = 'q' then raise Program_quit
    else if e.button && (!clicks <> 0) then 
      begin 
        end_x := e.mouse_x; 
        end_y := e.mouse_y; 
        incr clicks; 
        update_rect (); 
      end 
    else if e.button && (!clicks = 0)then 
      begin
        init_x := e.mouse_x; 
        init_y := e.mouse_y; 
        end_x := e.mouse_x; 
        end_y := e.mouse_y;
        incr clicks; 
        update_rect ();
      end 
    else if !clicks <> 0 then 
      begin 
        end_x := e.mouse_x; 
        end_y := e.mouse_y; 
        update_rect (); 
      end
  done;
  box ;; 




(* let drag_rect () : (int * int) array = 
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
  box ;;  *)

(* 
let main_loop () = 
  let x_min = ref xmin in
  let x_max = ref xmax in
  let y_min = ref ymin in
  let y_max = ref ymax in
  
  let max_iteration = ref max_step in 

  let pixel_to_coord (xpixel : int) (ypixel : int) : float * float = 
    let delta_x, delta_y = 
      ((!x_max -. !x_min) /. float width, (!y_max -. !y_min) /. float height) in 
    let xcoord = (delta_x *. float xpixel +. !x_min) in 
    let ycoord = (delta_y *. float ypixel +. !y_min) in 
    (xcoord, ycoord)
  in 
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
  in
  while true do 
      G.clear_graph (); 
      depict_fractal width
                    height
                    !x_min
                    !x_max 
                    !y_min 
                    !y_max
                    color
                    !max_iteration;
      G.synchronize (); 
      ui_loop ();
  done ;;  
     *)
