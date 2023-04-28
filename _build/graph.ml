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
open Cairo ;;  
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

(* let make_grid (width : int) 
              (height : int) 
              (xmin, xmax : float * float) 
              (ymin, ymax : float * float) : (float * float) array array = 
  let xdigit = (xmax -. xmin) /. (float_of_int width) in 
  let ydigit = (ymax -. ymin) /. (float_of_int height) in 
    Array.init width (fun i -> 
      (Array.init height (fun j -> 
        (xmin +. (float_of_int i) *. xdigit, 
         ymin +. (float_of_int j) *. ydigit )))) ;;  *)


let initialize_image (rows : int) (col : int) : int array array = 
    Array.init rows (fun i -> 
      (Array.init col (fun j -> 0))) ;; 

  (* instead of going from coord to pixels, I should try and go from pixels
     to coordinates. *)
 (* this implementation fixes the white lines and is overall a nicer pic *)     

(* let fractal_image image width height = 
  let delta_x, delta_y = 
    (xmax -. xmin) /. float height, (ymax -. ymin) /. float width in 
  for row_pixel = 0 to (height - 1) do
    let imag = delta_y *. float row_pixel +. ymin in 
    for col_pixel  = 0 to (width - 1) do 
      let real = delta_x *. float col_pixel +. xmin in
      let c  = CNum.define real imag in 
      let iter_count, mandelbrot_set = Mandelbrot.in_mandelbrot CNum.zero c in
      if mandelbrot_set then 
          image.(row_pixel).(col_pixel) <- Graphics.rgb 0 0 0
      else if color && not mandelbrot_set then 
        let col = int_of_float (255. *. (1. -. ((float iter_count) /. (float max_step)))) in 
        image.(row_pixel).(col_pixel) <- Graphics.rgb col col col ;
    done
 done ;; *)

(*
the problem is is that the points 
pixel (0,0) <-> image.(rows - 1).(0)   
pixel (1,0) <-> image.(rows - 1).(0)  
(ymax,0) <-> image.(rows - 1).(0)   
*)
(* 
 let fractal_image image rows cols = 
  let delta_x, delta_y = 
  (xmax -. xmin) /. float cols, (ymax -. ymin) /. float rows in 
  for row_pixel = 0 downto (rows - 1) do
    let imag = delta_y *. float row_pixel +. ymin in 
    for col_pixel  = 0 to (cols - 1) do
      let real = delta_x *. float col_pixel +. xmin in
      let c  = CNum.define real imag in 
      let iter_count, mandelbrot_set = Mandelbrot.in_mandelbrot CNum.zero c in
      if mandelbrot_set then 
          image.(row_pixel).(col_pixel) <- Graphics.rgb 0 0 0
      else if color && not mandelbrot_set then 
        let col = int_of_float (255. *. (1. -. ((float iter_count) /. (float max_step)))) in 
        image.(row_pixel).(col_pixel) <- Graphics.rgb col col col ;
    done
  done ;;  *)


let depict_graph = 
  Graphics.open_graph ""; 
  Graphics.resize_window width height;
  Graphics.set_window_title "Mandlebrot Set Viewer";
  let delta_x, delta_y = 
    (xmax -. xmin) /. float width, (ymax -. ymin) /. float height in 
  for xpixel = 0 to (width - 1) do
    let real = delta_x *. float xpixel +. xmin in
    for ypixel  = 0 to (height - 1) do  
      let imag = delta_y *. float ypixel +. ymin in  
      let c  = CNum.define real imag in 
      let iter_count, mandelbrot_set = Mandelbrot.in_mandelbrot CNum.zero c in
          if mandelbrot_set then 
            begin
              Graphics.set_color Graphics.black; 
              Graphics.plot xpixel ypixel;
            end
          else if color && not mandelbrot_set then 
            let colg = int_of_float (255. *. (1. -. Stdlib.exp (-.2. *. (float iter_count) /. (float max_step))) ) in 
            let colb = int_of_float (255. *. (1. -. Stdlib.exp (-.0.5 *. (float iter_count) /. (float max_step))) ) in 
            let point_color = Graphics.rgb 160 colg colb in 
            Graphics.set_color point_color;
            Graphics.plot xpixel ypixel;
    done
  done;
  ignore (Graphics.read_key ()); (* Wait for a key press *)
  Graphics.close_graph () ;; 



(* instead of changing the pixel one by one, I think it might be faster to 
   calculate a color matrix and then use Graphics. A color in Graphics has an integer 
   value which holds actually 3 values in hex between 0 and 255. The rgb function
   takes int -> int -> color. So can use that.  *)
let () = 
  depict_graph ;; 