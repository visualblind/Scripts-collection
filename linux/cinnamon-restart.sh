#!/usr/bin/env bash

# NAME: Travis Runyard
# DATE: 08-10-2022
# DESCRIPTION: The purpose of this script is to show various methods of restarting the Cinnamon DE


## SHORTCUT KEYS/GUI METHODS:
# Alt+F2, type r, <ENTER>
# Ctrl+Alt+Esc (works in all cinnamon modes)

## TERMINAL/CLI METHODS:
$ cinnamon --replace
#HUP will trigger cinnamon process restart (preserving your open window and running applications)
$ pkill -HUP -f "cinnamon --replace"
#For when you dont give a fuck:
$ killall -HUP cinnamon
