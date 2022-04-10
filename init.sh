#!/bin/sh
########################################
#
# This init script is just for me.
# If I get the new Environment (That is,  I got a new machine), I will run this first.
#
########################################

while getopts hf OPT
do
  case $OPT in
     h) FLG_h=true;;
     f) FLG_f=true;;
  esac
done

# The mac's readlink does not have capable of get full path!
DIR=`cd \`dirname ${0}\`; pwd`

help() {
cat << EOF
Usage: ./init.sh [-hf]
  -h : help
  -f : force setting
EOF
}

setup() {
  for file in `find ${DIR}/shellconfig -type f`; do
    ln -s $file ~
  done
  [[ ! -e ~/.extra_path ]] && touch ~/.extra_path
}

force_setup() {
  echo "Are you sure overwrite shell config files ? (y/n)"
  if [ -n "$ZSH_VERSION" ]; then
    read -s -k 1 c
  else
    read -s -n 1 c
  fi
  if [ "$c" != "y" ]; then
    echo "The setup was cancelled."
    exit 1
  fi
  
  for file in `find ${DIR}/shellconfig -type f`; do
    ln -sf $file ~
  done
  [[ ! -e ~/.extra_path ]] && touch ~/.extra_path
}

if [ "$FLG_h" ]; then help; exit 0; fi
if [ "$FLG_f" ]; then force_setup; exit 0; fi
setup

exit 0

