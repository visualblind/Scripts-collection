'Description
'Lists all the shared folders on a computer. 
'Script Code

Dim strComputer

strComputer = Inputbox("Enter Computer Name","Enter Computer Name")

Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colShares = objWMIService.ExecQuery("Select * from Win32_Share")
For each objShare in colShares
Wscript.Echo "AllowMaximum: " & vbTab & objShare.AllowMaximum & vbcrlf &_
	"Caption: " & vbTab & objShare.Caption & vbcrlf &_
	"MaximumAllowed: " & vbTab & objShare.MaximumAllowed  & vbcrlf &_
	"Name: " & vbTab & objShare.Name & vbcrlf &_
	"Path: " & vbTab & objShare.Path & vbcrlf &_
	"Type: " & vbTab & objShare.Type  
Next
 
wscript.echo "Done"