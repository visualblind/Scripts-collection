rename "s/SEARCH/REPLACE/g"  *
rename 's/^/MyPrefix_/' * 
rename  "s/3//g"  *
rename 's/\.pdf$/\.doc/' *


rename -v -n 's/^www\.NewAlbumReleases\.net_[\d]{2}/Angus & Julia Stone/g' *mp3
rename -v -n 's/^www\.NewAlbumReleases\.net_/Angus & Julia Stone - /g' *mp3