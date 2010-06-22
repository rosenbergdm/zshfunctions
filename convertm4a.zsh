#!/bin/zsh

function convertm4a() {
    oldmask=$(umask | awk '{print $1}')
    umask 00

    rename -e 's/ /___/g' *
    for fname in $(ls *.m4a); do
        faad ${fname}
        flac ${fname//m4a/wav}
        lame ${fname//m4a/wav}
    done

    yes | rm *.wav

    rename -e 's/wav\.mp3/mp3/' *.mp3
    rename -e 's/___/ /g' *
    umask $oldmask
}



