#!/bin/zsh
#
# select_alternatives.zsh

SYMLINKBASE=/xbin
ESYMLINKDIR=/xbin/bin
LSYMLINKDIR=/xbin/lib
ISYMLINKDIR=/xbin/include

. ~/colorize.zsh

get_current_selection() {
    selection_name="$1";
    selection_type=${2:-bin}
    selection_target=$(ls -l "${SYMLINKBASE}/${selection_type}/${selection_name}" 2> /dev/null | awk '{print $11}')
    if [[ -z $selection_target ]]; then
        return $(error_exit "Invalid selection category.")
    else
        print "The current active selection for ${YELLOW}${selection_name}${RESET} is ${YELLOW}${selection_target}${RESET}"
    fi
    return 0
}

print_usage() {
    print "Usage message"
}

error_exit() {
    emsg="$1"
    ecode=${2:-1}
    print "${RED}***Error: ***${RESET}\n${ORANGE}${emsg}${RESET}" > /dev/stderr
    return $ecode
}

get_alternatives() {
    if [[ -z $1 || "$1" == "--list" || "$1" == "--help" ]]; then
        alt_categories=($(ls $SYMLINKBASE/*.alt_def | perl -pi -e 's/(.*)\/(.*)\.alt_def/$2/g'))
        print_usage
        print "The following categories are available:\n\t${ORANGE}$(echo "${alt_categories}" | perl -pi -e 's/ /\n\t/g')${RESET}\n\n"
        return 0
    fi
    
    alt_choice="$1"
    alt_def_file="${SYMLINKBASE}/${alt_choice}.alt_def"
    if [[ -z ${alt_def_file} ]]; then
        return $(error_exit "Invalid selection category.")
    else
        alt_def=$(cat ${alt_def_file} | perl -pi -e 's/\\\n/ /g')
    fi

    choices=($(echo "$alt_def" | grep ALTERNATIVE | awk '{print $3}'))
    bin_files=($(echo "$alt_def" | grep -n binary_files | head -n 1 | perl -pi -e 's/.*\((.*)\)/$1/; s/[ \t]+/ /g')) 
    current_selection=$(echo "$alt_def" | egrep "ALTERNATIVE\*" | awk '{print $3}')
    print "The ${ORANGE}${alt_choice}${RESET} category contains the following alternatives:\n\t${GREEN}$(echo "${choices}" | perl -pi -e 's/ /\n\t/g')${RESET}\n"
    print "Currently, ${YELLOW}${current_selection}${RESET} is active."
    print "The following binary files are contained in this category:\n\t${CYAN}$(echo "${bin_files}" | perl -pi -e 's/ /\n\t/g')${RESET}\n"
    return 0
}

warningMessage() {
    emsg="$@"
    print "${RED}Warning: ${RESET}\n${emsg}" > /dev/stderr
}
    

set_alternative() {
    alt_choice="$1"
    alt_selection="$2"
    alt_def_file="${SYMLINKBASE}/${alt_choice}.alt_def"
    if [[ -z ${alt_def_file} ]]; then
        return $(error_exit "Invalid selection category.")
    else
        alt_def=$(cat ${alt_def_file} | perl -pi -e 's/\\\n/ /g')
    fi

    startLine=$(echo $alt_def | grep -n --perl-regexp "ALTERNATIVE\*? = ${alt_selection}" | awk -F ":" '{print $1}')
    if [[ -z ${startLine} ]]; then 
        return $(error_exit "Invalid selection choice.")
    fi
    totLines=$(echo $alt_def | wc -l | awk '{print $1}')
    alt_def=$(echo $alt_def | tail -n $((totLines-startLine+1)))

    include_files=($(echo "$alt_def" | grep -n include_files | head -n 1 | perl -pi -e 's/.*\((.*)\)/$1/; s/[ \t]+/ /g'))
    include_dirs=($(echo "$alt_def" | grep -n include_location | head -n 1 | perl -pi -e 's/.*\((.*)\)/$1/; s/[ \t]+/ /g'))
    lib_files=($(echo "$alt_def" | grep -n lib_files | head -n 1 | perl -pi -e 's/.*\((.*)\)/$1/; s/[ \t]+/ /g'))
    lib_dirs=($(echo "$alt_def" | grep -n lib_location | head -n 1 | perl -pi -e 's/.*\((.*)\)/$1/; s/[ \t]+/ /g'))
    bin_files=($(echo "$alt_def" | grep -n binary_files | head -n 1 | perl -pi -e 's/.*\((.*)\)/$1/; s/[ \t]+/ /g'))
    bin_dirs=($(echo "$alt_def" | grep -n binary_location | head -n 1 | perl -pi -e 's/.*\((.*)\)/$1/; s/[ \t]+/ /g'))
    dot_files=($(echo "$alt_def" | grep -n dotfiles_dirs | head -n 1 | perl -pi -e 's/.*\((.*)\)/$1/; s/[ \t]+/ /g'))
    
    for fname in $bin_files; do
        if [[ -a ${ESYMLINKDIR}/${fname} ]]; then
            rm ${ESYMLINKDIR}/${fname}
        fi;
        for dname in $bin_dirs; do
            if [[ -x ${dname}/${fname} ]]; then
                ln -s ${dname}/${fname} ${ESYMLINKDIR}/${fname}
            fi
        done 
        if ! [[ -x ${ESYMLINKDIR}/${fname} ]]; then
            warningMessage "No targets for ${fname} could be found, continuing."
        fi
    done
    
    for fname in $include_files; do
        if [[ -a ${ISYMLINKDIR}/${name} ]]; then
            rm ${ISYMLINKDIR}/${fname}
        fi;
        for dname in $include_dirs; do
            if [[ -a ${dname}/${fname} ]]; then
                ln -s ${dname}/${fname} ${ISYMLINKDIR}/${fname}
            fi
        done
        if ! [[ -a ${ISYMLINKDIR}/${fname} ]]; then
            warningMessage "No targets for ${fname} could be found, continuing."
        fi
    done

    for fname in $lib_files; do
        if [[ -a ${LSYMLINKDIR}/${name} ]]; then
            rm ${LSYMLINKDIR}/${fname}
        fi;
        for dname in $lib_dirs; do
            if [[ -a ${dname}/${fname} ]]; then
                ln -s ${dname}/${fname} ${LSYMLINKDIR}/${fname}
            fi
        done
        if ! [[ -a ${LSYMLINKDIR}/${fname} ]]; then
            warningMessage "No targets for ${fname} could be found, continuing."
        fi
    done

    perl -pi -e 's/ALTERNATIVE\*/ALTERNATIVE/g' $alt_def_file
    perl -pi -e "s/ALTERNATIVE = ${alt_selection}/ALTERNATIVE\* = ${alt_selection}/" $alt_def_file

    for _usr in $(users); do
        for dfname in $dot_files; do
            if [[ -L ~${_usr}/${dfname} ]]; then
                if [[ -a ~${_usr}/${dfname}.${alt_selection} ]]; then
                    rm ~${_usr}/${dfname}
                    ln -s ~${_usr}/${dfname}.${alt_selection} ~${_usr}/${dfname}
                else
                    warningMessage "No hard targets could be found for dotfile symlink ${dfname} for user ${_usr}"
                fi
            else
                warningMessage "Target ${dfname} for ${_usr} is not a symlink.  Skipping."
            fi
        done
    done

    version_number=$(echo "$alt_def" | grep version_number | head -n 1 | awk '{print $3}') 
    architecture=$(echo "$alt_def" | grep architecture | head -n 1 | awk '{print $3}')

    print "Selection change successful.  ${YELLOW}${alt_choice} version ${version_number} (${alt_selection}, ${architecture})${RESET} has been activated."
}


