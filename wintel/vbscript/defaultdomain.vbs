Dim sDomName
Set oWshShell = CreateObject("WScript.Shell")
sDomName = "Domain"
oWshShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultDomainName", sDomName
