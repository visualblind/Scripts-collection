# A collection of questionably worthwhile aliases.
# Usage: source .aliases.sh
# ---

# For practical jokes (or IMpractical jokes, really).

function sayall { trap 'say ${BASH_COMMAND%$PROMPT_COMMAND}' DEBUG ; }
export CTEXT="This is your conscience speaking. I hope you feel good about that..."
function conscience {
    if [[ "$PROMPT_COMMAND" == *\; ]]; then
        PROMPT_COMMAND+="echo $CTEXT"
    else
        PROMPT_COMMAND+=";echo $CTEXT"
    fi
}
function vcon { # vocal
    if [[ "$PROMPT_COMMAND" == *\; ]]; then
        PROMPT_COMMAND+="say $CTEXT"
    else
        PROMPT_COMMAND+=";say $CTEXT"
    fi
}
function every_weekend {
    if [ $PROMPT_COMMAND = "update_terminal_cwd" ]
    then
        PROMPT_COMMAND="cd"
    else
        PROMPT_COMMAND="update_terminal_cwd"
    fi
}
function lsl { alias ls='sl' ; }

# Version control (thanks Zoe!).

function git_status_all {
    for d in $(ls -p | grep '/'); do
        cd $d
        git status
        cd ..
    done
}
function git_pull_all {
    for d in $(ls -p | grep '/'); do
        cd $d
        git pull
        cd ..
    done
}

# Miscellaneous useful (?) aliases.

alias python27='/Library/Frameworks/Python.framework/Versions/2.7/bin/python'
alias automail='${HOME}/sysadmin-scripts/automail.sh'
alias starwars='telnet towel.blinkenlights.nl'
alias cleanup='${HOME}/sysadmin-scripts/cleanup-old.sh'
alias chrome='open -a "Google Chrome" "$*"'

# `find` variants.

function findfs { sudo find "$2" -name "$1" 2>/dev/null ; } # from; sudo
function findr { sudo find / -name "$1" 2>/dev/null ; } # root (SLOW!)
function findf { find "$2" -name "$1" 2>/dev/null ; } # from
function findh { find . -name "$1" ; } # here

# ---
echo '[+] Load successful.'
