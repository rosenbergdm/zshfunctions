#!/usr/bin/env zsh
# encoding: utf-8
# set_compile_flags.zsh

function set_compile_flags() {
    function __usage() {
        pprint message "\nUsage: set_compile_flags [COMPILER] [ARCHS]"
        pprint message "\n\tCOMPILER\n\t\tgcc*|clang\t\tPreferred compiler"
        pprint message "\n\tARCHS\n\t\tx86_64*|i386|ppc\tTarget architecture, multiple architectures"
        pprint message "\t\t\t\t\t\tmay be comma-separated."
    }
    
    function __clearflags() {
        unset CC CXX CPP GCC cc CFLAGS CCFLAGS CXXFLAGS CPPFLAGS CXXCPPFLAGS
        unset LDFLAGS TRIPLE BUILD TARGET HOST F77 FC F90 F95 OBJCFLAGS
        unset OBJCXXFLAGS FFLAGS FCFLAGS LDFLAGS LIBS
    }


    if [[ ("$1" == "-help") || ("$1" == "--help") ]]; then
        __usage;
        return 1;
    fi

    if [[ "$1" == "clang" ]]; then
        pprint message "Compile settings are set for \E[1mCLANG (x86_64)\E[m\017."
        __clearflags;

        CC=/usr/local/bin/clang
        CPP=$CC\ -E
        CXX=${CC}++
        CXXCPP=${CXX}\ -E
        
        _compflag="-g -O3 -march=core2 -msse2"
        _ppflag="-I/usr/include -I/usr/local/include"
        _ldflags="-L/usr/lib -L/usr/local/lib"
        
        CFLAGS="${_compflag}"
        CCFLAGS="${_compflag}"
        CXXFLAGS="${_compflag}"
        
        CPPFLAGS="${_ppflag}"
        CXXCPPFLAGS="${_ppflag}"

        LDFLAGS="${_ldflags}"

        TRIPLE="x86_64-apple-darwin10"
        BUILD=$TRIPLE; TARGET=$TRIPLE; HOST=$TRIPLE

        export CC CPP CXX CXXCPP CFLAGS CCFLAGS CXXFLAGS CPPFLAGS 
        export CXXCPPFLAGS LDFLAGS TRIPLE BUILD TARGET HOST
        return 0;
    fi;

    if [[ "$1" == "gcc" ]]; then
        shift;
    fi;

    _archs="${1:-x86_64,i386}"
    _carchflag=""
    _parchflag=""
    for _af in i386 x86_64 ppc; do
      if (echo "${_archs}" | grep ${_af} > /dev/null); then
        _carchflag="${_carchflag} -arch ${_af}"
        print "Flags for ${_af} were added."
      else
        print "Flags for ${_af} were \E[1mnot\E[m\017 added."
      fi
    done
    

    
    if (echo "${_archs}" | grep 386 > /dev/null); then
        _parchflag="${_parchflag} -m32"
    fi
    if (echo "${_archs}" | grep 64 > /dev/null); then
        _parchflag="${_parchflag} -m64"
    fi

    TRIPLE="x86_64-apple-darwin10"
    export BUILD=$TRIPLE TARGET=$TRIPLE HOST=$TRIPLE


    CFLAGS="${_carchflag} ${_parchflag} -g -Os -pipe"
    CXXFLAGS="${_carchflag} ${_parchflag} -g -Os -pipe"
    CCFLAGS="${_carchflag} ${_parchflag} -g -Os -pipe"
    OBJCFLAGS="${_carchflag} ${_parchflag} -g -Os -pipe"
    OBJCXXFLAGS="${_carchflag} ${_parchflag} -g -Os -pipe"
    FCFLAGS="${_carchflag} ${_parchflag} -g -Os -pipe"

    FFLAGS="${_carchflag} ${_parchflag} -g -Os"
    CPPFLAGS="-I/usr/include -I/usr/local/include -I/Developer/usr/include -I/opt/local/include"
    CXXCPPFLAGS=$CPPFLAGS
    LDFLAGS="${_carchflag}${_parchflag} -L/usr/lib -L/usr/local/lib -L/Developer/usr/lib -L/opt/local/lib"
    CC=/usr/bin/gcc
    CXX=/usr/bin/g++
    F77=/usr/bin/gfortran
    CPP=$CC\ -E
    CXXCPP=$CXX\ -E
    cc=$CC
    GCC=$CC
    F90=$F77
    F95=$F77
    FC=$F77
    export CC CXX F77 CPP CXXCPP cc GCC F90 F95 FC
    export CFLAGS CXXFLAGS CCFLAGS OBJCFLAGS OBJCXXFLAGS FCFLAGS CPPFLAGS CXXCPPFLAGS LDFLAGS
}


