#Create Credential
$acctKey = ConvertTo-SecureString -String "7+WyrFbA0vNJLGF/Pz72113NIvHrnA4Tt9SMvfm1y/aN6Te37iqEkaNWONpD5zcn3Z0SwaKPsEKytVTEi+gRIA==" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\masteringpowershell", $acctKey

#Map PSDrive to Azure File Share
New-PSDrive -Name RemoteLogs -PSProvider FileSystem -Root "\\masteringpowershell.file.core.windows.net\remotelogarchive" -Credential $credential

Copy-Item "C:\Temp\MyFakeLogfiles" -Recurse -Destination RemoteLogs:\

