PUSHD \\freenas\p0ds0smb\media-migration\video-standup
$Acl = Get-Acl "Ali Wong - Baby Cobra (2016)"
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("SYSINFO\visualblind","FullControl","Allow")
$Acl.SetAccessRule($Ar)
Set-Acl "Ali Wong - Baby Cobra (2016)" $Acl