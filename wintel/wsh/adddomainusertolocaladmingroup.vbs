Dim DomainName
Dim UserAccount
Dim UserInput

Set net = WScript.CreateObject("WScript.Network")
Set wshShell = WScript.CreateObject ("WSCript.shell")

local = net.ComputerName

UserInput=InputBox("Enter the domain user you would like to add to the local administrators group")

DomainName = "payrollsolutions.int"
UserAccount = UserInput

set group = GetObject("WinNT://"& local &"/Administrators")

on error resume next
group.Add "WinNT://"& DomainName &"/"& UserAccount &""
CheckError

sub CheckError
	if not err.number=0 then
	set ole = CreateObject("ole.err")
	MsgBox ole.oleError(err.Number), vbCritical
	err.clear
else

	wshShell.Popup "Done. Computer will now reboot...", 5
	wshshell.run "shutdown /r /f /t 5"

end if
end sub