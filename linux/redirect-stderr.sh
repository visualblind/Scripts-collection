#Redirect stderr to another file:
command > out 2>error
#Redirect stderr to stdout (&1), and then redirect stdout to a file:
command >out 2>&1
#Redirect both to a file:
command &> out