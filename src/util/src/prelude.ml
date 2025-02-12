(* Copyright 2008 Martin Korp, Christian Sternagel, Harald Zankl
 * GNU Lesser General Public License
 *
 * This file is part of CTRL (and originates in TTT2).
 * 
 * CTRL is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or (at your
 * option) any later version.
 * 
 * CTRL is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
 * License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with CTRL. If not, see <http://www.gnu.org/licenses/>.
 *)

(*** TYPES ********************************************************************)
type ('a,'b) either = Left of 'a | Right of 'b;;

(*** FUNCTIONS ****************************************************************)
(* reverse application for 'waterfall notation' *)
let (|>) x f = f x

let (<.>) f g x = f (g x);;
let (<?>) f s i = try f i with Failure _ -> failwith s;;
let catch e f d i = try f i with ex -> if ex = e then d else raise ex;;
let throw e f p i = let r = f i in if p r then raise e else r;;
let id x = x;;

let rec fix ?(eq = (=)) f x =
 let y = f x in if eq x y then x else fix f y
;;

(* Input Transformations *)
let const x _ = x;;
let curry f x y = f (x,y);;
let curry3 f x y z = f (x,y,z);;
let drop f x _ = f x;;
let flip f x y = f y x;;
let nop f x = f x;;
let swap x f = f x;;

let read_channel ?(buff_size = 1024*1024) ch =
  let size = 4*1024 in
  let loop = ref true in
  let buff = Bytes.create size in
  let res  = Buffer.create buff_size in
  while !loop do
    let n = input ch buff 0 size in
    if n = 0 then loop := false
             else Buffer.add_subbytes res buff 0 n
  done;
  Buffer.contents res
;;

let read_file file =
  let ch = open_in file in
  let s  = read_channel ~buff_size:(in_channel_length ch) ch in
  close_in ch;
  s
;;
  
(* Debugging *)
let debug = ref false;;

let set_debugging value = debug := value;;
let query_debugging () = !debug;;

