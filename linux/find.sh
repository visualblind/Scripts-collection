#!/usr/bin/env bash

# The thing Id found confusing about about -prune is that its an action (like -print),
# not a test (like  -name). It alters the "to-do" list, but always returns true.

# The general pattern for using -prune is this:

find [path] [conditions to prune] -prune -o \
[your usual conditions] [actions to perform]

# You pretty much always want the the -o immediately after -prune, because that first part of the
# test (up to including -prune) will return false for the stuff you actually want
# (ie: the stuff you dont want to prune out).

# Heres an example:

find . -name .snapshot -prune -o -name '*.foo' -print

# This will find the "*.foo" files that aren't under ".snapshot" directories. In this example,
# -name .snapshot is the "tests for stuff you want to prune", and -name '*.foo' -print is the
# "stuff youd normally put after the path".

# Important notes:
# If all you want to do is print the results you might be used to leaving out the -print action.
# You generally dont want to do that when using -prune.

# The default behavior of find is to "and" the entire expression with the -print action if there
# are no actions other than -prune (ironically) at the end. That means that writing this:

find . -name .snapshot -prune -o -name '*.foo'              # DONT DO THIS

# is equivalent to writing this:

find . \( -name .snapshot -prune -o -name '*.foo' \) -print # DONT DO THIS

#which means that itll also print out the name of the directory youre pruning, which usually
# isnt what you want. Instead its better to explicitly specify the -print action if thats what you want:

find . -name .snapshot -prune -o -name '*.foo' -print       # DO THIS

# If your "usual condition" happens to match files that also match your prune condition,
# those files will not be included in the output. The way to fix this is to add a -type d predicate
# to your prune condition.

# For example, suppose we wanted to prune out any directory that started with .git
# (this is admittedly somewhat contrived -- normally you only need to remove thing named exactly .git),
# but other than that wanted to see all files, including files like .gitignore. You might try this:

find . -name '.git*' -prune -o -type f -print               # DONT DO THIS

# This would not include .gitignore in the output. Heres the fixed version:

find . -type d -name '.git*' -prune -o -type f -print       # DO THIS

# Extra tip: if youre using the GNU version of find, the texinfo page for find has a more detailed
# explanation than its manpage (as is true for most GNU utilities).