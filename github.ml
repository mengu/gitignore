open Lwt
open Cohttp
open Cohttp_lwt_unix

let base_repo_url = "https://raw.githubusercontent.com/github/gitignore/master/"

let get_ignore_file ignore_file =
  let base_uri = base_repo_url ^ ignore_file in
  Client.get (Uri.of_string base_uri) >>= fun (resp, body) ->
  body |> Cohttp_lwt_body.to_string
