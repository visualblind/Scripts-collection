# Restore-Certificates.ps1
# by Doug Clutter - dougc@douglas-associates.com

# Usage:
# 1) Create this folder C:\AutoExecScripts
# 2) Drop Restore-Certificates.ps1 and Write-ApplicationEventLog.ps1 in C:\AutoExecScripts
# 3) Drop your PFX file(s) in C:\AutoExecScripts
# 4) Update the call to Add-Certificate at the bottom of this page --- look for ALL CAPS
# 5) Make sure you have Windows Powershell v1.0 installed --- get it from MS Update if needed
# 6) Create a task with Task Scheduler.  Important settings:
#    - Command to Start: PowerShell "& ./Restore-Certificates"
#      Yes! You need the quotes and the ampersand just as shown above.
#    - Start In Folder: C:\AutoExecScripts
#    - Schedule: At Machine Startup
#    - RunAs User: Machine Administrator
# 7) To Test #1: Drop to a CMD line, change to C:\AutoExecScripts, enter PowerShell "& ./Restore-Certificates"
# 8) To Test #2: Go to Schedule Task, R-Click on Task and choose Run...Result code should be 0x0
# 9) You should be able to bundle this instance, start a new instance, and the cert should be registered correctly...
#    check the Event Log to verify.

# Thanks to https://blogs.msdn.com/daiken/archive/2007/01/12/windows-powershell-met-capicom.aspx for ideas on crypto library use

function Add-Certificate( [String] $certPath, [String] $certPwd, [String] $certStore )
{
  write-host "Adding cert ($certPath) to Local Machine's $certStore store"

  # Add the certificates into the Certificate Store.
  # Initially, I thought this only needed to happen the first time an instance starts, 
  # but it seems to be necessary each time windows boots up.

  trap {
    write-error $("TRAPPED: " + $_.Exception.GetType().FullName);
    write-error $("TRAPPED: " + $_.Exception.Message); 
    ./Write-ApplicationEventLog.ps1 "Restore-Certificates.ps1" "Error" 1003 $("{0}`n{1}" -f $_.Exception.GetType().FullName, $_.Exception.Message)
    break;
  }

  if ($(test-path $certPath)) {
    # Load the certificate from the PFX
    $cert = new-object System.Security.Cryptography.X509Certificates.X509Certificate2
    $keyFlags = [Security.Cryptography.X509Certificates.X509KeyStorageFlags]::MachineKeySet `
          -bor [Security.Cryptography.X509Certificates.X509KeyStorageFlags]::PersistKeySet `
          -bor [Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable;
    $cert.Import($certPath, $certPwd, $keyFlags)

    # Open the store we will write to
    $lm = new-object System.Security.Cryptography.X509certificates.X509Store("$certStore", "LocalMachine")
    $lm.Open("ReadWrite")
    $lm.Add( $cert )
    $lm.Close()

    Write-Host "Successfully imported certificate: $certPath" -fore green
    ./Write-ApplicationEventLog.ps1 "Restore-Certificates.ps1" "Information" 1002 $("Certificate {0} registered successfully" -f $certPath)
  } else {
    Write-Host "Certificate not found: $certPath" -fore red
    ./Write-ApplicationEventLog.ps1 "Restore-Certificates.ps1" "Error" 1001 $("Unable to find {0} so that certificate was not registered" -f $certPath)
  }
} 

$(
  # When an AMI starts the first time, its name starts with AMAZON.
  while ($(gwmi win32_computersystem).Name.StartsWith("AMAZON")) {

    write-host "Waiting until SysPrep has changed the system name from AMAZON-xxxx"
    ./Write-ApplicationEventLog.ps1 "Restore-Certificates.ps1" "Information" 1004 "Waiting until SysPrep has changed the system name from AMAZON-xxxx"

    # Give SysPrep LOTS of time to finish its work.
    # Usually, the EC2Config service will restart the system once while this is sleeping.  That is not a problem. 
    Start-Sleep -seconds 300
  }

  # My testing found that loading a cert into the store "appeared" to work...but resulted in an unusable cert
  # if you attempt to load the cert before W3SVC is running....so we wait till it starts
  write-host "Waiting for W3SVC service to start"
  while ($(get-service w3svc).Status -ne "Running") { Start-Sleep -seconds 15 }

  # Added this as a precaution --- didn't think I should be mucking about with Certs until this service started
  write-host "Waiting for CRYPTSVC service to start"
  while ($(get-service cryptsvc).Status -ne "Running") { Start-Sleep -seconds 15 }

  # Change to match your PFX file(s)
  Add-Certificate "C:\AutoExecScripts\ADD NAME OF YOUR PFX FILE HERE.pfx" "PASSWORD OF YOUR PFX HERE" "My"

  # You can add multiple certs by adding more calls to Add-Certificate
  # Remember --- IIS 6.0 will only allow you to bind ONE cert to each IP:Port combination
)