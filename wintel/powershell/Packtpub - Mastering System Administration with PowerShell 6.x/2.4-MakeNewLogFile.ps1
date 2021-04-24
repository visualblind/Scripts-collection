$filePath = "C:\temp\MyFakeLogfiles\MyNewLogFile_$(Get-Date -F yyyy-MM-dd_hh-mm-ss).txt"
$contents = Get-Process
New-Item -ItemType File -Path $filePath -Value $contents -Force

