(awk '{printf $4;  for(i=5;i<=NF;i++){printf " %s", $i} printf "\n"}' < rename_examples.sh| grep -v history | grep 'rename') > rename_examples2.sh
find /Music -mindepth 1 -type f -name '*.MP3'|rename -v 's/MP3/mp3/g'
find . -iname "*mkv*" -exec rename -En 's/([^/]+$)//' '{}' \;
find . -iname "*mkv*" -exec rename -En 's/([^/]+$)//' {} +;
find . -iname "*mkv*" -exec rename -En 's/([^/]+$)//' {} \+
find . -iname "*mkv*" -exec rename -En 's/([^/]+$)//' {} \;
find . -iname "*mkv*" -exec rename -v 's/BrRip\.Comm\.//g' '{}' \;
find . -iname "*mkv*" -exec rename -v 's/BrRip\.//g' '{}' \;
find . -iname "*mkv*" -exec rename -v 's/Comm//g' '{}' \;
find . -iname "*mkv*" -exec rename -v 's/\-\[MULVAcoded\]//g' '{}' \;
find . -iname "*mkv*" -exec rename -v 's/\[pseudo\]\ //g' '{}' \;
find . -iname "*mkv*" -exec rename -v 's/WEB\-DL\.//g' '{}' \;
find . -iname "*.mp4" -exec rename -v 's/Part\.//g' '{}' \;
find . -iname "*.mp4" -exec rename -v 's/\[TorrentCouch\.com\]\.//g' '{}' \;
find . -maxdepth 2 -type f -iname '*english.srt' -exec rename -v 's/english\.srt/en\.srt/' {} \;
find . -maxdepth 2 -type f -iname '*english.srt' -exec rename -v 's/english\.srt/en\.srt/i' {} \;
find . -maxdepth 2 -type f -iname '*eng.srt' -exec rename -v 's/eng\.srt/en\.srt/i' {} \;
find . -maxdepth 2 -type f -iname '*(SDH).srt' -exec rename -v 's/(eng|english)\(SDH\)\.srt/en\(SDH\)\.srt/i' {} \;
find . -maxdepth 2 -type f -name '*English.srt' -exec rename -v 's/English\.srt/en\.srt/' {} \;
find . -maxdepth 5 -type f -iname '*english-forced.srt' -exec rename -v 's/english\-forced\.srt/en\.srt/i' {} \;
find . -maxdepth 5 -type f -iname '*english-hi.srt' -exec rename -v 's/english\-hi\.srt/en\-hi\.srt/i' {} \;
find . -maxdepth 5 -type f -iname '*english-sdh.srt' -exec rename -v 's/english\-sdh\.srt/en\(SDH\)\.srt/i' {} \;
find . -maxdepth 5 -type f -iname '*english.srt' -exec rename -v 's/english\.srt/en\.srt/i' {} \;
find . -maxdepth 5 -type f -iname '*eng-sdh.srt' -exec rename -v 's/eng\-sdh\.srt/en\(SDH\)\.srt/i' {} \;
find . -maxdepth 5 -type f -iname '*eng.srt' -exec rename -v 's/eng\.srt/en\.srt/i' {} \;
find /mnt/temp2/* -maxdepth 1 -type d -print0 | renamex -t -s 's/ .*/\./' /mnt/temp2/*
find /mnt/temp2/* -maxdepth 1 -type d -print0 | xargs -0 /usr/bin/renamex -t -s 's/ .*/\./' /mnt/temp2/*
find /mnt/temp2/* -type d -maxdepth 1 -print0 | xargs -0 renamex -t -s 's/ .*/\./' /mnt/temp2/*
find /mnt/temp2/* -type d -maxdepth 1 -print0 | xargs -0 | renamex -t -s 's/ .*/\./' /mnt/temp2/*
find /mnt/temp2/* -type d -maxdepth 1 -print0 | xargs -0 | renamex -t -s 's/ .*/\./' /mnt/temp2/*'
find /mnt/temp2/* -type d -maxdepth 1 -print0 | xargs -0 /usr/bin/renamex -t -s 's/ .*/\./' /mnt/temp2/*
find . -mount -depth -mindepth 1 -maxdepth 3 -type d ! -empty \( -name 'sub' -o -name 'Sub' -o -name 'SUB' -o -name 'Subs' -o -name 'SUBS' -o -name 'subtitle' -o -name 'Subtitle' -o -name 'SUBTITLE' -o -name 'Subtitles' -o -name 'SUBTITLES' \) -exec rename -f -n 's/(.*)\/([^\/]*)/$1\/subs/' {} \;
find . -mount -depth -mindepth 1 -maxdepth 3 -type d ! -empty \( -name 'sub' -o -name 'Sub' -o -name 'SUB' -o -name 'Subs' -o -name 'SUBS' -o -name 'subtitle' -o -name 'Subtitle' -o -name 'SUBTITLE' -o -name 'Subtitles' -o -name 'SUBTITLES' \) -exec rename -f 's/(.*)\/([^\/]*)/$1\/subs/' {} \;
find . -mount -depth -mindepth 1 -maxdepth 3 -type d ! -empty \( -name 'sub' -o -name 'Sub' -o -name 'SUB' -o -name 'Subs' -o -name 'SUBS' -o -name 'subtitle' -o -name 'Subtitle' -o -name 'SUBTITLE' -o -name 'Subtitles' -o -name 'SUBTITLES' \) -exec rename -f -v 's/(.*)\/([^\/]*)/$1\/subs/' {} \;
find . -mount -mindepth 1 -maxdepth 3 -type d ! -empty \( -name 'sub' -o -name 'Sub' -o -name 'SUB' -o -name 'Subs' -o -name 'SUBS' -o -name 'subtitle' -o -name 'Subtitle' -o -name 'SUBTITLE' -o -name 'Subtitles' -o -name 'SUBTITLES' \) -exec rename -f -n 's/(.*)\/([^\/]*)/$1\/subs/' {} \;
find . -mount -mindepth 1 -maxdepth 3 -type d ! -empty \( -name 'sub' -o -name 'Sub' -o -name 'SUB' -o -name 'Subs' -o -name 'SUBS' -o -name 'subtitle' -o -name 'Subtitle' -o -name 'SUBTITLE' -o -name 'Subtitles' -o -name 'SUBTITLES' \) -exec rename -fn 's/(.*)\/([^\/]*)/$1\/subs/' {} \;
find . -mount -mindepth 1 -maxdepth 3 -type d ! -empty \( -name 'sub' -o -name 'Sub' -o -name 'SUB' -o -name 'Subs' -o -name 'SUBS' -o -name 'subtitle' -o -name 'Subtitle' -o -name 'SUBTITLE' -o -name 'Subtitles' -o -name 'SUBTITLES' \) -exec rename -f 's/(.*)\/([^\/]*)/$1\/subs/' {} \;
find . -name '*DDP*' -type f -exec rename -v 's/DDP/AAC/' '{}' \;
find . -name '*DD*' -type f -exec rename -v 's/DD/AAC/' '{}' \;
find . -name '*DTS*' -type f -exec rename -v 's/DTS/AAC/' '{}' \;
find . -name '*\\*' -exec rename -v 's/\///g' '{}' \;
find . -name '*\\*' -exec rename -v 's/\\//g' '{}' \;
find . -name '*.mkv' -exec rename -v 's/\-HETeam//' {} +;
find . -type f -exec rename 's/\-maximersk//' {} \;
find . -type f -exec rename 's/\-MRSK//' {} \;
find . -type f -exec rename 's/\.ReEnc\-Max//' {} \;
find ../video-shows/ -maxdepth 2 -type f -iname '*english.srt' -exec rename -v 's/english\.srt/en\.srt/i' {} \;
find ../video-shows/ -maxdepth 7 -type f -iname '*english.srt' -exec rename -v 's/english\.srt/en\.srt/i' {} \;
find ../video-shows/ -maxdepth 7 -type f -iname '*eng.srt' -exec rename -v 's/eng\.srt/en\.srt/i' {} \;
find ../video-shows/ -maxdepth 7 -type f -iname '*(SDH).srt' -exec rename -v 's/(eng|english)\(SDH\)\.srt/en\(SDH\)\.srt/i' {} \;
find ../video-standup/ -maxdepth 5 -type f -iname '*english.srt' -exec rename -v 's/english\.srt/en\.srt/i' {} \;
find ../video-standup/ -maxdepth 5 -type f -iname '*eng.srt' -exec rename -v 's/eng\.srt/en\.srt/i' {} \;
rename -f 's/5e/5E/' ./*
rename -f 's/\.s/\.S/' ./*
rename -f VLC/ vlc/
rename -f -v 's/S01e/S01E/' *.mkv
rename 's/!//' *
rename 's/\ /\./' ./*
rename 's/\ \-\ /\./' ./*
rename 's/\-/\ \-\ /' *
rename 's/\.\./\./' *
rename 's/\.\./\./' .
rename 's/\ \-\ 01x/\.S01E/' ./*.srt
rename 's/\[([0-9A-Z]){8}\]//g' *.mkv
rename 's/2013\.//' '/p0ds0smb/video-shows/House of Cards (US)/Season 01 (H.264 AVC)/'*
rename 's/2013\.//' '/p0ds0smb/video-shows/House of Cards (US)/Season 01 (H.264 AVC)/*'
rename 's/4mkv/4\.mkv/' ./*
rename 's/4mkv/4\.mkv/' ./*.mkv
rename 's/\_/\ \-\ /' ./*.avi
rename 's/\.bdrip//' ./*.mkv
rename - "s/Bob\'s/Bobs/" *.mkv
rename 's/\.Crazy4ad//i' *.mkv
rename 's/Crazy4TV\.com\ \-\ //' *.mkv
rename 's/\-CtrlHD//' *
rename 's/\-DEFLATE//' *
rename 's/\-demand//' ./*.mkv
rename 's/\-DEMAND//' *.mkv
rename 's/E\d{1}/E0/g' ./*
rename 's/\.ee/\.e/g' *.mkv
rename 's/\.E/\.ee/g' *.mkv
rename 's/EE/E/' ./*.mkv
rename 's/\ \-\ Ehhhh//' ./*.mkv
rename 's/E\n{1}/E0/g' ./*
rename 's/Episode\-//' ./*.avi
rename 's/Flakedd/Flaked/' ./*.mp4
rename 's/flaked/Flakedd/' ./*.mp4
rename 's/\ /\./g' .
rename 's/\ /\./g' ./*
rename 's/\ /\./g' *.mkv
rename 's/\.HDTV//' ./*
rename 's/HOC\ [Ss]\n+[Ee]/House\.of\.Cards\.S$1E/' ./*.mkv
rename 's/Housee/House/' ./*
rename 's/HouSE/Housee/' ./*
rename 's/house\.of\.cards\.2013/House\.of\.Cards/' ./*.mkv
rename 's/\-LOL//' ./*
rename 's/\ /\./' *.mkv
rename 's/\-/\ \-\ /' *.mkv
rename 's/\.mkv/mkv/i' *.mkv
rename 's/\ \(mkvtv\.net\)//' ./*
rename 's/\-\[MULVAcoded\]//' ./*
rename 's/\-\[MULVAcoded\]//' ./*.mkv
rename 's/NF\.WEBRip\.DD5\.1\.//' ./*.mkv
rename 's/NF\.WEBRip\.//' ./*.mkv
rename 's/of1/of/i' ./*
rename 's/of1/of/i' *.mkv
rename 's/of1/of/' *.mkv
rename 's/Of/of1/i' ./
rename 's/Of/of1/i' ./*
rename 's/Of/of1/i' *.mkv
rename 's/Of/of1/' *.mkv
rename 's/Of/of/i' *.mkv
rename 's/Of/of/I' *.mkv
rename 's/Of/of/' *.mkv
rename 's/\.PROPER//i' *.mkv
rename 's/ReEnc\-DeeJayAhmed//' .
rename 's/ReEnc\-DeeJayAhmed//' ./*
rename 's/\.rs2//g' *.mkv
rename 's/S01EE/S01E/' ./*.mp4
rename 's/s01e/S01EE/' ./*.mp4
rename 's/s02ep/S02E/g' ./*
rename 's/s05e/S05EE/' ./*.mkv
rename 's/\.s5e/\.S5E/' ./*
rename 's/samurai\.champloo\./samurai\.champloo\.E/g' *.mkv
rename 's/\.ShAaNiG//i' *.mkv
rename 's/ShAaNiG//i' *.mkv
rename 's/\.ShAaNiG//' *.mkv
rename 's/\-SiGMA//' *
rename 's/\-skgtv\[ettv\]//' ./*.mp4
rename 's/\ \-\ /\./' *.srt
rename 's/\.s/\.S/' ./*
rename 's/\-tbs\[ettv\]//' *
rename 's/The\ Following\ /The\.Following\./' ./*
rename 's/\-TrollHD//' *
rename 's/\-TrollHD//' ./*.mkv
rename 's/\-TrollHD\.//' ./*.mkv
rename 's/TThe/The/' *
rename 's/\.US//i' *.mp4
rename 's/^www\.NewAlbumReleases\.net_../Angus & Julia Stone/g' * --dry-run
rename 's/x264/x265/' *
rename --version
rename -v -f 's/\ /\./' *
rename -v -f 's/\.And/\.and/' *
rename -v -f 's/bluray/BluRay/' *
rename -v -f 's/bluray/BluRay/' *.mkv
rename -v -f "s/Bob's/Bobs/" *.mkv
rename -v -f "s/Bob's/Bobs/' *.mkv
rename -v -f 's/bobs\.burgers\.s11e/Bobs\.Burgers\.S11E/' *.mkv
rename -v -f 's/breaking\.bad\.s01e/Breaking\.Bad\.S01E/' *.mkv
rename -v -f 's/castle\.rock\.s01e/Castle\.Rock\.S01E/' *.mkv
rename -v -f 's/cowboy\.bebop\.s01e/Cowboy\.Bebop\.S01E/' *.mkv
rename -v -f 's/DD\+/AAC/' *.mkv
rename -v -f 's/DDP/AAC/' *
rename -v -f 's/DDP/AAC/' *.mkv
rename -v -f 's/EngSpa/ENG\-SPA/' *.mkv
rename -v -f 's/family\.guy\.s19e/Family\.Guy\.S19E/' family*.mkv
rename -v -f 's/fargo\.s01e/Fargo\.S01E/' *
rename -v -f 's/fargo\.s02e/Fargo\.S02E/' *.mkv
rename -v -f 's/flaked\.s02e/Flaked\.S02E/' *.mkv
rename -v -f 's/\ /\./g' *
rename -v -f 's/\-GalaxyTV//' *
rename -v -f 's/h264/H264/' *.mkv
rename -v -f 's/How\.The/How\.the/' *.mkv
rename -v -f 's/How\.T/How\.t/' *
rename -v -f 's/human\.planet\.s01e(\d)+/Human\.Planet\.S01E0$1/' *.mkv
rename -v -f 's/\-ingot//' *.mkv
rename -v -f 's/In/in/' *.mkv
rename -v -f 's/In\.The/in\.the/' *.mkv
rename -v -f 's/\-invandraren//' *.mkv
rename -v -f 's/its\.always\.sunny\.in\.philadelphia\.s08e/Its\.Always\.Sunny\.in\.Philadephia\.S08E/' *
rename -v -f 's/\.mkv/\-invandraren\.mkv/' *.mkv
rename -v -f 's/mr\.robot\.s01e/Mr\.Robot\.S01E/' *.mkv
rename -v -f 's/mr\.robot\.s03e/Mr\.Robot\.S03E/' *.mkv
rename -v -f 's/murder\.mountain\.s01e/Murder\.Mountain\.S01E/' *.mkv
rename -v -f 's/\.Of/\.of/' *
rename -v -f 's/Of/of/' *
rename -vf 's/\.Of/\.of/' *
rename -v -f 's/Of/of/' *.mkv
rename -v -f 's/Of/of/' *.mp4
rename -v -f 's/Of/of/' Subs/*
rename -v -f 's/Of\.The/of.the/' *
rename -v -f 's/On\.T/on\.t/' *
rename -v -f 's/power\.2014\.s01e/Power\.2014\.S01E/' *.mkv
rename -v -f 's/power\.2014\.s02e/Power\.2014\.S02E/' *.mkv
rename -v -f 's/power\.2014\.s03e/Power\.2014\.S03E/' *.mkv
rename -v -f 's/power\.2014\.s04e/Power\.2014\.S04E/' *.mkv
rename -v -f 's/power\.s04e/Power\.S04E/' *.mkv
rename -v -f 's/\power\.s05e/Power\.S05E/' *.mkv
rename -v -f 's/power\.s05e/Power\.S05E/' *.mkv
rename -v -f 's/rick\.and\.morty/Rick\.and\.Morty/' *.mkv
rename -v -f 's/Roboc/RoboC/' *
rename -v -f 's/ROVERS/rovers/' *
rename -v -f 's/rovers/ROVERS/' *.mkv
rename -v -f 's/rovers\.srt/rovers\.en\.srt/' *.srt
rename -v -f 's/s01e0(\d)/S01E0$1/' *.mkv
rename -v -f 's/s02e(\d+)/S02E$1/' *.mkv
rename -v -f 's/\ Season\ \d+//' *
rename -v -f 's/shameless\.s07e/Shameless\.US\.S07E/' *.mkv
rename -v -f 's/shameless\.us\.s02e/Shameless\.US\.S02E/' *.mkv
rename -v -f 's/shameless\.us\.s03e/Shameless\.US\.S03E/' *
rename -v -f 's/shameless\.us\.s05e/Shameless\.US\.S05E/' *
rename -v -f 's/shameless\.us\.s06e/Shameless\.US\.S06E/' *
rename -v -f 's/snowpiercer\.s02e(\d{2})/Snowpiercer\.S02E$1/' *.mkv
rename -v -f 's/South\ Park\ //' *
rename -v -f 's/south\.park\.s12e(\d{2})/South\.Park\.S12E$1/' *.mkv
rename -v -f 's/\.srt/\.en\.srt/' *.srt
rename -v -f 's/ted\.lasso\.s01e/Ted\.Lasso\.S01E/' *.mkv
rename -v -f 's/the\.expanse\.s01e/The\.Expanse\.S01E/' *.mkv
rename -v -f 's/the\.expanse\.s02e/The\.Expanse\.S02E/' *
rename -v -f 's/the\.simpsons\.s32e(.*)\.h264/The\.Simpsons\.S32E$1\.H264/' **/*.mkv
rename -v -f 's/tom\.clancys\.jack\.ryan\.s01e/Tom\.Clancys\.Jack\.Ryan\.S01E/' *.mkv
rename -v -f 's/true\.detective\.s01e/True\.Detective\.S01E/' *.mkv
rename -v -f 's/true\.detective\.s02e/True\.Detective\.S02E/' *.mkv
rename -v -f 's/true\.detective\.s03e/True\.Detective\.S03E/' *.mkv
rename -v -f 's/vikings\.s02e/Vikings\.S02E/' *
rename -v -f 's/vikings\.s06e/Vikings\.S06E/' *.mkv
rename -v -f 's/vikings\.s06e/Vikings\.S06E/' vikings.s06e14.1080p.web.h264-glhf.mkv
rename -v -f 's/w\.bob\.and\.david\.s01e/W\.Bob\.and\.David\.S01E/' *
rename -v -f 's/web\.h264/WEB\.H264/' *.mkv
rename -v -f 's/web\.h/WEB\.H/' *.mkv
rename -v -f 's/webrip/WebRip/' *.mkv
rename -v -f 's/webrip/WEBRIP/' *.mkv
rename -v -f 's/WebRip/webrip/' *.mkv
rename -v -f 's/web/WEB/' *.mkv
rename -v -f 's/With/with/' *.mkv
rename -v -f 's/x264/AAC51\.x264/' *.mkv
rename -v -f 's/You/YOU/' *.mkv
rename -v 's/-/\./' ./*
rename -v 's/\ /\./' *
rename -v 's/\(//
rename -v 's/\-/\ \-\ /' *
rename -v 's/\.\./\./' *
rename -v 's/\_//' *
rename -v 's/(.*)=(.*)/$2\.html/' *
rename -v 's/0\./00/' *
rename -v 's/00/01/' *
rename -v 's/02e/02EE/' *.mkv
rename -v 's/02EE/02E/' *.mkv
rename -v 's/\-\ 07x(\d{2})\ \-/\-\ S07E$1\ \-/' *.mp4
rename -v 's/\-\ 08x(\d{2})\ \-/\-\ S08E$1\ \-/' *.mp4
rename -v 's/\.\[[0-9]{3}mb\]\.\[MP4\]//' *
rename -v 's/\-\ 09x(\d{2})\ \-/\-\ S09E$1\ \-/' *.mp4
rename -v 's/\(1080p\)/1080p/' *.mkv
rename -v 's/1080p/\.1080p/' *.mkv
rename -v 's/(\ )?[\(|\[]?(1080p|720p|BluRay|YTS\..{2}|x264|x265|h264|h265|h\.264|hevc|webrip|brrip|xvid|dvdrip|dvdscr|dvd)[\]|\)]?//gi' *
rename -v 's/(\ )?[\(|\[]?(1080p|720p|BluRay|YTS\..{2}|x264|x265|hevc|webrip|brrip|xvid|dvdrip|dvdscr|dvd)[\]|\)]?//gi' *
rename -v 's/(\ )?[\(|\[]?(1080p|720p)[\]|\)]?//g' *
rename -v 's/\.\[1080p\.bd\-rip\]/\.\(1080p\)/' *.mkv
rename -v 's/\[1080p_bd\-rip\]/\(1080p\)/' *.mkv
rename -v 's/_\[1080p_bd\-rip\]/\.\(1080p\)/' *.mkv
rename -v 's/\[1080p\ Web\ x264\].*/\(1080p\ x264\)\.mkv/' *
rename -v 's/\ \[1080p\ Web\ x264\]\[AAC\ 5\.1\]\[Sub\]\[Ch\]/\ 1080p\ x264/' *
rename -v 's/\[1080p\ Web\ x265\]\[AAC\ 5\.1\]\[Sub\]\[Ch\]/1080p\ x264/' *
rename -v 's/1080p\ x264/\(1080p\ x264\)/' *
rename -v 's/\ \(1080p\ x264\)//' *.mkv
rename -v 's/\(1280x720\)\ \[Phr0stY[]]?/720p x264/' *.mkv
rename -v 's/13\ Reasons\ Why/13\ Reasons\ Why\ \-/' *
rename -v 's/\ \(1999\)//' *.mkv
rename -v 's/\ \(1999\)//' ../Season*/*.mkv
rename -v 's/\ \(1\)//' *.mkv
rename -v 's/\ \(2012\)\ \-\ /\./' *.mkv
rename -v 's/\[(.{3})\.(.{3})\]\ Conspiracy \-\ /Conspiracy\ \-\ $1$2\ \-\ /' * && rename -v 's/English/en/' *.srt && echo -e '\n\tDONE!'
rename -v 's/\[(.{3})\.(.{3})\]\ The\ Code\ \-\ /The\ Code\ \-\ $1$2\ \-\ /' * && rename -v 's/English/en/' *.srt
rename -v 's/\[(.{3})\.(.{3})\]\ The\ Universe\ \-\ /The\ Universe\ \-\ $1$2\ \-\ /' * && rename -v 's/English/en/' *.srt
rename -v 's/\[(.{3})\.(.{3})\]\ WWII\ in\ HD\ \-\ /WWII\ in\ HD\ \-\ $1$2\ \-\ /' * && rename -v 's/English/en/' *.srt
rename -v 's/(\ \(360p\ re\-blurip\))//g' *
rename -v 's/(\ \(360p\ re\-webrip\))//g' *
rename -v 's/\.5\.1Ch\.BluRay\.ReEnc\-DeeJayAhmed(.*)/\.x264$1/' *
rename -v 's/5\.1Ch\.Web\-DL\.ReEnc\-DeeJayAhmed\.mkv/AAC5\.1\.x264\.mkv/' *
rename -v 's/5\.1Ch\.Web\-DL\.ReEnc\-DeeJayAhmed\.srt/AAC5\.1\.x264\.srt/' *
rename -v 's/6CH\.MkvCage\.ws\.//g' *
rename -v 's/\ 720.*/\.720p\.mkv/' *.mkv
rename -v 's/\[720p\]/\(720p\)/' *
rename -v 's/\[720p\]\ \~\{KiNg\}/720p/' *
rename -v 's/\ AAC\ ESubs\ \-\ LOKiHD\ \-\ Telly//' *.mkv
rename -v 's/AAC\[ettv\]//' *.mkv
rename -v 's/AACP/AAC/' *.mkv
rename -v 's/\.AC3//' *
rename -v 's/AC3/AAC/' *
rename -v 's/AC3/AAC/' */*
rename -v 's/AC3/AAC/' *.mkv
rename -v 's/(American\ Dad\ S)/Season\ /g' *
rename -v 's/\-AMRAP/AAC/' *.mkv
rename -v 's/\.Atmos//' *.mkv
rename -v 's/\-AVS/\.AAC/' *.srt
rename -v 's/Band\.Of\.Brothers\.E/Band\.of\.Brothers\.S01E/' *
rename -v 's/\-BLACKHAT//' *
rename -v 's/black\.sails\.s01e/Black\ Sails\ S01EE/' *.mkv
rename -v 's/(\ )?[\(|\[]?(BluRay|YTS\..{2}|x264|x265|hevc|webrip|brrip)[\]|\)]?//gi' *
rename -v "s/Bob\'s/Bobs/" *.mkv
rename -v 's/bojack\.horseman\.s04e/BoJack\.Horseman\.S04E/' *
rename -v 's/bojack\.horseman\.s04e(.*)\-strife/BoJack\.Horseman\.S04E$1/' *
rename -v 's/bojack\.horseman\.s05e/BoJack\.Horseman\.S05EE/' *
rename -v 's/\-BTN//' *.mkv
rename -v 's/\-CAFFEiNE\[eztv\]//' *
rename -v 's/\-CAFFEiNE\[eztv\]//' *.mkv
rename -v 's/\-CasStudio//' *.mkv
rename -v 's/\-convoy//g' *.mkv
rename -v 's/\-CtrlHD//' *.mkv
rename -v 's/\[cttv\]//' *.mkv
rename -v 's/(.*)(\d{2})\ \-\ (.*)/$1Greatest\ Hits\ \-\ $2\ \-\ $3/' *.mp3
rename -v 's/(\d{2})\ /American\ Greed\ \-\ S07E$1\ \-\ /' *.mp4
rename -v 's/(\d{2})\-neil_young\-(.*)\.mp3/Neil\ Young\ \-\ $1\ \-\ $2\.mp3/' *.mp3
rename -v 's/\-\ (\d{2})x(\d{2})\ HDTV\ \-/\-\ S$1E$2\ \-/' *
rename -v 's/\-\ (\d{2})x(\d{2})\ \-/\-\ S$1E$2\ \-/' *
rename -v 's/\-\ (\d{2})x(\d{2})\ \-/\-\ S$1E$2\ \-/' *.mp4
rename -v 's/\-\ (\d{2})x(\d{2})\ \-/\-\ S$1E$2\ \-/' *.srt
rename -v 's/daa\-//' *.mkv
rename -v 's/^(\d)+?_/A\.Few\.Good\.Men\.1992\.1080p\.BluRay\.H264\.AAC\-RARBG\./' *.srt
rename -v 's/(\d)((\d){2})\ \-\ /Family\ Guy\ \-\ S0$1E$2\ \-\ /' *.mp4
rename -v 's/DD5\.1/AAC5\.1/' *.srt
rename -v 's/DD/AAC/' *
rename -v 's/DD\+/AAC/' *
rename -v "s/DD\+/AAC/" *.mkv
rename -v 's/DD/AAC' *.mkv
rename -v 's/DD/AAC/' *.mkv
rename -v 's/DD\+/AAC/' *.mkv
rename -v 's/DD/AAC/' *.srt
rename -v 's/DD/D' *.mkv
rename -v 's/DDP2\.0\.x264\-monkee/AAC\.x264/' *
rename -v 's/DDP5\.1\.x264\-NTG/AAC5\.1\.x264/' *.mkv
rename -v 's/DDP/AAC/' *
rename -v 's/DDP/AAC/' *.mkv
rename -v 's/DDP/AAC/' *.srt
rename -v 's/\-DEFLATE//' *
rename -v 's/\-DEFLATE\[ettv\]//' *
rename -v 's/\-DEFLATE(\[(ettv|eztv)\])?//' *.mkv
rename -v 's/\-DEFLATE(\[(ettv|eztv)\]?)//' *.mkv
rename -v 's/(\d)of(\d)/S01E0$1/' *
rename -v 's/\ \-\ /\ \-\ Down\ The\ Way\ \-\ /' *.mp3
rename -v 's/DTS/AAC/' *.mkv
rename -v 's/\-DUAL\-iZARDs//' *.mkv
rename -v 's/\-DUAL\-iZARDs//' *.srt
rename -v 's/eastbound\.and\.down\.s03e(.*)\-cinefile/Eastbound\.and\.Down\.S03E$1/' *
rename -v 's/eastbound\.and\.down\.s03e/Eastbound\.and\.Down\.S03E/' *
rename -v 's/eastbound\.and\.down\.s04e(.*)\-demand/Eastbound\.and\.Down\.S04E$1/' *
rename -v 's/EE/E/' *
rename -v 's/[Ee]/EE/' *.mkv
rename -v 's/e/EE/' *.mkv
rename -v 's/EE/E/' *.mkv
rename -v 's/\ \-\ Ehhhh//' *
rename -v 's/(.*)\ \-\ Ehhhh/Mad\ Men\ \-\ $1/' *.mkv
rename -v 's/\-\.Ehhhh//' *.mkv
rename -v 's/\.en\.forced/\.forced/' *.srt
rename -v 's/English/eng/' *.srt
rename -v 's/English/en/' *.srt
rename -v 's/English\.//' *.mkv
rename -v 's/\.en\.srt/\ \(720p\ x264\)\.en\.srt/' *.srt
rename -v 's/\.en\.srt/\.pob\.srt/' *.srt
rename -v 's/\.en\.srt/\.srt/' *.srt
rename -v 's/\.en\.srt/\.srt/' */**.srt
rename -v 's/Episode\ /The\ Simpsons\ S30E/' *
rename -v 's/\ E\-Subs\ \[GWC\]//' *
rename -v 's/Family\ Guy\ /Family\ Guy\ \-\ /' *
rename -v 's/\_\[FileCR\]//' *
rename -v 's/forced/forced\.en/' *.srt
rename -v 's/\-\-\-\ \[\ FreeCourseWeb\.com\ \]\ \-\-\-//' *
rename -v 's/\-\-\-\ \[\ FreeCourseWeb\.com\ \]\ \-\-\-//' **/*
rename -v 's/\-\-\-\ \[\ FreeCourseWeb\.com\ \]\ \-\-\-//' */*
rename -v 's/\-\-\-\ \[\ FreeCourseWeb\.com\ \]\ \-\-\-//' */**
rename -v 's/([\ \-])/./g' *
rename -v 's/([\ |\ \-\ ]+)/\./g' *
rename -v 's/\ /\./g' *
rename -v 's/\ \ /\ /g' *
rename -v 's/\.\./\./g' *
rename -v 's/\_//g' *
rename -v 's/\ /\./g' 2020\ US\ Open\ Final\ -\ Alexander\ Zverev\ vs\ Dominic\ Thiem.mp4
rename -v 's/\-GalaxyTV//' *
rename -v 's/\-GalaxyTV//' *.mkv
rename -v 's/Game\.Of/GGame\.of/' *
rename -v 's/Game\.of\.Thrones\.((.*){6})\.en\.srt/Game\.of\.Thrones.$1\.720p\.x264\.en\.srt/' *.srt
rename -v 's/Game\.of\.Thrones\.((.*){6})\.mp4/Game\.of\.Thrones.$1\.720p\.x264\.mp4/' *.mp4
rename -v 's/\ /\./g' Dominic\ Thiem\ vs\ Novak\ Djokovic\ Full\ Match\ Australian\ Open\ 2020\ Final.mp4
rename -v 's/GG/G/' *
rename -v 's/\-GHOSTS//' *.mkv
rename -v "s/\ /\./g" *.mkv
rename -v 's/([\[|\]])//g' *.mkv
rename -v 's/\ /./g' ./*.mkv
rename -v 's/\ //g' *.mkv
rename -v 's/\ /\./g' *.mkv
rename -v 's/\ \-\ /\./g' *.mkv
rename -v 's/_/\./g' *.mkv
rename -v 's/_/\ /g' *.mp3
rename -v 's/greatest\.events\.of\.world\.war\.ii\.in\.hd\.colour\.s01e/Greatest\.Events\.of\.WWII\.in\.Colour\.S01E/' *.mkv
rename -v 's/\ /\./g' South\ Park*
rename -v 's/\ /\./g' South\ Park*.mkv
rename -v 's/\ /\./g' South.Park\ S16E*
rename -v 's/\.h\ \-\ \-\ Ehhhh//' *
rename -v 's/\-HETeam//' *
rename -v 's/\.HEVC//' *
rename -v 's/HEVC\-PSA\.//' *
rename -v 's/\.HEVC\-PSA//' *.mkv
rename -v 's/Hindi\.//' *.mkv
rename -v 's/HOC\ [Ss]/House\.of\.Cards\.S/' *.mkv
rename -v 's/HousEE/House/' *.mkv
rename -v 's/iasip\.s05e/Its\.Always\.Sunny\.in\.Philadelphia\.S05E/' *.mkv
rename -v 's/\ ImE//' *.mkv
rename -v 's/\ ImE//' ../Season*/*.mkv
rename -v 's/Italian/it/' *.srt
rename -v 's/its\.always\.sunny\.in\.philadelphia\.s13e/Its\.Always\.Sunny\.in\.Philadelphia\.S13EE/' *
rename -v 's/\ ~\{KiNg\}//' *
rename -v 's/La\.Casa\.de\.Papel/Money\.Heist/' *.mkv
rename -v 's/Link\ to\ //' *South*.mkv
rename -v 's/\-METCON//' *.mkv
rename -v "s/\'//" *.mkv
rename -v 's/\ /./' ./*.mkv
rename -v 's/\ //' *.mkv
rename -v 's/\ /\./' *.mkv
rename -v 's/\ \-\ /\./' *.mkv
rename -v 's/\'//' *.mkv
rename -v 's/\(//' *.mkv
rename -v 's/\)//' *.mkv
rename -v 's/\./\ /' *.mkv
rename -v 's/\.\./\.' *.mkv
rename -v 's/\.\./\./' *.mkv
rename -v 's/\.mkv/\.1080p\.mkv/g' South.Park.S16E*
rename -v 's/\.mkv/\.1080p\.mkv/' *.mkv
rename -v 's/\.mkv/\.720p\.x264\.mkv/' *
rename -v 's/\.mkv/\ \(720p\ x264\)\.mkv/' *.mkv
rename -v 's/\-MkvCage\.ws//' *
rename -v 's/\.(?!mkv)/\ /' *.mkv
rename -v 's/\.mkv\.x264/\.x264/' *
rename -v 's/Money\ Heist\ ((.*){6})\ English\ HD\ 720p\ x264\ AAC/Money\.Heist\.$1\.1080p\.NF\.WEB\-DL\.AAC2\.0\.x264/' *.m4a
rename -v 's/Money\ Heist\ (.*){6}\ English\ HD\ 720p\ x264\ AAC/Money\.Heist\.$1\.1080p\.NF\.WEB\-DL\.AAC2\.0\.x264/' *.m4a
rename -v 's/\-Mooi1990//' *.mkv
rename -v 's/\-MoviePirate\-Telly//' *.mkv
rename -v 's/\ /./' ./*.mp4
rename -v 's/(.*)/Mr\.\ Robot\ \-\ $1/' *
rename -v 's/\-MRSK//' *
rename -v 's/\-MRSK//' ./*.mkv
rename -v 's/\-MRSK//' *.srt
rename -v 's/\-MRSK\.srt/\.en\.srt/' *.srt
rename -v 's/\.Multi//' *.mkv
rename -v 's/\-\[MULVAcoded\]//' *
rename -v 's/\-\[MULVAcoded\]//' ./*
rename -v 's/\-\[MULVAcoded\]//' ./*.mp4
rename -v 's/\.MVGroup\.org//' *
rename -v 's/mystery\.science\.theater\.3000\.S1/Mystery\.Science\.Theater\.3000\.S01/' *
rename -v 's/National\.Geographic\.//' *
rename -v ''s/Nature\'/Nature/'' *.mkv
rename -v 's/\-NG//' *.mkv
rename -v 's/\[(.*)\]\ Night\ on\ Earth\ \-\ /Night\ on\ Earth\ \-\ $1\ \-\ /' *
rename -v 's/\ NIT158//g' *
rename -v 's/NIT158\.//g' *
rename -v 's/NTb/NTb\.en/' *.srt
rename -v 's/NUT158\.//g' *
rename -v 's/Oliver\.Stones\.Untold\.History\.Of\.The\.United\.States\.Series\.1\.(\d+)of(\d+)/The\.Untold\.History\.of\.the\.United\.States\.S$1E$2/' *
rename -v 's/ozark\.s01e/Ozark\.S01EE/' *
rename -v 's/\[P4\.Ep(\d*+)\]\ Money\ Heist\ \-\ (.*)\.mkv$/Money\ Heist S04E0$1\ English\ 720p\ WEBRip\ x264\ AAC\.mkv/' *
rename -v 's/Part/S01E0/' *
rename -v 's/Part/S01E0/' *.mkv
rename -v 's/\-PETRiFiED//' *
rename -v 's/\-PHOENiX//' *
rename -v 's/\(PlayHD\.ooo\)\ //' *
rename -v 's/Portuguese\ Brazil/por/' *.srt
rename -v 's/p\./p\.x264/' *.mkv
rename -v 's/\.PROPER//' *
rename -v 's/\-QOQ//' *.mkv
rename -v 's/\-QQQ/' *.mkv
rename -v 's/\-QQQ//' *.mkv
rename -v 's/\-redblade//' *.mkv
rename -v 's/\.ReEnc\-DeeJayAhmed//' *
rename -v 's/ReEnc\-DeeJayAhmed\.//' *
rename -v 's/ReEnc\-DeeJayAhmed\.//' */**
rename -v 's/\.ReEnc\-LUMI//' *
rename -v 's/\.Re\-Encode//' *
rename -v 's/\.repack//' *.mkv
rename -v 's/\-REWARD/\.AAC/' *.srt
rename -v 's/rick\.and\.morty/Rick\.and\.Morty/' *.mkv
rename -v 's/\-rovers//' *
rename -v 's/\-ROVERS//' *
rename -v 's/S01\ (.*)\ \(480p\ \-\ Proper\ DVDRip\)/S01$1/' *
rename -v 's/s01e(\d\d)+\-1080p/S01E$1\.1080p\.BluRay\.x264/' *.mkv
rename -v 's/S01e/S01E/' *.mkv
rename -v 's/s01e/SS01E/' *
rename -v 's/S01\ /S01/' *
rename -v 's/S01/S02/' *
rename -v 's/S02\ (.*)\ \(480p\ \-\ Proper\ DVDRip\)/S02$1/' *
rename -v 's/S02EE/S02E/' *
rename -v 's/s02e/S02E/' *
rename -v 's/s02e/S02EE/' *
rename -v 's/S02\ /S02/' *
rename -v 's/S02/S02E/' *
rename -v 's/S02\ /S02/g' *
rename -v 's/S03\ (.*)\ \(480p\ \-\ Proper\ DVDRip\)/S03$1/' *
rename -v 's/s03e/SS03E/' *
rename -v 's/S03\ /S03/' *
rename -v 's/S04\ (.*)\ \(480p\ \-\ Proper\ DVDRip\)/S04$1/' *
rename -v 's/(.*)\.s04e(.*)/GGame.of.Thrones\.S04E$2/' *
rename -v 's/S09EE/S09E/' *
rename -v 's/s09e/S09EE/' *
rename -v 's/S10EE/S10E/' *
rename -v 's/s10e/S10EE/' *
rename -v 's/\.S12/\.The\.Return\.S02/' *
rename -v 's/S1\.Ep\./Cosmos\.2014\.S01E/' *.mp4
rename -v 's/^S1/Family\ Guy\ S1/' *
rename -v -s 's/DD/AAC' *.srt
rename -v -s 's/DD/AAC/' *.srt
rename -v 's/^(S\d\dE\d\d)\ \-\ (.*)\.mkv/Mad\.Men\.$1\.720p\.$2\.AAC51\.x264\.mkv/' *.mkv
rename -v 's/S(\d+)E(\d+)/S01E$1/' *
rename -v 's/\ Season\ \d+//' *
rename -v 's/Series\.1\.(\d)of6(.*)\.MVGroup\.org/S01E0$1$2/' *.mp4
rename -v 's/\[SGJ5\-LorD\]\.//' *.mkv
rename -v 's/\.ShAaNiG//' *
rename -v 's/\-shortbrehd//' *
rename -v 's/\-SHORTBREHD/' *
rename -v 's/\-SHORTBREHD// *
rename -v 's/\-SHORTBREHD//' *
rename -v 's/\-SiGMA//' *.mkv
rename -v 's/\ Silence//' *
rename -v 's/\-SiNNERS//' *.mkv
rename -v 's/\ /\./' South\ Park*.mkv
rename -v 's/south\.park\.s16e(\d{2})(.*)\-rovers/South\.Park\.S16E$1$2/' *.mkv
rename -v 's/south\.park\.s(\d{2})e(\d{2})(.*)\-filmhd/South\.Park\.S$1E$2$3/' *.mkv
rename -v 's/\-SPiRiT//' *.mkv
rename -v 's/\.srt/\.en\.srt/' *
rename -v 's/\.srt/\.en\.srt' *.srt
rename -v 's/\.srt/\.en\.srt/' *.srt
rename -v 's/\.srt/\.en\.srt/' */**.srt
rename -v 's\.srt/\.en\.srt/' *.srt
rename -v 's/SS01E/S01E/' *
rename -v 's/SS03E/S03E/' *
rename -v 's/\-stout//' *.mkv
rename -v 's/\-STRiFE//' *
rename -v 's/\-STRiFE\[eztv\]//' *
rename -v 's/\-Telly//' *.mkv
rename -v 's/^/The\ Simpsons\ /' *
rename -v 's/The\ Simpsons\ //' *
rename -v 's/(.*)/The\ Simpsons\ \-\ $1/' *
rename -v 's/the\.simpsons\.s30e((.*){2})/TThe\.Simpsons\.S30E$1/' *
rename -v 's/the\.walking\.dead\.s10e/The\.Walking\.Dead\.S10EE/' *
rename -v 's/\[TorrentCouch\.com\]\.//' *
rename -v 's/\[TorrentCouch\.com\]\.//' *.mp4
rename -v 's/\[TorrentCouch.net\].//' ./*
rename -v 's/\[TorrentCouch\.net\]\.//' *
rename -v 's/\-TrollHD//' *
rename -v 's/UHD\.HDR\.//' *.mkv
rename -v 's/\.UK//' *.mkv
rename -v 's/\.UNCENSORED//g' *
rename -v 's/UNCENSORED\ //g' *
rename -v 's/\ \[Unknown\].*/\.mkv/' *
rename -v 's/untouchables\-shameless\.us\.s01e/Shameless\.US\.S01E/' *.mkv
rename -v 's/\ WEB\-DL.*/\.mkv/g' *.mkv
rename -v 's/Web\-DL\.ReEnc\-DeeJayAhmed\.mkv/AAC5\.1\.x264\.mkv/' *
rename -v 's/Web\-DL\.ReEnc\-DeeJayAhmed\.srt/AAC5\.1\.x264\.en\.srt/' *
rename -v 's/Web\-DL/WEB/' *
rename -v 's/web/WEBRip/' *.mkv
rename -v 's/web\.x264\-strife\[eztv\]\./x264\./' *
rename -v 's/www\.Movcr\.to\.\ \-//' *
rename -v 's/www\.Movcr\.to\.\-//' *
rename -v 's/\.www\.mvgroup\.org//' *.mkv
rename -v 's/\.www\.mvgroup\.org//' *.srt
rename -v 's/^www\.NewAlbumReleases\.net_.+$/Angus & Julia Stone/g' *.mp3
rename -v 's/^www\.NewAlbumReleases\.net_.+$/Angus & Julia Stone/' *.mp3
rename -v 's/www\.NewAlbumReleases\.net\_01\ \-\ //' *.mp3
rename -v 's/^www\.NewAlbumReleases\.net_[0-9]{2}/Angus & Julia Stone/g' *mp3
rename -v 's/^www\.NewAlbumReleases\.net_/Angus & Julia Stone - /g' *mp3
rename -v 's/www\.NewAlbumReleases\.net\_/Angus\ \&\ Julia\ Stone\ \-\ /' *.mp3
rename -v 's/www\.NewAlbumReleases\.net\_(\d+)/Angus\ \&\ Julia\ Stone\ \-\ $1/' *.mp3
rename -v 's/\ \-\ www\.torrentazos\.com//' *.mp3
rename -v 's/\ \-\ www\.torrentazos\.com//' *.mp4
rename -v 's/x264mkv/x264\.mkv/' *
rename -v 's/x264mkv/x264\.mkv/' *.mkv
rename -v 's/\.x264\.x264\.mkv/\.x264\.mkv/' *
rename -v 's/\(x265\ 10bit\ DD5\.1\)/x265\.10bit\.DD5\.1/' *.mkv
rename -v 's/x265\ 10bit Joy/x264/' *
rename -v 's/x265\ 10bit\ Joy/x264/' *
rename -v 's/Youu/You/' *
rename -v 's/\_\-YsN1Wl290fs/US\ Open\ 2018\ Final\ \-\ Novak\ Djokovic\ vs\ Juan\ Martin/' *
rename -v 'v/s\.srt/\.en\.srt/' *.srt
rename -v 'y/[A-Z]/[a-z]/' *
renamex -t '* [MKV,AC3] Ehhhh' '#1'
renamex -t '* [MKV,AC3] Ehhhh' '#1' *
renamex -t -s/* [MKV,AC3] Ehhhh #1 *
rename 'y/[A-Z]/[a-z]/' ./*
rename 'y/A-Z/a-z/' *
rename 'Y/A-Z/a-z/' *
