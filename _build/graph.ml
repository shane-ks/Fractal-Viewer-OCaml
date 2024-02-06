(*
                    CS51 Final Project
                      Shane Kissinger
 *)

(* Description: This file graphs the points in a grid with a color associated 
with if it is contained or not contained in the Mandelbrot set, as determined 
by mandelbrot.ml *)

module G = Graphics ;;
open Graphics ;; 
open Config ;; 
open Mandelbrot ;;
open ComplexNum ;; 

let coord_of_pixel (xpixel : int)
                   (ypixel : int) 
                   (x_min : float)
                   (x_max : float)
                   (y_min : float)
                   (y_max : float)
                   : float * float = 
  let delta_x, delta_y = 
    ((x_max -. x_min) /. float Config.width, (y_max -. y_min) /. float Config.height) in 
  let xcoord = (delta_x *. float xpixel +. x_min) in 
  let ycoord = (delta_y *. float ypixel +. y_min) in 
  (xcoord, ycoord);; 

let pixel_of_coord (x_coord : float) 
                   (y_coord : float) 
                   (x_min : float)
                   (x_max : float)
                   (y_min : float)
                   (y_max : float)
                   : int * int = 
    let xpixel = 
      int_of_float (((x_coord -. x_min) /. (x_max -. x_min)) *. float Config.width) in 
    let ypixel = 
      int_of_float (((y_coord -. y_min) /. (y_max -. y_min)) *. float Config.height) in 
    xpixel, ypixel ;; 

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
  let rec xpixel_plot (xpixel : int) = 
    if xpixel < width then 
      let real = delta_x *. float xpixel +. xmin in
      let rec ypixel_plot (ypixel : int) = 
        if ypixel < height then 
          let imag = delta_y *. float ypixel +. ymin in  
          let c  = CNum.define real imag in 
          let iter_count, mandelbrot_set = 
            Mandelbrot.in_mandelbrot CNum.zero c max_step in
          if mandelbrot_set then 
            begin
              G.set_color (G.rgb 0 0 0); 
              G.plot xpixel ypixel;
              ypixel_plot (succ ypixel)
            end
          else if color && not mandelbrot_set then 
            begin 
              let color_function (growth : float) = 
                (growth *. (float iter_count) /. (float max_step))
                |> Stdlib.exp 
                |> (-.) 1.
                |> ( *. ) 255. 
                |> int_of_float in 
              let colg = color_function (-.2.) in  
              let colb = color_function (-.0.8) in 
              let point_color = G.rgb 160 colg colb in 
              G.set_color point_color; 
              G.plot xpixel ypixel;
              ypixel_plot (succ ypixel)
            end
          else
            ypixel_plot (succ ypixel)
      in 
      ypixel_plot 0;
      xpixel_plot (succ xpixel)
    else ()
  in 
  xpixel_plot 0 ;;   




