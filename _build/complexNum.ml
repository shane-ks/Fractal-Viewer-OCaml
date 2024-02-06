(*
                    CS51 Final Project
                      Shane Kissinger
 *)

(* Description: This file creates and implements a way to manipluate complex 
   numbers in OCaml.*)

   module type CNUM = 
   sig
 
   type t 
 
   val define : float -> float -> t 
 
   val zero : t 
 
   val i : t 
 
   val one : t 
   
   val add : t -> t -> t
 
   val sub : t -> t -> t
 
   val mul : t -> t -> t 
 
   val conj : t -> t 
 
   val magn : t -> float 
 
   val inv : t -> t 

   val real : t -> float 

   val imag : t -> float 
 
   end ;; 
   
 module CNum : CNUM = 
   struct
 (* re and im are the real and imaginary values *)
   type t = { re : float ; im : float }
 
   let define n1 n2 = {re = n1 ; im = n2 }
   let zero = {re = 0. ; im = 0. }
 
   let i = {re = 0. ; im = 1. }
 
   let one = {re = 1. ; im = 0. }
 
   let pointwise_op f z1 z2 = 
     let re1, im1  = z1.re, z1.im in 
     let re2, im2  = z2.re, z2.im in 
     { re = f re1 re2 ; im = f im1 im2 }
 
   let add z1 z2 = pointwise_op (+.) z1 z2 
 
   let sub z1 z2 = pointwise_op (-.) z1 z2 
 
   let mul z1 z2 = 
     let re1, im1  = z1.re, z1.im in 
     let re2, im2  = z2.re, z2.im in 
     { re = (re1 *. re2) -. (im1 *. im2) ; im = (re1 *. im2) +. (re2 *. im1) }
 
   let conj z = { re = z.re ; im = -. z.im }
 
   let magn z = (mul z (conj z)).re 
 
   let inv z =  { re = z.re /. (magn z) ; im = (-. z.im) /. (magn z)}

   let real z = z.re 

   let imag z = z.im 
 
 end ;; 
 