# SYNTAX:
rclone lsl --drive-trashed-only <google-drive-remote>:root/path1/path2
rclone copy --dry-run -v --progress --drive-trashed-only --drive-server-side-across-configs <google-drive-remote>:root/path1/path2 <google-drive-remote>:root/path1/path2-Trash

# Real Example:
rclone lsl --drive-trashed-only gcrypt-usmba:/p0ds0smb/video-shows/Mad\ Men
rclone copy --dry-run -v --progress --drive-trashed-only --drive-server-side-across-configs gcrypt-usmba:/p0ds0smb/video-shows/Mad\ Men gcrypt-usmba:/p0ds0smb/video-shows/Mad\ Men-Trash
