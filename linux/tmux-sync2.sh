#!/bin/sh
#
# The MIT License (MIT)
#
# Copyright (c) 2013 Chris Yuen
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -e

if [ $# -lt 2 ]
then
  echo "Usage: $0 [session_name] [command_1]..."
  exit 1
fi

session=$1
shift

tmux start-server
tmux new -d -s $session

on_error() {
  tmux kill-session -t $session
}
#trap on_error ERR

cmd1=$1
shift
tmux send -t $session:0 "$cmd1" C-m

for i in "$@"
do
  tmux splitw -t $session -l 1
  tmux send -t $session:0.1 "$i" C-m
  tmux selectp -t $session:0.0
  tmux selectl -t $session tiled
done

#tmux setw synchronize-panes on
tmux a -t $session

