#!/bin/bash 

function my_logger() {
  local MESSAGE=$@
  echo "$MESSAGE"
  logger -i -t randomly -p user.info "$MESSAGE"
}

my_logger "Random number: $RANDOM"
my_logger "Random number: $RANDOM"
my_logger "Random number: $RANDOM"
