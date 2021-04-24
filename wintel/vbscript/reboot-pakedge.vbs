Option explicit
Dim oShell
set oShell= Wscript.CreateObject("""WScript.Shell""")
oShell.Run """telnet"""
WScript.Sleep 3000
oShell.Sendkeys """open 10.10.10.9~"""
WScript.Sleep 3000
oShell.Sendkeys """pakedge~"""
WScript.Sleep 3000
oShell.Sendkeys """1cecream~"""
WScript.Sleep 3000
oShell.Sendkeys """reboot~"""
WScript.Sleep 3000
oShell.Sendkeys """~"""
Wscript.Quit