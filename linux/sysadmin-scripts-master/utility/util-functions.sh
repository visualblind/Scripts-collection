#!/bin/bash
# util-functions
# A collection of functions that may be helpful in other scripts.
#
# # $LastChangedDate: 2015-07-25 (Sat, 25 Jul 2015) $

# confirm <prompt>
# Prompts the user for a yes or no answer. If yes, this function returns 0 ("true").
# If no, this function returns 1 ("false"). This function will continue to prompt
# the user until it receives an answer of either yes or no.
#
# prompt is a string (likely a question) that will elicit the yes or no response
function confirm {
    eval prompt="$1"
    while true; do
        read -p "${prompt} " ans
        case $ans in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please respond with either yes or no.";;
        esac
    done
}
