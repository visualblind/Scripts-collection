#!/usr/bin/env bash

# For EACH genus and species in the Data Store, derive html-format summary from README
# files in the data collections within each data-type directory (genomes, annotations etc.) 
# Summaries are derived from the synopsis field in the READMEs.

set -o errexit

base="/usr/local/www/data/v2"

for path in $base/*/*/*; do
  read dir1 dir2 dir3 dir4 dir5 genus species type < <(echo $path | perl -pe 's{/}{\t}g')
  speciesdir="$base/$genus/$species"
  echo $genus $species $type
  if [[ $type != "about_this_collection" ]]; then 
    HEADERFILE="$path/_h5ai.header.html"
    echo "<p><b><big>Overview of data in this directory</big></b></p>" > $HEADERFILE
    find $path -name "README*.yml" -print0 | sort -z | xargs -0 | 
      perl -pe 's/ /\n/g' | grep -v "\/\." | xargs -I{} grep -iH "synopsis:" {} |
      perl -pe 's{\S+/([^/]+)/READ.+synopsis:\s+(\S.+)}{  <b>$1:<\/b> $2<br>}i' >> $HEADERFILE
    echo "<hr>" >> $HEADERFILE
  fi
done

