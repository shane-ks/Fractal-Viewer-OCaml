(*
                    CS51 Final Project
                      Shane Kissinger
 *)
(* Description: This file runs the program and handles user interaction. *)
module G = Graphics;;

(* creates the viewing window *)
let initialize_window () = 
  G.open_graph ""; 
  G.resize_window Config.width Config.height;
  G.set_window_title "Fractal Viewer";
  G.auto_synchronize false;
  G.display_mode false;;

(* the main loop of the program *)
let rec main_loop (width : int)
                  (height : int)
                  (x_min : float ref) 
                  (x_max : float ref)
                  (y_min : float ref)
                  (y_max : float ref)
                  (max_iteration : int ref)
                  (quit_loop : bool ref) 
                  : unit =
  initialize_window (); 
  if not !quit_loop then 
    begin 
      G.clear_graph (); 
      (* draws the fractal *)
      Graph.depict_fractal width
                          height
                          !x_min
                          !x_max 
                          !y_min 
                          !y_max
                          Config.color
                          !max_iteration;
      G.synchronize (); 
      (* handles user input *)
      Controller.ui_loop x_min 
                        x_max 
                        y_min 
                        y_max
                        max_iteration
                        quit_loop; 
      main_loop width height x_min x_max y_min y_max max_iteration quit_loop 
    end ;;

let () = 
  let x_min = ref Config.xmin in 
  let x_max = ref Config.xmax in 
  let y_min = ref Config.ymin in 
  let y_max = ref Config.ymax in 
  let max_iteration = ref Config.max_step in 
  let quit_loop = ref false in  
    main_loop Config.width 
              Config.height 
              x_min 
              x_max 
              y_min 
              y_max 
              max_iteration 
              quit_loop ;; 