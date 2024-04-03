@echo on
(cd /d "%~dp0")&&(NET FILE||(powershell start-process -FilePath '%0' -verb runas)&&(exit /B)) >NUL 2>&1
powershell  -NoProfile -ExecutionPolicy Bypass "iex (${%~f0} | out-string)"
goto :EOF
: end Batch portion / begin PowerShell #>
$Configuration = @"
<Configuration>
<Add Channel="PerpetualVL2021">
<Product ID="ProPlus2021Volume"  PIDKEY="FXYTK-NJJ8C-GB6DW-3DYQT-6F7TH">
<Language ID="MatchOS" />
        <ExcludeApp ID="Access" />
 <!--  <ExcludeApp ID="Excel" /> -->
        <ExcludeApp ID="Groove" />
        <ExcludeApp ID="Lync" />
        <ExcludeApp ID="OneDrive" />
        <ExcludeApp ID="OneNote" />
 <!--  <ExcludeApp ID"Outlook" /> -->
        <ExcludeApp ID="PowerPoint" />
        <ExcludeApp ID="Publisher" />
        <ExcludeApp ID="Skype" />
        <ExcludeApp ID="Teams" />
 <!-- <ExcludeApp ID="Word" /> -->
       <ExcludeApp ID="Project" />
       <ExcludeApp ID="Visio" />
</Product>
</Add>
<Remove All="TRUE" />
<Property Name="AUTOACTIVATE" Value="1" />
<RemoveMSI All="TRUE" />
<Updates Enabled="TRUE" />
<Property Name="FORCEAPPSHUTDOWN" Value="TRUE" />
<Display Level="Full" AcceptEULA="TRUE" />
</Configuration>
"@
Write-Host $Configuration
Pause
$url = "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_15928-20216.exe"
$output = "ODT.exe"

if (!(Test-Path "Configuration.xml")) {
$Configuration | Set-Content "Configuration.xml"
}
Start-Process -FilePath "notepad.exe" -Wait  -ArgumentList "Configuration.xml"
if (!(Test-Path "setup.exe")) {
# (New-Object Net.WebClient).DownloadFile("https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_15928-20216.exe", "ODT.exe")
Invoke-WebRequest -Uri $url -OutFile $output
Start-Process -FilePath ".\ODT.exe" -Wait -NoNewWindow -ArgumentList "/extract:.", "/quiet"
}
Start-Process -FilePath ".\setup.exe" -NoNewWindow -ArgumentList "/configure", "Configuration.xml" -Wait
$OSCaption = (Get-CimInstance -ClassName CIM_OperatingSystem).Caption
IF ($OSCaption -like '*Windows 7*') {
}