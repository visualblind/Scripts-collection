$ChassisTypes = (Get-WmiObject -Class Win32_SystemEnclosure).ChassisTypes
 
Switch($ChassisTypes) {
 
    3 { $Chassis = "Desktop" }
    4 { $Chassis = "Desktop" }
    5 { $Chassis = "Desktop" }
    6 { $Chassis = "Desktop" }
    7 { $Chassis = "Desktop" }
    8 { $Chassis = "Laptop" }
    9 { $Chassis = "Laptop" }
    10 { $Chassis = "Laptop" }
    11 { $Chassis = "Laptop" }
    12 { $Chassis = "Laptop" }
    14 { $Chassis = "Laptop" }
    15 { $Chassis = "Desktop" }
    16 { $Chassis = "Desktop" }
    18 { $Chassis = "Laptop" }
    21 { $Chassis = "Laptop" }
    23 { $Chassis = "Server" }
    31 { $Chassis = "Laptop" }
 
}
If($Chassis -eq "Laptop") {
 
    Do {
      $PowerStatus = (Get-WmiObject -Class BatteryStatus  -Namespace root\wmi -ErrorAction SilentlyContinue).PowerOnLine
 
        If($PowerStatus -ne $True) {
 
            $TSEnv = New-Object -ComObject "Microsoft.SMS.TsProgressUI"
            $TSEnv.CloseProgressDialog()
            $wshell = New-Object -ComObject Wscript.Shell
            $wshell.Popup("Please Connect AC Power - Click OK to Continue",0,"AC Power Check",0)
     
        }
    }
    Until($PowerStatus -eq $True)
 
}