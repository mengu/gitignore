open Core
open Lwt
open Lwt_io
open Cohttp
open Cohttp_lwt_unix


(* @TODO: ask to concatenate the options into one gitignore file *)

let cwd             = Sys.getcwd ()
let parent_dir_name = Filename.basename (Filename.dirname cwd)
let gitignore_path  = Filename.concat cwd ".gitignore"

let backup_old_gitignore () =
  match Sys.file_exists gitignore_path with
  | `Yes -> Sys.rename gitignore_path (gitignore_path ^ "_old")
  | _ -> ()

let download_ignore_file igf =
  let contents = Lwt_main.run (Github.get_ignore_file igf) in
  backup_old_gitignore ();
  Out_channel.write_all gitignore_path ~data:contents;
  Printf.printf "The ignore file %s is written to .gitignore" igf

let guess_from_parent_dir ignore_files =
  let pred fn =
    String.lowercase fn = parent_dir_name ^ ".gitignore"
  in
  List.find ~f:pred ignore_files

let match_from_extension exts ext =
  List.filter ~f:(fun elm -> List.mem (snd elm) ext) exts

let get_all_cur_dir_files () =
  let read_dir dir =
    Array.to_list (Sys.readdir dir)
    |> List.filter ~f:(fun dn -> not (String.is_prefix dn ~prefix:"."))
  in
  let rec aux(files, acc) =
    match files with
    | [] -> acc
    | f::files' -> match Sys.is_directory f with
                   | `Yes -> aux(files', (read_dir f)::acc)
                   | _ -> aux(files', [f]::acc)
  in
  aux(read_dir cwd, [])
  |> List.concat
  |> List.dedup

let guess_from_exts exts =
  let dir_contents = get_all_cur_dir_files ()
  and split_file_name fn =
    List.last_exn (String.split ~on:'.' fn)
  and only_exts fn =
    String.length fn >= 1
  and is_not_unwanted_file fn =
    not (String.is_prefix fn ~prefix:"." ||
         String.contains fn '~' ||
         String.contains fn '#')
  in
  dir_contents
  |> List.filter ~f:is_not_unwanted_file
  |> List.map ~f:split_file_name
  |> List.filter ~f:only_exts
  |> List.dedup
  |> List.map ~f:(match_from_extension exts)
  |> List.concat
  |> List.map ~f:(fun guess -> (fst guess))

let guess_from_args = function
  | [] | [_] -> None
  | prognam::igf::_ -> Some (igf ^ ".gitignore")

let () =
  let args = Array.to_list Sys.argv in
  match guess_from_args args with
  | None ->
     begin
       match guess_from_parent_dir Ignore_files.ignore_files with
       | None ->
          begin
            let guesses = guess_from_exts Ignore_files.extensions in
            if List.length guesses = 0 then
              print_endline "Sorry, could not guess any .gitignore files."
            else
              match Present.present_options guesses with
              | None ->
                 print_endline "Sorry, could not guess any .gitignore files."
              | Some igf ->
                 download_ignore_file igf
          end
       | Some igf ->
          download_ignore_file igf
     end
  | Some ignore_file ->
     download_ignore_file ignore_file
