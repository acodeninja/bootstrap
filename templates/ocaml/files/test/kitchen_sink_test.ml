module StringMap = Map.Make (String)
module StringSet = Set.Make (String)

(* collections *)

let a_list_keeps_its_order =
  Alcotest.test_case "a list keeps what you put in it, in order" `Quick (fun () ->
      let items = [ "a"; "b" ] in

      let extended = items @ [ "c" ] in

      Alcotest.(check (list string)) "the new item is last" [ "a"; "b"; "c" ] extended;
      Alcotest.(check int) "the list it was built from is untouched" 2 (List.length items);
      Alcotest.(check (option string)) "an index past the end is None" None (List.nth_opt items 5))

let a_missing_key_is_none =
  Alcotest.test_case "a lookup for a key that is not there comes back as None" `Quick (fun () ->
      let counts = StringMap.of_list [ ("a", 2); ("b", 1) ] in

      Alcotest.(check (option int)) "a key that is there" (Some 2) (StringMap.find_opt "a" counts);
      Alcotest.(check (option int)) "a key that is not" None (StringMap.find_opt "z" counts);
      Alcotest.(check int)
        "a default stands in for the absent one" 0
        (Option.value (StringMap.find_opt "z" counts) ~default:0))

let a_set_discards_duplicates =
  Alcotest.test_case "a set discards duplicates and hands its members back sorted" `Quick (fun () ->
      let letters = StringSet.of_list [ "b"; "a"; "b" ] in

      Alcotest.(check int) "the repeat was dropped" 2 (StringSet.cardinal letters);
      Alcotest.(check bool)
        "membership is a question a set answers" true (StringSet.mem "a" letters);
      Alcotest.(check (list string))
        "elements come out in order" [ "a"; "b" ] (StringSet.elements letters))

(* strings *)

let a_string_splits_and_joins =
  Alcotest.test_case "a string splits into parts and joins back up" `Quick (fun () ->
      let text = "one two three" in

      let words = String.split_on_char ' ' text in

      Alcotest.(check (list string)) "split on a space" [ "one"; "two"; "three" ] words;
      Alcotest.(check string) "joined with a dash" "one-two-three" (String.concat "-" words))

let a_substring_is_taken_by_length =
  Alcotest.test_case "a substring is taken by start and length, counting from zero" `Quick
    (fun () ->
      let text = "abcdef" in

      Alcotest.(check char) "a character is read by index" 'a' text.[0];
      Alcotest.(check string) "three characters from the start" "abc" (String.sub text 0 3);
      Alcotest.(check string) "two characters from the fifth" "ef" (String.sub text 4 2))

let text_is_built_by_formatting =
  Alcotest.test_case "text is built by formatting, because there is no interpolation" `Quick
    (fun () ->
      let name = "world" in
      let count = 2 in

      Alcotest.(check string)
        "a format string takes the values" "world x2"
        (Printf.sprintf "%s x%d" name count);
      Alcotest.(check string)
        "repeating is joining a built list" "ababab"
        (String.concat "" (List.init 3 (fun _ -> "ab")));
      Alcotest.(check string)
        "trimming drops the surrounding blanks" "padded" (String.trim "  padded  "))

(* types and branching *)

type point = { x : int; y : int }
type state = Locked | Open

let state =
  Alcotest.testable
    (fun formatter value ->
      Format.pp_print_string formatter (match value with Locked -> "Locked" | Open -> "Open"))
    ( = )

let a_record_groups_fields =
  Alcotest.test_case "a record is copied with a change rather than changed in place" `Quick
    (fun () ->
      let record = { x = 1; y = 2 } in

      let moved = { record with x = 5 } in

      Alcotest.(check int) "the copy carries the new value" 5 moved.x;
      Alcotest.(check int) "the copy keeps every other field" 2 moved.y;
      Alcotest.(check int) "the record it was copied from still holds the old value" 1 record.x)

let a_variant_must_be_matched_in_full =
  Alcotest.test_case "every case of a variant has to be handled or the code will not compile" `Quick
    (fun () ->
      let toggle value = match value with Locked -> Open | Open -> Locked in

      Alcotest.check state "locked becomes open" Open (toggle Locked);
      Alcotest.check state "open becomes locked" Locked (toggle Open))

let a_branch_hands_back_a_value =
  Alcotest.test_case "a branch is an expression, so it hands back a value" `Quick (fun () ->
      let describe n = if n < 0 then "negative" else if n = 0 then "zero" else "positive" in

      Alcotest.(check string) "below zero" "negative" (describe (-1));
      Alcotest.(check string) "at zero" "zero" (describe 0);
      Alcotest.(check string) "above zero" "positive" (describe 1))

(* iteration *)

let a_loop_reads_the_position =
  Alcotest.test_case "walking a list can read the position alongside the item" `Quick (fun () ->
      let seen = ref [] in

      List.iteri (fun index item -> seen := Printf.sprintf "%d:%s" index item :: !seen) [ "a"; "b" ];

      Alcotest.(check (list string)) "position and item together" [ "0:a"; "1:b" ] (List.rev !seen))

let a_list_is_walked_with_lookahead =
  Alcotest.test_case "a list is walked two items at a time by matching on the tail" `Quick
    (fun () ->
      let rec sums values =
        match values with
        | first :: (second :: _ as rest) -> (first + second) :: sums rest
        | _ -> []
      in

      Alcotest.(check (list int))
        "each item added to the one after it" [ 3; 5; 7 ]
        (sums [ 1; 2; 3; 4 ]);
      Alcotest.(check (list int)) "a lone item has nothing to pair with" [] (sums [ 1 ]))

(* functions *)

let a_function_is_an_ordinary_value =
  Alcotest.test_case "a function is an ordinary value and can be handed to another" `Quick
    (fun () ->
      let double n = n * 2 in

      Alcotest.(check (list int)) "handed to map" [ 2; 4; 6 ] (List.map double [ 1; 2; 3 ]);
      Alcotest.(check (list int))
        "handed to filter" [ 2; 3 ]
        (List.filter (fun n -> n > 1) [ 1; 2; 3 ]);
      Alcotest.(check (list int))
        "supplied one argument of two" [ 3; 4 ]
        (List.map (( + ) 2) [ 1; 2 ]))

let a_list_folds_to_one_value =
  Alcotest.test_case "a list folds down to a single value" `Quick (fun () ->
      let values = [ 1; 2; 3; 4 ] in

      let total = List.fold_left ( + ) 0 values in

      Alcotest.(check int) "added up from the left" 10 total;
      Alcotest.(check string)
        "folded from the right instead" "1234"
        (List.fold_right (fun n text -> string_of_int n ^ text) values ""))

(* errors *)

type error = Not_a_percentage of string

let outcome =
  Alcotest.(
    result int
      (testable
         (fun formatter (Not_a_percentage input) ->
           Format.fprintf formatter "Not_a_percentage %S" input)
         ( = )))

let a_refusal_comes_back_as_a_value =
  Alcotest.test_case "an input the function will not accept comes back as an error value" `Quick
    (fun () ->
      let parse_percentage input =
        match int_of_string_opt input with
        | Some value when value >= 0 && value <= 100 -> Ok value
        | _ -> Error (Not_a_percentage input)
      in

      Alcotest.check outcome "a percentage parses" (Ok 40) (parse_percentage "40");
      Alcotest.check outcome "text that is not a number" (Error (Not_a_percentage "half"))
        (parse_percentage "half");
      Alcotest.check outcome "a number outside the range" (Error (Not_a_percentage "140"))
        (parse_percentage "140"))

(* gotchas *)

let equal_strings_need_not_be_the_same_string =
  Alcotest.test_case "two strings can be equal without being the same string" `Quick (fun () ->
      let built = "a" ^ "b" in
      let literal = "ab" in
      let one = 1 in

      Alcotest.(check bool) "= compares the contents" true (built = literal);
      Alcotest.(check bool) "== asks whether it is the very same value" false (built == literal);
      Alcotest.(check bool) "an integer is stored inline, so == looks like =" true (one == 1))

let suite =
  [
    a_list_keeps_its_order;
    a_missing_key_is_none;
    a_set_discards_duplicates;
    a_string_splits_and_joins;
    a_substring_is_taken_by_length;
    text_is_built_by_formatting;
    a_record_groups_fields;
    a_variant_must_be_matched_in_full;
    a_branch_hands_back_a_value;
    a_loop_reads_the_position;
    a_list_is_walked_with_lookahead;
    a_function_is_an_ordinary_value;
    a_list_folds_to_one_value;
    a_refusal_comes_back_as_a_value;
    equal_strings_need_not_be_the_same_string;
  ]
