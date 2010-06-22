#!/bin/zsh
# add_missing_svn.zsh

function add_missing_svn() {
    svn status | grep \? | awk -F "       " "{print \"\\\"\" \$2 \"\\\"\"}" | xargs svn add
    svn ci -m 'Added missing files'
}

