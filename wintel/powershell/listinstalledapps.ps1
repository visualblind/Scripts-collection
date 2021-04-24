gwmi -ComputerName TSTBPVSPS02 -class win32reg_addremoveprograms -filter "NOT DisplayName LIKE '%(KB%'" | select DisplayName | sort -property DisplayName

Invoke-Command -cn TSTBPVSPS02 -Scriptblock {Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | select DisplayName, Publisher, InstallDate }

Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | ft -AutoSize