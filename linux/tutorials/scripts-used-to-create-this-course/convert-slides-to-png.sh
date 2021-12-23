#!/bin/bash

# This script converts a PDF into a series of PNG images.
# The images will be created in the directory from which the script is executed.
#
# Usage: $0 [FILE.PDF|/path/to/FILE.PDF]
 
# Pass in a PDF file.
PDF=$1

# Replace ".pdf" with "-slides.png"
SLIDES=${PDF/.pdf/-slides.png} 

# Replace spaces with hyphens
SLIDES=${SLIDES// /-} 

# Convert to lower case
SLIDES=${SLIDES,,}

# Extract the basename from the path, if provided.
SLIDES=$(basename $SLIDES)

# Convert the PDF into a series of images.
convert -density 300 "$PDF" -quality 100 $SLIDES
