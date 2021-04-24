#$s = New-PSSession -ComputerName win2016-4 -Credential Domain01\User01
#Invoke-Command -Session $s
#-Credential Domain01\User01
invoke-command -ComputerName win2016-4 -Credential SYSCONFIG\visualblind -ScriptBlock {gci -r 'E:\DFS' -ErrorAction SilentlyContinue| Measure-Object -Property Length -Sum}