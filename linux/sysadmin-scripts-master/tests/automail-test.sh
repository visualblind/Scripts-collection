#!/bin/bash
# automail-test
# A tester for the automail script. May clear log files.
# 
# # $LastChangedDate: 2015-07-25 (Sat, 25 Jul 2015) $

if [ ! -f ./utility/util-functions.sh ]; then
    echo "ERROR: ./utility/util-functions.sh not found"
    echo "Please execute this script from the directory in which automail.sh" \
            "& utility/util-functions.sh are located."
    echo "Process aborted."
    exit 1
fi

# Utility functions source file
. utility/util-functions.sh

# test_basic_send
# This should always be run as the first test (because 
# it guarantees the existence of log and error files).
function test_basic_send1 {
    # Run the script
    ./automail.sh "autoMAIL or autoFAIL?" $USER $USER msgs/test.txt
    
    test_contents=`cat msgs/test.txt`
    [ -f "./logs/automail/log.txt" ] && log_file="./logs/automail/log.txt" || log_file="~/logs/automail/log.txt"
    ! grep -q "Sent the email \"autoMAIL or autoFAIL?\" to $USER" "$log_file" && return 1
    ! grep -q "$test_contents" /var/mail/"$USER" && return 1 || return 0
}

# test_basic_send_error1 <error_file>
function test_basic_send_error1 {
    local error_file="$1"
    echo "" > "$error_file"
    
    # Run the script
    ./automail.sh "test" $USER $USER abcdefghijklmnop.txt # this file is assumed to not exist
    grep -q "Error: the file abcdefghijklmnop.txt does not exist!" "$error_file" && return 0 || return 1
}

function run_tests {
    # Set up the output colors: as is life, red equals bad and green equals good!
    RED='\033[1;31m'
    GREEN='\033[1;32m'
    DEFAULT='\033[0m'
    
    num_passed=0 # the number of tests passed
    echo # make a blank line for aesthetic purposes
    
    # test_basic_send1
    if test_basic_send1; then 
        echo -e "${GREEN}[ PASSED ]: test_basic_send1${DEFAULT}"
        let "num_passed += 1"
    else
        echo -e "${RED}[ FAILED ]: test_basic_send1${DEFAULT}"
    fi
    
    # Get log and error files, now that they are guaranteed to exist
    [ -f "./logs/automail/log.txt" ] && log_file="./logs/automail/log.txt" || log_file="~/logs/automail/log.txt"
    [ -f "./logs/automail/error.txt" ] && error_file="./logs/automail/error.txt" || error_file="~/logs/automail/error.txt"
    
    # test_basic_send2
    if test_basic_send_error1 "$error_file"; then
        echo -e "${GREEN}[ PASSED ]: test_basic_send_error1${DEFAULT}"
        let "num_passed += 1"
    else
        echo -e "${RED}[ FAILED ]: test_basic_send_error1${DEFAULT}"
    fi
    
    echo # make another blank line for aesthetic purposes
    echo $num_passed" out of 2 tests passed."
}

### Main script ###
warning_prompt="WARNING: Existing log files may be cleared. Do you want to continue?"
if confirm "\${warning_prompt}"; then
    run_tests
else
    echo "Process aborted."
    exit 0
fi
