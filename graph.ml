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
              (xbegin, xend : float * float) 
              (ybegin, yend : float * float) : (float * float) array array = 
  let xdigit = (xend -. xbegin) /. (float_of_int width) in 
  let ydigit = (yend -. ybegin) /. (float_of_int height) in 
    Array.init width (fun i -> 
      (Array.init height (fun j -> 
        (xbegin +. (float_of_int i) *. xdigit, 
         ybegin +. (float_of_int j) *. ydigit )))) ;; 

let coord_to_pixel x y =
  let x_pixel = int_of_float (float width *. (x -. xbegin) /. (xend -. xbegin)) in
  let y_pixel = int_of_float (float height *. (y -. ybegin) /. (yend -. ybegin)) in
  (x_pixel, height - y_pixel) ;; 

let depict_graph = 
  Graphics.open_graph ""; 
  Graphics.resize_window width height;
  Graphics.set_window_title "Mandlebrot Set Viewer";
  let grid = make_grid width height (xbegin, xend) (ybegin, yend) in 
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
  Graphics.close_graph () ;;  
          
      
let () = 
  depict_graph ;; 