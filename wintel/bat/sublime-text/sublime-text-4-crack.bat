:: for Win64
cd /d "C:\Program Files\Sublime Text" || exit
certutil -hashfile sublime_text.exe md5 | find /i "924C781AC4FCD21A2B46C73B07D7BC27" || exit
echo 000A7214: 48 31 C0 C3          | C:\git-sdk-32\usr\bin\xxd.exe -r - sublime_text.exe
echo 0000711A: 90 90 90 90 90       | C:\git-sdk-32\usr\bin\xxd.exe -r - sublime_text.exe
echo 00007133: 90 90 90 90 90       | C:\git-sdk-32\usr\bin\xxd.exe -r - sublime_text.exe
echo 000A8D53: 48 31 C0 48 FF C0 C3 | C:\git-sdk-32\usr\bin\xxd.exe -r - sublime_text.exe
echo 000A6E0F: C3                   | C:\git-sdk-32\usr\bin\xxd.exe -r - sublime_text.exe
echo 00000400: C3                   | C:\git-sdk-32\usr\bin\xxd.exe -r - sublime_text.exe