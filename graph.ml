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

let depict_fractal (width : int)
                   (height : int) 
                   (xmin : float)
                   (xmax : float)
                   (ymin : float)
                   (ymax : float) 
                   (color : bool)
                   (max_step : int)
                   (init_image : int array array) 
                   : int array array  = 
  let mandelbrot_calculation (xpixel : int) (ypixel : int) : int = 
      let delta_x, delta_y = 
        (xmax -. xmin) /. float width, (ymax -. ymin) /. float height in 
      let real = (delta_x *. float xpixel +. xmin) in 
      let imag = (delta_y *. float ypixel +. ymin) in
      let c = CNum.define real imag in 
      let iter_count, mandelbrot_set = 
        Mandelbrot.in_mandelbrot CNum.zero c max_step in 
      if mandelbrot_set then G.rgb 0 0 0 
      else 
          if color && not mandelbrot_set then 
            let colg = 
              int_of_float 
                (255. *. (1. -. Stdlib.exp (-.2. *. (float iter_count) 
                  /. (float max_step)))) in 
            let colb = 
              int_of_float 
                (255. *. (1. -. Stdlib.exp (-.0.5 *. (float iter_count) 
                  /. (float max_step))) ) in 
            G.rgb 160 colg colb 
          else G.rgb 255 255 255
  in
  Array.mapi  (fun i row -> 
    Array.mapi (fun j _current_color -> 
      mandelbrot_calculation j i) row) init_image ;;
  


(* 
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
