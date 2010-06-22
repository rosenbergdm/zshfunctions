#!/bin/zsh

man2pdf() {
    current_umask=$(umask | awk '{print $1}')
    umask 00
    if [[ -z "$2" ]]; then
        mpage=$1;
        msect=1;
    else
        mpage=$2;
        msect=$1;
    fi

    $(whence -p man | head -n 1) -t $msect $mpage | ps2pdf - - > ${mpage}.pdf
    print "Output written to \\033\[91m${mpage}.pdf\\033\[00m."
    umask ${current_umask}
}
