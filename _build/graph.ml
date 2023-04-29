(*
                    CS51 Final Project
                      Shane Kissinger
 *)

(* Description: This file graphs the points in a grid with a color associated 
with if it is contained or not contained in the Mandelbrot set, as determined 
by mandelbrot.ml *)
open ComplexNum ;; 
module G = Graphics ;;
open Config ;; 
open Mandelbrot ;;
open Unix ;; 

(* I think I should have the function depict_fractal output a color matrix... 
   it might be more versatile. *)


let initialize_image (width : int) (height : int) : int array array = 
  Array.make height (Array.make width 0) ;; 


let depict_fractal (width : int)
                   (height : int) 
                   (xmin : float)
                   (xmax : float)
                   (ymin : float)
                   (ymax : float) 
                   (color : bool)
                   (max_step : int)
                   (init_image : int array array) : unit  = 
  (* let blank_image = initialize_image Config.width Config.height in  *)
  let mandelbrot_calculation (xpixel : int) (ypixel : int) : int = 
    begin
      let delta_x, delta_y = 
        (xmax -. xmin) /. float width, (ymax -. ymin) /. float height in 
      let real = (delta_x *. float xpixel +. xmin) in 
      let imag = (delta_y *. float ypixel +. ymin) in
      let c = CNum.define real imag in 
      let iter_count, mandelbrot_set = 
        Mandelbrot.in_mandelbrot CNum.zero c max_step in 
      if mandelbrot_set then G.black
      else 
        begin
          if color && not mandelbrot_set then 
        (* perhaps could implement function that matches color selection with 
          a color function *)
            let colg = 
              int_of_float 
                (255. *. (1. -. Stdlib.exp (-.2. *. (float iter_count) 
                  /. (float max_step))) ) in 
            let colb = 
              int_of_float 
                (255. *. (1. -. Stdlib.exp (-.0.5 *. (float iter_count) 
                  /. (float max_step))) ) in 
            G.rgb 160 colg colb 
          else G.rgb 255 255 255
        end 
    end 
  in
  (* first iteri is going over the rows the second is going over columns *)
  Array.iteri  (fun i row -> 
    Array.iteri (fun j current_color -> 
      init_image.(i).(j) <- mandelbrot_calculation j i) row) init_image ;;
  
  





(* let depict_fractal (width : int)
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
              G.set_color G.black; 
              G.plot xpixel ypixel;
            end
          else if color && not mandelbrot_set then 
            begin 
              let colg = int_of_float (255. *. (1. -. Stdlib.exp (-.2. *. (float iter_count) /. (float max_step))) ) in 
              let colb = int_of_float (255. *. (1. -. Stdlib.exp (-.0.5 *. (float iter_count) /. (float max_step))) ) in 
              let point_color = G.rgb 160 colg colb in 
              G.set_color point_color;
              G.plot xpixel ypixel;
            end
    done;
  done;;  *)

(* let () = 
  G.open_graph ""; 
  G.resize_window width height;
  G.set_window_title "Fractal Viewer";
  G.auto_synchronize false;
  main_loop (); 
  G.close_graph ();;  *)
