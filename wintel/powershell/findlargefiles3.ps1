# >1GB
#$ErrorActionPreference = "SilentlyContinue"
Get-ChildItem C:\ -recurse -include *.* -exclude "c:\windows\*" -erroraction 'silentlycontinue' | where-object {$_.length -gt 1GB} |`
Sort-Object -property length -Descending | Select-Object @{Name="Files > 1GB";`
Expression={$_.FullName}}, @{Name="SizeInGB";Expression={[math]::Round($_.Length / 1024MB, 2)}}

# >10GB
Get-ChildItem C:\ -recurse -include *.* -exclude "c:\windows\*" -erroraction 'silentlycontinue' | where-object {$_.length -gt 10GB} |`
Sort-Object -property length -Descending | Select-Object @{Name="Files > 10GB";`
Expression={$_.FullName}}, @{Name="SizeInGB";Expression={[math]::Round($_.Length / 1024MB, 2)}}