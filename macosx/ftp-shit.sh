#start ftp
sudo launchctl start com.apple.ftpd
launchctl load -w /System/Library/LaunchDaemons/ftp.plist

#stop ftp
sudo launchctl stop com.apple.ftpd
launchctl unload -w /System/Library/LaunchDaemons/ftp.plist
