#!/bin/sh

GITCMD=git
if test "x${GITTWO_DIRNAME}" != "x"
then
	GITCMD=git2
fi

# test if pwd is a git repo:
${GITCMD} rev-parse --show-toplevel >/dev/null || exit

# you can use all git status options
# what kind of changes show be shown by git? see git-status option -u
# default: no - Show no untracked files

# show header line:
gitname="GIT"
if test "x${GITTWO_DIRNAME}" != "x"
then
	gitname="$(echo "${GITTWO_DIRNAME}" | sed -e s/^\.// \
		| tr '[:upper:]' '[:lower:]')"
fi
echo "[01m[34m${gitname}: $(pwd | sed "s|^$HOME|~|")[0m"

# fetch from remote
${GITCMD} remote update >/dev/null

BASE=$(${GITCMD} merge-base @ @{u} 2>/dev/null)
if test "x$BASE" = "x"
then
	BASE="@"
fi

NUM=`${GITCMD} rev-list $BASE...@{u} --count 2>/dev/null`
LNUM=`${GITCMD} rev-list $BASE...@ --count 2>/dev/null`

if test "x$NUM" != "x" && test $NUM != 0
then
	echo "[01m[31mNeed to pull ($NUM commits behind)[0m"
fi
if test "x$LNUM" != "x" && test $LNUM != 0
then
	echo "[01m[31mNeed to push ($LNUM commits ahead)[0m"
fi

${GITCMD} status -s -uno "$@"

