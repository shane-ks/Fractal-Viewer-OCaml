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
  


