#!/bin/zsh

GREEN='\033[92m'
RED='\033[91m'
BLUE='\033[34m'
YELLOW='\033[33m'
ORANGE='\033[35m'
GREY='\033[90m'
CYAN='\033[36m'


RESET='\033[0m'

colorizeDeclarations() {
    echo "${@}" | perl -pi -e "s/(\\w*) :: (\\w*)/${CYAN}\$1 :: ${RESET}\$2/g;" 
    ## s/\\b[0-9\\.e]/${YELLOW}\$1${RESET}/g; s/(\".*\")/${YELLOW}\$1${RESET}/g"
}

colorizeLiterals() {
    echo "${@}" | perl -pi -e "s/\\b[0-9\\.e]/${YELLOW}\$1${RESET}/g; s/(\".*\")/${YELLOW}\$1${RESET}/g"
}


