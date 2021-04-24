# Write-ApplicationEventLog.ps1
# by Doug Clutter - dougc@douglas-associates.com

# Writes an entry to the Application Event Log
# ./Write-ApplicationEventLog "Sample" "Error" 1001 "Helpful message"

param ([string] $source, [System.Diagnostics.EventLogEntryType] $eventLogEntryType, [int32] $eventId, [string] $message)
process {
  $EventLog = New-Object System.Diagnostics.EventLog('Application')
  $EventLog.MachineName = "."
  $EventLog.Source = "$source"
  $EventLog.WriteEntry("$message", $eventLogEntryType, $eventId) 
}