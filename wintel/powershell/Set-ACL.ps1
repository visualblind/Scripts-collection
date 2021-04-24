PUSHD Z:\pool0-dataset0-smb
$Acl = Get-Acl "video-movies"
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("SYSINFO\visualblind","FullControl","Allow")
$Acl.SetAccessRule($Ar)
Set-Acl "video-movies" $Acl