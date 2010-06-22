#!/usr/bin/env zsh
# encoding: utf-8
# gvim.zsh

function gvim() {
  local _args
  _args="${@}"
  
  open -a /Applications/MacVim.app "${@}"
}

