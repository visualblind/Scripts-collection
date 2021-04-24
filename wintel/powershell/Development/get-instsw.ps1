gci -path hklm:\software\microsoft\windows\currentversion\uninstall | ForEach-Object -Process { write-output ($_.GetValue("DisplayName") + "`n") }

$OFS = "`r`n"
"$( gci -path hklm:\software\microsoft\windows\currentversion\uninstall | 
    ForEach-Object -Process { write-output $_.GetValue('DisplayName') } )"

$nl = [Environment]::NewLine
$nl = "`r"
gci hklm:\software\microsoft\windows\currentversion\uninstall | 
        ForEach { $_.GetValue("DisplayName") } | Where {$_} | Sort |
        Foreach {"$_$nl"}