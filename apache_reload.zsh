#!/usr/bin/env zsh
# encoding=UTF-8

#===============================================================================
#
#         FILE:  /var/root/src/zshfunctions/apache_reload.zsh
#
#        USAGE:  apache_reload 
#
#  DESCRIPTION:  Resets the WSGI apache module and reloads apache.
#
#      OPTIONS:  None
# REQUIREMENTS:  None
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  David M. Rosenberg <rosenbergdm@uchicago.edu>
#      COMPANY:  University of Chicago
#      VERSION:  1.0
#      CREATED:  05/13/10
#     REVISION:  1
#===============================================================================

apache_reload() {
    local cur_status response wsgifiles ctlscript
    ctlscript="/opt/local/apache2/bin/apachectl"
    if ! [[ -a "/opt/local/apache2/logs/httpd.pid" ]]; then
        pprint error "Apache is not currently running.  Aborting.\n"
        return 127
    fi
    wsgifiles=($(ls /var/www/wsgi/scripts/*.wsgi))
    for fname in $wsgifiles; do
        touch $fname
        pprint action "Resetting WSGI scrip ${fname}.\n"
    done

    response=$($ctlscript restart)

    if ! [[ -z "$response" ]]; then
        pprint error "Error reload apache configuration.\n${response}"
        return 127
    else
        pprint status:success "Apache and mod_wsgi adapter reloaded.\n"
    fi

    return 0
}

# vim: ft=zsh encoding=utf8 shiftwidth=4 softtabstop=4 expandtab
