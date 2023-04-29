(*
                    CS51 Final Project
                      Shane Kissinger
 *)

(* Description: This file graphs the points in a grid with a color associated 
with if it is contained or not contained in the Mandelbrot set, as determined 
by mandelbrot.ml *)
open ComplexNum ;; 
open Graphics ;;
open Config ;; 
open Mandelbrot ;;
open Unix ;; 

exception Program_quit ;; 


(* let initialize_image (rows : int) (col : int) : int array array = 
    Array.init rows (fun i -> 
      (Array.init col (fun j -> 0))) ;; 

      let width = 800 ;;
      let height = 600 ;; 
      (* sets the minimum and maximum real value to compute *)
      let xmin = -.2.05 ;;
      let xmax = 0.6 ;;
      (* sets the minimum and maximum imaginary value to compute *)
      let ymin = -.1.14 ;;
      let ymax = 1.14 ;;
      let color = false ;;  *)

let depict_fractal (width : int)
                   (height : int) 
                   (xmin : float)
                   (xmax : float)
                   (ymin : float)
                   (ymax : float) 
                   (color : bool)
                   (max_step : int) = 
  let delta_x, delta_y = 
    (xmax -. xmin) /. float width, (ymax -. ymin) /. float height in 
  for xpixel = 0 to (width - 1) do
    let real = delta_x *. float xpixel +. xmin in
    for ypixel  = 0 to (height - 1) do  
      let imag = delta_y *. float ypixel +. ymin in  
      let c  = CNum.define real imag in 
      let iter_count, mandelbrot_set = Mandelbrot.in_mandelbrot CNum.zero c max_step in
          if mandelbrot_set then 
            begin
              Graphics.set_color Graphics.black; 
              Graphics.plot xpixel ypixel;
            end
          else if color && not mandelbrot_set then 
            begin 
              let colg = int_of_float (255. *. (1. -. Stdlib.exp (-.2. *. (float iter_count) /. (float max_step))) ) in 
              let colb = int_of_float (255. *. (1. -. Stdlib.exp (-.0.5 *. (float iter_count) /. (float max_step))) ) in 
              let point_color = Graphics.rgb 160 colg colb in 
              Graphics.set_color point_color;
              Graphics.plot xpixel ypixel;
            end
    done
  done;;
  (* ignore (Graphics.read_key ()); (* Wait for a key press *)
  Graphics.close_graph () ;;  *)

let loading () = 
  Graphics.set_color Graphics.white;
  fill_rect 0 0 70 20; 
  moveto 5 5 ; 
  Graphics.set_color Graphics.blue;
  Graphics.set_text_size 75;
  Graphics.draw_string "Loading...";
  Graphics.synchronize ();;

let main_loop () = 
  let clicked = ref false in 
  (* let active = ref true in  *)
  let x_min = ref xmin in
  let x_max = ref xmax in
  let y_min = ref ymin in
  let y_max = ref ymax in

  let x_start_box = ref 0 in 
  let y_start_box = ref 0 in 
  let x_end_box = ref 0 in 
  let y_end_box = ref 0 in 
  
  let max_iteration = ref max_step in 

  let coord_to_pixel (x_coord : float) (y_coord : float) : int * int = 
    let xpixel = 
      int_of_float (((x_coord -. !x_min) /. (!x_max -. !x_min)) *. float width) in 
    let ypixel = 
      int_of_float (((y_coord -. !y_min) /. (!y_max -. !y_min)) *. float height) in 
    xpixel, ypixel 
  in

  let pixel_to_coord (xpixel : int) (ypixel : int) : float * float = 
    let delta_x, delta_y = 
      (!x_max -. !x_min) /. float width, (!y_max -. !y_min) /. float height in 
    let xcoord = delta_x *. float xpixel +. !x_min in 
    let ycoord = delta_y *. float ypixel +. !y_min in 
    xcoord, ycoord 
  in 

  let ui_loop () = 
    let e = wait_next_event [Key_pressed] in
    if e.key = 'q' then 
      raise Program_quit
    else
        let box = drag_rect (); 
        Graphics.set_color Graphics.black; 
        Graphics.set_line_width 5; 
        Graphics.draw_poly box;
        Graphics.synchronize ();
        loading (); 
        let xpixel_start, ypixel_start = box.(0) in 
        let xpixel_end, ypixel_end = box.(2) in 
        let new_xmin, new_ymin = pixel_to_coord xpixel_start, ypixel_start in 
        let new_xmax, new_ymax = pixel_to_coord xpixel_end, ypixel_end in
        x_min := new_xmin; 
        x_max := new_xmax; 
        y_min := new_ymin; 
        y_max := new_ymax; 
        max_iteration := int_of_float (1.5 *. float !max_iteration);
  in 
  (* let rec ui_loop () = 
    let e = wait_next_event [Button_up; Button_down; Key_pressed] in 
    if e.button then 
      begin 
        if not !clicked then
          begin
            clicked := true; 
            x_start_box := e.mouse_x;
            y_start_box := e.mouse_y; 
          end 
      end 
    else if !clicked then 
      begin 
        clicked := false; 
        x_end_box := e.mouse_x; 
        y_end_box := e.mouse_y;  
        let box = [|(!x_start_box, !y_start_box); (!x_end_box, !y_start_box); 
                    (!x_end_box, !y_end_box); (!x_start_box, !y_end_box)|] in 
        Graphics.set_color Graphics.black; 
        Graphics.set_line_width 5; 
        Graphics.draw_poly box;
        Graphics.synchronize ();
        loading (); 
        let new_xmin, new_ymin = pixel_to_coord !x_start_box !y_start_box in 
        let new_xmax, new_ymax = pixel_to_coord !x_end_box !y_end_box in
        x_min := new_xmin; 
        x_max := new_xmax; 
        y_min := new_ymin; 
        y_max := new_ymax; 
        max_iteration := int_of_float (1.5 *. float !max_iteration);
      end 
    else if e.key = 'q' then 
        raise Program_quit
    else 
      ui_loop ()
    in  *)

  while true do 
    clear_graph (); 
    depict_fractal width
                   height
                   !x_min
                   !x_max 
                   !y_min 
                   !y_max
                   color
                   !max_iteration;
    Graphics.synchronize (); 
    ui_loop ();
  done ;;
    

let drag_rect () : (int * int) array = 
  (* Graphics.open_graph ""; 
  Graphics.resize_window width height;
  Graphics.auto_synchronize false; *)
  let box = Array.make 4 (0, 0) in 
  let clicks = ref 0 in 
  let init_x, init_y = (ref 0, ref 0) in 
  let end_x, end_y = (ref 0, ref 0) in 
  while !clicks <= 2 do 
    let e = wait_next_event [Button_up; Button_down; Mouse_motion; Key_pressed] in 
    if e.button && (!clicks <> 0) then 
      begin 
        end_x := e.mouse_x; 
        end_y := e.mouse_y; 
        incr clicks; 
        box.(0) <- !init_x, !init_y; 
        box.(1) <- !end_x, !init_y; 
        box.(2) <- !end_x, !end_y; 
        box.(3) <- !init_x, !end_y;
        clear_graph (); 
        Graphics.set_color Graphics.black; 
        Graphics.set_line_width 5; 
        Graphics.draw_poly box;
        Graphics.synchronize ();
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
        Graphics.set_color Graphics.black; 
        Graphics.set_line_width 5; 
        Graphics.draw_poly box;
        Graphics.synchronize ();
      end 
    else if !clicks <> 0 then 
      begin 
        end_x := e.mouse_x; 
        end_y := e.mouse_y; 
        box.(0) <- !init_x, !init_y; 
        box.(1) <- !end_x, !init_y; 
        box.(2) <- !end_x, !end_y; 
        box.(3) <- !init_x, !end_y;
        clear_graph (); 
        Graphics.set_color Graphics.black; 
        Graphics.set_line_width 5; 
        Graphics.draw_poly box;
        Graphics.synchronize ();
      end
    done;
    box ;;  



let () = 
  Graphics.open_graph ""; 
  Graphics.resize_window width height;
  Graphics.set_window_title "Fractal Viewer";
  Graphics.auto_synchronize false;
  main_loop (); 
  close_graph ();; 

(* let () = 
  drag_rect () ;;  *)


(* 
  let rec ui_loop () = 
    let e = wait_next_event [Button_up; Button_down; Key_pressed] in 
    if e.button then 
      begin 
        if not !clicked then
          begin
            clicked := true; 
            x_start_box := e.mouse_x;
            y_start_box := e.mouse_y; 
          end 
      end 
    else if !clicked then 
      begin 
        clicked := false; 
        x_end_box := e.mouse_x; 
        y_end_box := e.mouse_y;  
        let box = [|(!x_start_box, !y_start_box); (!x_end_box, !y_start_box); 
                    (!x_end_box, !y_end_box); (!x_start_box, !y_end_box)|] in 
        Graphics.set_color Graphics.black; 
        Graphics.set_line_width 5; 
        Graphics.draw_poly box;
        Graphics.synchronize ();
        loading (); 
        let new_xmin, new_ymin = pixel_to_coord !x_start_box !y_start_box in 
        let new_xmax, new_ymax = pixel_to_coord !x_end_box !y_end_box in
        x_min := new_xmin; 
        x_max := new_xmax; 
        y_min := new_ymin; 
        y_max := new_ymax; 
        max_iteration := int_of_float (1.5 *. float !max_iteration);
      end 
    else if e.key = 'q' then 
        raise Program_quit
    else 
      ui_loop ()  *)