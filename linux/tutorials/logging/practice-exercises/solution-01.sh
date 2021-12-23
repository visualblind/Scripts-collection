#!/bin/bash

MESSAGE="Random number: $RANDOM"

echo "$MESSAGE"
logger -p user.info "$MESSAGE"
