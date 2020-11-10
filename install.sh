#!/usr/bin/env bash

MGT_DIRECTORY=~/.env-installer
INSTALLER_REPO=https://github.com/jonccrawley/dev-env.git



if [ -d "$MGT_DIRECTORY" ]; then rm -Rf $MGT_DIRECTORY; fi
mkdir $MGT_DIRECTORY

# string formatters
if [[ -t 1 ]]; then
  tty_escape() { printf "\033[%sm" "$1"; }
else
  tty_escape() { :; }
fi

tty_mkbold() { tty_escape "1;$1"; }
tty_underline="$(tty_escape "4;39")"
tty_blue="$(tty_mkbold 34)"
tty_red="$(tty_mkbold 31)"
tty_bold="$(tty_mkbold 39)"
tty_reset="$(tty_escape 0)"

shell_join() {
  local arg
  printf "%s" "$1"
  shift
  for arg in "$@"; do
    printf " "
    printf "%s" "${arg// /\ }"
  done
}

chomp() {
  printf "%s" "${1/"$'\n'"/}"
}

ohai() {
  printf "${tty_blue}==>${tty_bold} %s${tty_reset}\n" "$(shell_join "$@")"
}

warn() {
  printf "${tty_red}Warning${tty_reset}: %s\n" "$(chomp "$1")"
}

abort() {
  printf "%s\n" "$1"
  exit 1
}

execute() {
  if ! "$@"; then
    abort "$(printf "Failed during: %s" "$(shell_join "$@")")"
  fi
}

##################################################################################################
# INSTALL
##################################################################################################
ohai "Downloading installer codebase..."
(
  cd $MGT_DIRECTORY >/dev/null || return
 	
  # we do it in four steps to avoid merge errors when reinstalling
  execute "git" "init" "-q"

  # "git remote add" will fail if the remote is defined in the global config
  execute "git" "config" "remote.origin.url" "${INSTALLER_REPO}"
  execute "git" "config" "remote.origin.fetch" "+refs/heads/*:refs/remotes/origin/*"

  # ensure we don't munge line endings on checkout
  execute "git" "config" "core.autocrlf" "false"

  execute "git" "fetch" "origin" "--force"
  execute "git" "fetch" "origin" "--tags" "--force"

  execute "git" "reset" "--hard" "origin/master"

  execute "make" "install"

) || exit 1
