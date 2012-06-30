#!/bin/sh

__esn_col_red="\033[0;31m"
__esn_col_green="\033[0;32m"
__esn_col_yellow="\033[0;33m"
__esn_col_blue="\033[0;34m"

__esn_col_lred="\033[1;31m"
__esn_col_lgreen="\033[1;32m"
__esn_col_lyellow="\033[1;33m"
__esn_col_lblue="\033[1;34m"

__esn_col_no="\033[0m"

__esn_utf8_updown_arrow="\xe2\x86\x95"
__esn_utf8_upwards_arrow="\xe2\x86\x91"
__esn_utf8_downwards_arrow="\xe2\x86\x93"

__esn_git_dirty_prompt_status() {
    if (git status -s --porcelain | grep '^\s+M'); then
	__esn_prompt_color 31
    fi
}

__esn_unicode_by_name() {
    python -c "import sys; sys.stdout.write(u'\N{$1}'.encode('utf-8'))"
}

__esn_prompt_git_remote_status() {
    local remote=$(git config branch.$1.remote)

    if [ -z "$remote" ]; then exit 0; fi

    local behind=$(git rev-list $1..$remote | wc -l)
    local ahead=$(git rev-list $remote..$1 | wc -l)

    if [ "$behind" -ne 0 -a "$ahead" -ne 0 ]; then
	echo -e "$__esn_col_red$__esn_utf8_updown_arrow"
    elif [ "$ahead" -ne 0 ]; then
	echo -e "\[$__esn_col_green\]$__esn_utf8_upwards_arrow"
    elif [ "$ahead" -ne 0 ]; then
	echo -e "\[$__esn_col_green\]$__esn_utf8_downwards_arrow"
    fi
}

__esn_prompt_git_status() {
    gitstatus=$(git status -s --porcelain 2>&1)
    if [ $? -ne 0 ]; then exit 0; fi

    local branch=$(git symbolic-ref HEAD 2>&1| cut -d/ -f3)

    local branch_col=$__esn_col_green
    if echo $gitstatus | grep '^\s*M' > /dev/null 2>&1 ; then
	local branch_col=$__esn_col_red
    fi

    echo " $branch_col[$branch$(__esn_prompt_git_remote_status $branch)$branch_col]"
}

__esn_prompt_venv() {
    if [ -n "$VIRTUAL_ENV" ]; then
	echo "($(basename $VIRTUAL_ENV))"
    fi
}

__esn_prompt_command() {
    PS1="\u@\h$(__esn_prompt_venv):\[$__esn_col_lyellow\]\w$(__esn_prompt_git_status)$__esn_col_no\n[\!]\$ "
}

PROMPT_COMMAND=__esn_prompt_command
