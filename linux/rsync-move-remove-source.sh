rsync -av --ignore-existing --exclude '*.part' --remove-source-files --itemize-changes --verbose source/ destination/ && \
rsync -av --itemize-changes --verbose --delete `mktemp -d`/ source/ 
# or
rsync -av --ignore-existing --exclude '*.part' --remove-source-files --itemize-changes --verbose source/ destination/ && \
find source/* -depth -type d -empty -delete