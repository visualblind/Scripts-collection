(/usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-movies /usr/local/jellyfin/media/video-movies --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 12h --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-movies.log
/usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-shows /usr/local/jellyfin/media/video-shows --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 12h --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-shows.log
/usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-motogp /usr/local/jellyfin/media/video-motogp --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 1m --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-motogp.log
/usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-formula1 /usr/local/jellyfin/media/video-formula1 --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --dir-cache-time 1m --log-level ERROR --log-file /var/log/rclone-video-formula1.log
/usr/bin/rclone mount gcrypt-usmba:p0ds0smb/podcasts /usr/local/jellyfin/media/podcasts --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 1m --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-podcasts.log
/usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-standup /usr/local/jellyfin/media/video-standup --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 1m --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-standup.log
/usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-tech /usr/local/jellyfin/media/video-tech --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 1m --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-tech.log
/usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-memories /usr/local/jellyfin/media/video-memories --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 1m --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-memories.log
/usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-tennis /usr/local/jellyfin/media/video-tennis --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 1m --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-tennis.log
/usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-starcraft /usr/local/jellyfin/media/video-starcraft --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 1m --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-starcraft.log
/usr/bin/rclone mount gcrypt-usmba:backup/visualblind/Documents/Scripts /mnt/scripts --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 5m --dir-perms 0555 --file-perms 0555 --uid $(id -u) --gid $(id -g) --file-perms 0555)


@reboot /usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-movies /usr/local/jellyfin/media/video-movies --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 12h --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-movies.log
@reboot /usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-shows /usr/local/jellyfin/media/video-shows --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 12h --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-shows.log
@reboot /usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-motogp /usr/local/jellyfin/media/video-motogp --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 1m --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-motogp.log
@reboot /usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-formula1 /usr/local/jellyfin/media/video-formula1 --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --dir-cache-time 1m --log-level ERROR --log-file /var/log/rclone-video-formula1.log
@reboot /usr/bin/rclone mount gcrypt-usmba:p0ds0smb/podcasts /usr/local/jellyfin/media/podcasts --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 1m --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-podcasts.log
@reboot /usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-standup /usr/local/jellyfin/media/video-standup --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 1m --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-standup.log
@reboot /usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-tech /usr/local/jellyfin/media/video-tech --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 1m --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-tech.log
@reboot /usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-memories /usr/local/jellyfin/media/video-memories --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 1m --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-memories.log
@reboot /usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-tennis /usr/local/jellyfin/media/video-tennis --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 1m --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-tennis.log
@reboot /usr/bin/rclone mount gcrypt-usmba:p0ds0smb/video-starcraft /usr/local/jellyfin/media/video-starcraft --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 1m --dir-perms 0555 --file-perms 0444 --uid $(id -u) --gid $(id -g) --log-level ERROR --log-file /var/log/rclone-video-starcraft.log
# @reboot /usr/bin/rclone mount gcrypt-usmba:backup/visualblind/Documents/Scripts /mnt/scripts --daemon --read-only --vfs-cache-mode off --max-read-ahead 1024Ki --dir-cache-time 5m --dir-perms 0555 --file-perms 0555 --uid $(id -u) --gid $(id -g) --file-perms 0555