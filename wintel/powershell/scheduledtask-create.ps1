$script = 'C:\yourscript.ps1'
$user = 'your_account'
$pswd = 'your_password'
 
$date = Get-Date (([datetime](Get-Date -Format g)).AddDays($_))-Format d
 
$sAction = @{
  Execute = "powershell.exe"
  Argument = "-NonInteractive -NoLogo -NoProfile -ExecutionPolicy Bypass $($script)"
}
$Action = New-ScheduledTaskAction @sAction
 
$interval = New-TimeSpan -Days 1
$repetetion_timespan = New-TimeSpan -Days 1
$sTrigger = @{
  Once = $true
  At = "$($date) 9:00am"
  RepetitionInterval = $interval
  RepetitionDuration = $repetetion_timespan
}
$Trigger = New-JobTrigger @sTrigger
 
$sTask = @{
  TaskName = 'Daily Datastore Report'
  User = $user
  Password = $pswd
  RunLevel = 'Highest'
  Action = $Action
  Trigger = $Trigger
}
Register-ScheduledTask @sTask