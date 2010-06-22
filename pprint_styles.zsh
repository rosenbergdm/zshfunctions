# Some sample styles I use for my scripts

# Default "pprint" style
zstyle ":pprint:*" attr none
zstyle ":pprint:*" fgcolor default
zstyle ":pprint:*" bgcolor default
zstyle ":pprint:*" pad none
zstyle ":pprint:*" width ""
zstyle ":pprint:*" prestr ""
zstyle ":pprint:*" posstr ""
zstyle ":pprint:*" fillchar ""
zstyle ":pprint:*" newline yes
zstyle ":pprint:*" rawmode no

# "pprint" style for saying things catching attention
zstyle ":pprint:say:*" attr bold
zstyle ":pprint:say:*" fgcolor yellow

# "pprint" style for warnings
zstyle ":pprint:warning:*" fgcolor yellow
zstyle ":pprint:warning:*" prestr "* "

# "pprint" style for errors
zstyle ":pprint:error:*" attr bold
zstyle ":pprint:error:*" fgcolor red
zstyle ":pprint:error:*" prestr "*** "

# "pprint" style for debug strings
zstyle ":pprint:debug:*" prestr "! "
zstyle ":pprint:debug:*" fgcolor cyan
zstyle ":pprint:debug:*" newline yes
zstyle ":pprint:debug:*" rawmode yes

# "pprint" style for about-to-begin actions
zstyle ":pprint:action:*" attr bold
zstyle ":pprint:action:*" fgcolor blue
zstyle ":pprint:action:*" pad right
zstyle ":pprint:action:*" width '$COLUMNS-${#:-"[*]"}'
zstyle ":pprint:action:*" posstr "  "
zstyle ":pprint:action:*" newline no

# "pprint" style for status markers
zstyle ":pprint:status:*" prestr "[*]"
zstyle ":pprint:status:*" attr bold
zstyle ":pprint:status:success:*" fgcolor green
zstyle ":pprint:status:ignored:*" fgcolor black
zstyle ":pprint:status:failure:*" fgcolor red

alias action='true; pprint "action"'
alias success='pprint "success"; true'
alias failure='pprint "failure"; false'
