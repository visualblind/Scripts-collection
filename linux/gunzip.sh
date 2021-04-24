for f in *.gz ; do gunzip -c "$f" > ../folder2/"${f%.*}" ; done
