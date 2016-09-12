# About

gitignore is a utility for you to auto insert .gitignore files depending on the project type you have.
It uses the .gitignore files from [Github's gitignore repository](https://github.com/github/gitignore).

## Building

### For macOS

* `brew install ocaml opam`
* `opam install core cohttp ansiterminal`
* `make build`

### For Linux

* `(apt-get|yum|zypper) install ocaml opam`
* `opam install core cohttp ansiterminal`
* `make build`

## Usage

* `gitignore`

* `gitignore OCaml`

* `gitignore Rails`

## How it works?

add_gitignore first tries guessing your project type if you do not provide it an argument.

* If your project directory is a subdirectory of a .gitignore file then it automatically uses it.
(ie: /Users/awesome-dev/projects/scala/akka/ will resolve your project as a Scala project.)

![Guess From Project](https://github.com/mengu/gitignore/blob/master/screenshots/parent_guess.png?raw=true)

* If your project has an extension that is supported, you will be presented an option or options to choose.
(You might have .php files but it can be a Magento project, Drupal project, etc.)

![Guess From Extensions](https://github.com/mengu/gitignore/blob/master/screenshots/extension_guess.png?raw=true)
