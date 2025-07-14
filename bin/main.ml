open List

type symbol = M | I | U

let error s =
  raise (Failure s)

let char_of_symbol s =
  match s with
  | M -> 'M'
  | I -> 'I'
  | U -> 'U'

let symbol_of_char c =
  match c with
  | 'M' -> M
  | 'I' -> I
  | 'U' -> U

let chars_of_string s =
  List.of_seq (String.to_seq s)

let string_of_chars cs =
  String.of_seq (List.to_seq cs)

let symbols_of_string s =
  map symbol_of_char (chars_of_string s)

let string_of_symbols ss =
  string_of_chars (map char_of_symbol ss)

(* xI => xU *)
let r1 cs =
  assert (not (is_empty cs));
  match rev cs with
  | [] -> error "shouldnt be empty"
  | I::cs -> [rev (U::I::cs)]
  | c::cs -> []

(* Mx => Mxx *)
let r2 cs =
  assert (not (is_empty cs));
  match cs with
  | [] -> error "shouldnt be empty"
  | M::cs -> [M::(cs @ cs)]
  | c::cs -> []

(* xIIIy -> xUy *)
let rec r3 cs =
  assert (not (is_empty cs));
  match cs with
  | [] -> error "should never happen"
  | _::[] -> []
  | _::_::[] -> []
  | I::I::I::cs -> begin
      let cs' = U::cs in
      let css = (map (fun cs' -> I::cs') (r3 (I::I::cs))) in
      cs'::css
      end
  | c::cs -> map (fun cs' -> c::cs') (r3 cs)

(* xUUUy -> xUy *)
let rec r4 (cs:symbol list) : symbol list list =
  assert (not (is_empty cs));
  match cs with
  | [] -> error "huh"
  | _::[] -> []
  | _::_::[] -> []
  | U::U::U::cs -> begin
      let cs' = U::cs in
      let css = (map (fun cs' -> U::cs') (r4 (U::U::cs))) in
      cs'::css
      end
  | c::cs -> map (fun cs' -> c::cs') (r4 cs)

let rs = [r1; r2; r3; r4]

let infer cs : symbol list list =
  concat_map (fun f -> f cs) rs

(* TODO: when should I dedup? *)
let rec search depth cs : symbol list list =
  if depth = 0 then
    [cs]
  else
    let css = search (depth - 1) cs in
    css @ (concat_map infer css)

let () =
  let s = read_line() in
  let cs = symbols_of_string s in
  let depth = (int_of_string (Sys.argv.(1))) in
  let css = search depth cs in
  iter (fun cs -> print_endline (string_of_symbols cs)) css
