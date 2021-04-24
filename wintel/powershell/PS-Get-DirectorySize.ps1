# From https://superuser.com/questions/837016/how-can-i-check-the-size-of-a-folder-from-the-windows-command-line

# Best and most effecient one-liner
gci -r 'C:\Users\visualblind\Documents\scripts' | Measure-Object -Property Length -Sum

# Compacted one-liner
$totalsize=[long]0;gci -path c:\your-directory-path -File -r -fo -ea Silent|%{$totalsize+=$_.Length};$totalsize



# Multi-line
$totalsize = [long]0
Get-ChildItem -Path c:\your-directory-path -File -Recurse -Force -ErrorAction SilentlyContinue | % {$totalsize += $_.Length}
$totalsize

# To run it from a normal command prompt
powershell -command "$totalsize=[long]0;gci -Path c:\your-directory-path -File -r -fo -ea Silent|%{$totalsize+=$_.Length};$totalsize"

powershell -c "Get-ChildItem -Recurse 'path_to_dir' | Measure-Object -Property Length -Sum"