#!/bin/zsh

select_ghc() {
    typeset -A choices
    choices+=(macports MACPORTS 6.10.4 MACPORTS 6.12.1 SYSTEM 6.12.1 SYSTEM default SYSTEM)
    if $(echo ${(k)choices} | grep $1 > /dev/null); then
        GHC_SELECTION=${choices[$1]}
    else
        print "$(bold Error:) The only valid selection options are:\n\t ${(k)choices} \n"
        exit 1
    fi

    if [[ $GHC_SELECTION == "MACPORTS" ]]; then
        _binaries=(ghc-pkg ghc ghci cabal hoogle haddock)
        for _binary in $_binaries; do
            unalias $_binary > /dev/null
            alias ${_binary}=/opt/local/bin/${_binary}
        done
        rm -Rf ~/.cabal > /dev/null
        ln -s ~/.cabal.macports ~/.cabal
    elif [[ $GHC_SELECTION == "SYSTEM" ]]; then
        _binaries1=(ghc-pkg ghc ghci)
        _binaries2=(cabal hoogle haddock)
        for _binary in $_binaries1; do
            unalias $_binary > /dev/null
            alias ${_binary}=/usr/bin/${_binary}
        done
        for _binary in $_binaries2; do
            unalias $_binary > /dev/null
            alias ${_binary}=/usr/local/bin/${_binary}
        done
        rm -Rf ~/.cabal > /dev/null
        ln -s ~/.cabal.system ~/.cabal
    else
        print "$(bold Error:) An unknown error occured!\n"
        return 2
    fi
    print "$(bold $GHC_SELECTION) has been selected as the haskell system.\n"
}


