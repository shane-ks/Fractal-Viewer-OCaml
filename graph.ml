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
(*
let grid = [|
  [| 1;  2;  3;  4 |];
  [| 5;  6;  7;  8 |];
  [| 9; 10; 11; 12 |]
|]

let element_1_1 = grid.(0).(0) (* Access the element in the first row and first column *)

grid.(1).(2) <- 42
let init_grid_array (n : int) (m : int) (init_value : float) : float array array =
  Array.init n (fun _ -> Array.init m (fun _ -> init_value))
*)

(* build an NxM grid, default starting pane is x in (-4,4) and y in (-4,4) *) 

let make_grid (width : int) 
              (height : int) 
              (xmin, xmax : float * float) 
              (ymin, ymax : float * float) : (float * float) array array = 
  let xdigit = (xmax -. xmin) /. (float_of_int width) in 
  let ydigit = (ymax -. ymin) /. (float_of_int height) in 
    Array.init width (fun i -> 
      (Array.init height (fun j -> 
        (xmin +. (float_of_int i) *. xdigit, 
         ymin +. (float_of_int j) *. ydigit )))) ;; 

let coord_to_pixel x y =
  let x_pixel = int_of_float (float width *. (x -. xmin) /. (xmax -. xmin)) in
  let y_pixel = int_of_float (float height *. (y -. ymin) /. (ymax -. ymin)) in
  (x_pixel, height - y_pixel) ;; 

(* let depict_graph = 
  Graphics.open_graph ""; 
  Graphics.resize_window width height;
  Graphics.set_window_title "Mandlebrot Set Viewer";
  let grid = make_grid width height (xmin, xmax) (ymin, ymax) in 
  for i = 0 to (width - 1) do
    for j  = 0 to (height - 1) do 
      let x, y = grid.(i).(j) in 
      let c = CNum.define x y in 
      let x_pixel, y_pixel = coord_to_pixel x y in 
      if Mandelbrot.in_mandelbrot CNum.zero c then 
        begin
          Graphics.set_color Graphics.black; 
          Graphics.plot x_pixel y_pixel;
        end 
    done
  done;
  ignore (Graphics.read_key ()); (* Wait for a key press *)
  Graphics.close_graph () ;;   *)
          

  (* instead of going from coord to pixels, I should try and go from pixels
     to coordinates. *)
 (* this implementation fixes the white lines and is overall a nicer pic *)     
let depict_graph = 
  Graphics.open_graph ""; 
  Graphics.resize_window width height;
  Graphics.set_window_title "Mandlebrot Set Viewer";
  let delta_x, delta_y = 
    (xmax -. xmin) /. float width, (ymax -. ymin) /. float height in 
  for xpixel = 0 to (width - 1) do
    for ypixel  = 0 to (height - 1) do 
      let real = delta_x *. float xpixel +. xmin in 
      let imag = delta_y *. float ypixel +. ymin in 
      let c  = CNum.define real imag in 
      if Mandelbrot.in_mandelbrot CNum.zero c then 
        begin
          Graphics.set_color Graphics.black; 
          Graphics.plot xpixel ypixel;
        end
    done
  done;
  ignore (Graphics.read_key ()); (* Wait for a key press *)
  Graphics.close_graph () ;; 


let () = 
  depict_graph ;; 