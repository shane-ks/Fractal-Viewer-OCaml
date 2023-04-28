(*
                    CS51 Final Project
                      Shane Kissinger
 *)

(* Description: This file creates and implements a recursion for the function 
   f(z) = z^2 + c for complex values c, evaluated at z = 0. This code 
   determines which points are in the Mandelbrot set and which are not *)

open ComplexNum ;; 
open Config ;; 

module type ELEMENTS = 
  sig 

  type t = CNum.t

  val threshold : float 

  val max_step : int 

  val iter : t -> t -> t 

  end ;; 

module type MANDELBROT = 
  sig 

  type t = CNum.t

  val max_step : int 

  val threshold : float 

  val mandelbrot : t -> t -> t

  val re_f : t -> t -> float 

  val im_f : t -> t -> float 

  val in_mandelbrot : t -> t -> int * bool 
  
  end ;; 

module MakeMandelbrot (Elements : ELEMENTS) 
  : (MANDELBROT) = 
  struct 

  type t  = CNum.t

  let max_step = Elements.max_step

  let threshold = Elements.threshold

  let mandelbrot = Elements.iter 

  let re_f z1 z2= 
    let open CNum in 
    (real (add (mandelbrot z1 z2) (conj (mandelbrot z1 z2)))) /. 2. 

  let im_f z1 z2 = 
    let open CNum in 
    let two_i = define 0. 2. in 
    let imaginary = 
      mul ((sub (mandelbrot z1 z2) (conj (mandelbrot z1 z2)))) (inv two_i) in 
    imag imaginary

  let in_mandelbrot z c : int * bool = 
    let rec iter_mult z1 count = 
      let magnitude = CNum.magn z1 in 
      if magnitude > threshold then (count, false)
      else if count = max_step then (count, true) 
      else 
       iter_mult (mandelbrot z1 c) (succ count)
    in
    iter_mult z 0
  
  end ;; 

module Mandelbrot = MakeMandelbrot (struct 
                                    type t = CNum.t
                                    let max_step = Config.max_step 
                                    let threshold = Config.threshold
                                    let iter = Config.define_fractal 
                                    end ) ;;