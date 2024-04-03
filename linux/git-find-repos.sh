#!/bin/bash

# you can use all git status options
# what kind of changes show be shown by git? see git-status option -u
# default: no - Show no untracked files

# Directories to exclude:
excluded_dirs="Library
Downloads
Applications
Movies
Pictures
Music
.\*"

GIT_DIRNAME=".git"
if test "x${GITTWO_DIRNAME}" != "x"
then
	GIT_DIRNAME="${GITTWO_DIRNAME}"
fi

## Script
# find .git dirs:
find . 	\
	-type d \
	\( -false $(printf " -or -path */%s/* " $excluded_dirs) \) \
	-prune -or \
	-type d \
	-name "${GIT_DIRNAME}" \
	-execdir git-extended-status $@ ";"


# Add support for git2:
#if test "x${GIT_DIR}" != ".git2"
#then
#GIT_DIR=".git2" $0 $@
#fi

# or just run GIT_DIR=".git2" git-find-repos ...

