(*
                    CS51 Final Project
                      Shane Kissinger
 *)

(* Description: This file configures the Mandelbrot set viewer. *)

(*
The left-most extent of the set ends with the spike at x = -2, and the right 
side extends out to approximately x = 0.47. The top and bottom are at 
approximately y = ± 1.12, respectively.
*)
open ComplexNum ;; 

(* sets the width and height of the window *)
let width = 1200 ;;
let height = 800 ;; 
(* sets the minimum and maximum real value to compute *)
let xmin = -.2.05 ;;
let xmax = 0.6 ;;
(* sets the minimum and maximum imaginary value to compute *)
let ymin = -.1.14 ;;
let ymax = 1.14 ;;
let color = true ;; 
(* sets the max number of iterations of the fractal equation. Increasing the 
   max number of iterations makes it slower but gives a better picture. *)
let max_step = 25;; 
(* sets the threshold to stop iterating. Keep as default of 2.1 for z^2 + c*)
let threshold = 2.1 ;;
(* define the fractal equation below *)
let define_fractal z c = 
  CNum.add (CNum.mul z z) c ;; 

(*
Alternative fractals to view. Note that the x and y ranges will need to be 
changed. 

f(z) = z^3 + c: 
let define_fractal z c = 
  CNum.add (CNum.mul z (CNum.mul z z)) c ;; 

f(z) = z^4 + c: 
let define_fractal z c = 
  CNum.add (CNum.mul (CNum z (CNum.mul z z)) z) c ;;  

f(z) = z^5 + c: 
let define_fractal z c = 
  CNum.add (CNum.mul (CNum.mul (CNum z (CNum.mul z z)) z) z) c ;;  
*)  
