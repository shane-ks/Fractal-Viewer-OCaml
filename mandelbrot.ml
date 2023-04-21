(*
                    CS51 Final Project
                      Shane Kissinger
 *)

(* Description: This file creates and implements a recursion for the function 
   f(z) = z^2 + c for complex values c, evaluated at z = 0. This code 
   determines which points are in the Mandelbrot set and which are not *)

   (* could perhaps take re(f) = (f + bar(f)) / 2 and im(f) = (f - bar(f)) / 2i
      for generalized f *)

open ComplexNum ;; 
open Config ;; 

(* ask question about CNum.t*)

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

  val in_mandelbrot : t -> t -> bool 
  
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
    let two_i = CNum.define 0. 2. in 
    let imaginary = 
      mul ((sub (mandelbrot z1 z2) (conj (mandelbrot z1 z2)))) (inv two_i) in 
    imag imaginary

  let in_mandelbrot z c : bool = 
    let open CNum in 
    let rec iter_mult z1 count = 
      if magn (mandelbrot z1 c) > threshold then false 
      else if count = 0 then true 
      else 
       iter_mult (mandelbrot z1 c) (pred count)
    in
    iter_mult z max_step 
  
  end ;; 

module Mandelbrot = MakeMandelbrot (struct 
                                    type t = CNum.t
                                    let max_step = Config.max_step 
                                    let threshold = Config.threshold
                                    let iter = Config.define_fractal 
                                    end ) ;;