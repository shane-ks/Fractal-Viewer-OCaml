(*
                    CS51 Final Project
                      Shane Kissinger
 *)

(* Description: This file handles all of the user interaction with the UI. *)
module G = Graphics ;;
open Graphics ;; 
open Config ;; 

(* 
class type widget = 
  object 
    val widget_color : color
    val mutable location : int * int 
    val width : int 
    val height : int 
    val text_color : color 
    val text : string 
    method get_width : () -> int 
    method get_height : () -> int 
    method get_widget_color : () -> color 
    method get_text_color : () -> color 
    method draw : () -> () 
    method update_text : () -> () 
  end ;;  *)

class banner = 
  object
    val widget_color = G.rgb 43 43 43
    val mutable location = 0, 0 
    val width = Config.width
    val height = Config.height
    val text_color = G.white 
    val mutable loading = false 
    val mutable pos_real = 0. 
    val mutable pos_imag = 0. 
    method get_real () : float = pos_real 
    method get_imag () : float = pos_imag 
    val mutable pos_text = "Position: 0.0 + 0.0i"

    method update_pos_text () = 
      let complex_number = 
        (string_of_float pos_real) ^ " + " ^ (string_of_float pos_imag) ^ "i" in 
      pos_text <- "Position: " ^ complex_number 

    method update_pos (xpixel : int) 
                      (ypixel : int) 
                      (x_min : float)
                      (x_max : float)
                      (y_min : float)
                      (y_max : float) = 
      let pos_x, pos_y = 
        Graph.pixel_to_coord xpixel ypixel x_min x_max y_min y_max in 
      pos_real <- pos_x; 
      pos_imag <- pos_y
    method toggle_loading () = 
      loading <- not loading 
    method get_widget_color () = widget_color 
    method get_text_color () = text_color 
    method draw () = 
      let generate_banner (load_status : string) (pos : string) = 
        begin
          G.set_color (G.rgb 43 43 43);
          G.fill_rect 0 0 Config.width 20;
          G.set_color G.white;
          G.set_text_size 50;
          G.moveto 5 5 ; 
          G.draw_string load_status;
          G.moveto 80 5 ;
          G.draw_string pos;  
        end 
      in
      if loading then 
        generate_banner ("Loading... | ") pos_text 
      else 
        generate_banner ("Loaded     | ") pos_text 
  end ;; 


let loading () = 
  begin
    G.set_color (G.rgb 43 43 43);
    G.fill_rect 0 0 70 20; 
    G.moveto 5 5 ; 
    G.set_color G.white;
    G.set_text_size 75;
    G.draw_string "Loading... | ";
    G.synchronize ()
  end ;; 

let loaded () = 
  begin
    G.set_color (G.rgb 43 43 43);
    G.fill_rect 0 0 70 20; 
    G.moveto 5 5 ; 
    G.set_color G.white;
    G.set_text_size 75;
    G.draw_string "Loaded     | ";
    G.synchronize ()
  end ;; 

let cursor_pos (xpos : int)
               (ypos : int) 
               (x_min : float)
               (x_max : float)
               (y_min : float)
               (y_max : float) 
               : unit = 
  begin
    let real, imag = 
      Graph.pixel_to_coord xpos
                           ypos 
                           x_min
                           x_max
                           y_min
                           y_max in 
    G.set_color (G.rgb 43 43 43);
    G.fill_rect 0 0 Config.width 20; 
    G.moveto 80 5 ; 
    G.set_color G.white;
    G.set_text_size 50;
    let pos_string = 
      (string_of_float real) ^ " + " ^ (string_of_float imag) ^ "i" in 
    G.draw_string ("Position: " ^ pos_string); 
    G.synchronize ()
  end

let ui_loop (x_min : float ref) 
            (x_max : float ref)
            (y_min : float ref)
            (y_max : float ref)
            (max_iteration : int ref)
            (quit : bool ref) 
            : unit = 
  let fractal_bkg = G.get_image 0 0 Config.width Config.height in
  let clicks = ref 0 in 
  let pane = Array.make 4 (0, 0) in
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
    while !clicks < 2 do 
      let e = G.wait_next_event [Button_up; Button_down; Mouse_motion; Key_pressed] in 
      cursor_pos e.mouse_x 
                 e.mouse_y 
                 !x_min 
                 !x_max
                 !y_min
                 !y_max; 
      loaded ();
      if e.key = 'q' then 
        begin
          quit := true; 
          clicks := 3; 
        end
      else if e.key = 'e' then 
        begin
          pane.(0) <- 0, 0; 
          pane.(1) <- Config.width, 0; 
          pane.(2) <- Config.width, Config.height; 
          pane.(3) <- 0, Config.height;
          clicks := 5
        end
      else if e.button && (!clicks <> 0) then 
        begin 
          end_x := e.mouse_x; 
          end_y := e.mouse_y; 
          incr clicks; 
          update_selection ();
          cursor_pos e.mouse_x 
                 e.mouse_y 
                 !x_min 
                 !x_max
                 !y_min
                 !y_max; 
        end 
      else if e.button && (!clicks = 0)then 
        begin
          init_x := e.mouse_x; 
          init_y := e.mouse_y; 
          end_x := e.mouse_x; 
          end_y := e.mouse_y;
          incr clicks; 
          update_selection ();
          cursor_pos e.mouse_x 
                 e.mouse_y 
                 !x_min 
                 !x_max
                 !y_min
                 !y_max; 
        end 
      else if !clicks <> 0 then  
        begin 
          end_x := e.mouse_x; 
          end_y := e.mouse_y; 
          update_selection ();
          cursor_pos e.mouse_x 
                 e.mouse_y 
                 !x_min 
                 !x_max
                 !y_min
                 !y_max; 
        end
    done;
    pane ; 
  in 
  let e = G.wait_next_event [Key_pressed; Button_up; Mouse_motion; Button_down] in
    if e.key = 'q' then quit := true
    else if e.key = 'e' then 
      max_iteration := int_of_float (1.5 *. float !max_iteration)
    else 
      G.set_color G.black; 
      G.set_line_width 5; 
      let pane = select_pane () in 
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

