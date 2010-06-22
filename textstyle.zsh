#/bin/zsh
# Terminal text formatting styles

bbold() {
    BBOLD='\E[1m\E[7m'
    NOBBOLD='\E[m\017m'
    print "${BBOLD}${@}${NOBBOLD}"
}

revbold() {
    RBOLD='\E[1m\E[7m'
    NORBOLD='\E[m\017m'
    print "${RBOLD}${@}${NORBOLD}"
}

bold() {
    BOLD='\E[1m'
    NOBOLD='\E[m\017'
    print "${BOLD}${@}${NOBOLD}"
}


