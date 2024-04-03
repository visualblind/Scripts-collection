set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.run("telnet.exe")
WScript.Sleep 500
WshShell.SendKeys"open 10.10.10.9"
WshShell.SendKeys("{Enter}")
WshShell.SendKeys"pakedge~"
WshShell.SendKeys("{Enter}")
WScript.Sleep 500
WshShell.SendKeys"password~"
WshShell.SendKeys("{Enter}")


intReturn = oShell.Run("telnet " & WScript.ScriptFullName, 1, TRUE)
oShell.Popup "Notepad is now closed."

oShell.Run """telnet"""
WScript.Sleep 3000
oShell.Sendkeys """open 10.10.10.9~"""
WScript.Sleep 3000
oShell.Sendkeys """pakedge~"""
WScript.Sleep 3000
oShell.Sendkeys """password~"""
WScript.Sleep 3000
oShell.Sendkeys """reboot~"""
WScript.Sleep 3000
oShell.Sendkeys """~"""
Wscript.Quit