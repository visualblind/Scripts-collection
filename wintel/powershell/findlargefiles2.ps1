##Mention the path to search the files
$path = "D:\Backup"
##Find out the files greater than equal to below mentioned size
$size = 100MB
##Limit the number of rows
$limit = 5
##Find out the specific extension file
$Extension = "*.bak"
##script to find out the files based on the above input
$largeSizefiles = get-ChildItem -path $path -recurse -ErrorAction "SilentlyContinue" -include $Extension | ? { $_.GetType().Name -eq "FileInfo" } | where-Object {$_.Length -gt $size} | sort-Object -property length -Descending | Select-Object Name, @{Name="SizeInMB";Expression={$_.Length / 1MB}},@{Name="Path";Expression={$_.directory}} -first $limit
$largeSizefiles