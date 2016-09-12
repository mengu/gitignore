open Core.Std
open ANSITerminal

let present_options options =
  printf [Bold; red; on_default]
    "I have guessed the following .gitignore files based on your extensions.\n\n";
  List.iteri options ~f:(fun idx guess ->
      printf [Bold; blue; on_default] "[%d]: %s\n" idx guess);
  printf [Bold; red; on_default] "\nPlease enter an index: ";
  let opt = read_int () in
  List.nth options opt
