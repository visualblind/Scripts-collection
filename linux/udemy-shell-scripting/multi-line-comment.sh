#!/bin/bash


echo "This Line would execute"

## This concept is called as here document in Shell script
<< EOF
	echo "This line would not execute"
	echo "This line2 would not execute"
	echo "This line3 would not execute"
	echo "This line3 would not execute"
	sleep 10   ## This sleep will not execute
EOF

echo "This Line would again execute"

