$CurrentValue = [Environment]::GetEnvironmentVariable(“Path”, “Machine”)
[Environment]::SetEnvironmentVariable(“Path”, $CurrentValue + “;C:\Program Files\ISC BIND 9\bin”, “Machine”)