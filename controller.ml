(*
                    CS51 Final Project
                      Shane Kissinger
 *)

(* Description: This file handles all of the user interaction with the UI. *)
module G = Graphics ;;

(* creates the class for the banner at the bottom of the screen. *)
class widget_banner = 
  object
    val widget_color = G.rgb 43 43 43

    val banner_width = Config.width

    val banner_height = 20

    val text_color = G.white 

    val mutable loading = false 

    val mutable pos_real = 0. 

    val mutable pos_imag = 0. 

    val mutable pos_text = "Position: 0.0 + 0.0i"

    (* method to update the text in the banner with current position value *)
    method update_pos_text () = 
      let complex_number = 
        (string_of_float pos_real) ^ " + " ^ (string_of_float pos_imag) ^ "i" in 
      pos_text <- "Position: " ^ complex_number 

    (* method to update the position of the cursor in the banner *)
    method update_pos (xpixel : int) 
                      (ypixel : int) 
                      (x_min : float)
                      (x_max : float)
                      (y_min : float)
                      (y_max : float) = 
      let pos_x, pos_y = 
        Graph.coord_of_pixel xpixel ypixel x_min x_max y_min y_max in 
      pos_real <- pos_x; 
      pos_imag <- pos_y

    (* updates loading status for the banner *)
    method set_loading (status : bool) = 
      loading <- status 
    (* draws the banner at the bottom of the screen *)

    method draw () = 
      let generate_banner (load_status : string) (pos : string) = 
        begin
          G.set_color widget_color;
          G.fill_rect 0 0 banner_width banner_height;
          G.set_color text_color;
          G.set_text_size 50;
          G.moveto 5 5 ; 
          G.draw_string load_status;
          G.moveto 80 5 ;
          G.draw_string pos;  
          G.synchronize ();
        end 
      in
      if loading then 
        generate_banner ("Loading... | ") pos_text 
      else 
        generate_banner ("Loaded     | ") pos_text 
  end ;; 

(* instantiates the banner object *)
let banner = new widget_banner ;; 

(* the loop that handles all of the user interactions *)
let ui_loop (x_min : float ref) 
            (x_max : float ref)
            (y_min : float ref)
            (y_max : float ref)
            (max_iteration : int ref)
            (quit : bool ref) 
            : unit = 
  let fractal_bkg = G.get_image 0 0 Config.width Config.height in
  (* initialized viewing pane *)
  let pane = Array.make 4 (0, 0) in
  let init_x, init_y = (ref 0, ref 0) in 
  let end_x, end_y = (ref Config.width, ref Config.height) in 
  (* updates the viewing pane as the user selects area *)
  let update_selection () = 
    begin
      pane.(0) <- !init_x, !init_y; 
      pane.(1) <- !end_x, !init_y; 
      pane.(2) <- !end_x, !end_y; 
      pane.(3) <- !init_x, !end_y;
      G.clear_graph (); 
      G.draw_image fractal_bkg 0 0; 
      G.set_color (G.rgb 43 43 43); 
      G.set_line_width 3; 
      G.draw_poly pane;
      banner#draw ();
    end
  in
  let rec select_pane (click_count : int) : (int * int) array = 
    banner#set_loading false; 
    let e = G.wait_next_event [Button_up; Button_down; Mouse_motion; Key_pressed] in 
    banner#update_pos e.mouse_x e.mouse_y !x_min !x_max !y_min !y_max; 
    banner#update_pos_text (); 
    banner#draw (); 
    if click_count < 2 then 
      begin
        (* user presses q to quit *)
        if e.key = 'q' then
          begin  
            quit := true;
            select_pane (click_count + 2)
          end 
        (* user pressed e to enhance the picture *)
        else if e.key = 'e' then 
          begin
            pane.(0) <- 0, 0; 
            pane.(1) <- Config.width, 0; 
            pane.(2) <- Config.width, Config.height; 
            pane.(3) <- 0, Config.height;
            select_pane (click_count + 2);
          end
        else if e.button && (click_count = 0) then 
          begin
            init_x := e.mouse_x; 
            init_y := e.mouse_y; 
            end_x := e.mouse_x; 
            end_y := e.mouse_y;
            update_selection ();
            G.synchronize ();
            select_pane (succ click_count)
          end 
        else if e.button && (click_count = 1) then
          begin 
            end_x := e.mouse_x; 
            end_y := e.mouse_y; 
            update_selection ();
            G.synchronize ();
            select_pane (succ click_count)
          end
        else if click_count <> 0 then  
          begin 
            end_x := e.mouse_x; 
            end_y := e.mouse_y; 
            banner#update_pos e.mouse_x e.mouse_y !x_min !x_max !y_min !y_max; 
            banner#update_pos_text (); 
            update_selection ();
            banner#draw (); 
            G.synchronize ();
            select_pane click_count
          end
        else 
          select_pane click_count
        end
    else
      begin
        banner#update_pos !end_x !end_y !x_min !x_max !y_min !y_max; 
        banner#update_pos_text (); 
        banner#set_loading true;
        banner#draw ();
        G.synchronize ();
        pane
      end 
  in 
    let pane = select_pane 0 in 
    (* update x and y ranges with new ranges from viewing pane selection *)
    let xpixel_start, ypixel_start = pane.(0) in 
    let xpixel_end, ypixel_end = pane.(2) in 
    let new_xmin, new_ymin = 
      Graph.coord_of_pixel xpixel_start 
                            ypixel_start 
                            !x_min
                            !x_max
                            !y_min
                            !y_max in 
    let new_xmax, new_ymax = 
      Graph.coord_of_pixel xpixel_end 
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

