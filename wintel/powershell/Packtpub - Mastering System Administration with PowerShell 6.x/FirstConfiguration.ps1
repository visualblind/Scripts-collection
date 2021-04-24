Configuration FirstConfiguration {
    Import-DscResource -ModuleName xSMBShare
    node localhost {
        Registry PowerShellKey {
            Key = "HKLM:\SOFTWARE\SIMMONS\POWERSHELL"
            ValueName = "MyRegKey"
            ValueData = "MyValue"
            ValueType = 'String'
            Ensure = 'Present'
        }
        File TempFile {
            DestinationPath = 'C:\temp\myDSC-output.txt'
            Contents = "Created by DSC"
            Type = 'File'
            Ensure = 'Present'
        }
        Service DisableSpooler {
            Name = "Spooler"
            State = 'Stopped'
            DisplayName = "Spooler (Disabled by DSC)"
            StartupType = 'Disabled'
            Ensure = 'Present'
        }
        xSmbShare AppSource #ResourceName
        {
            Name = Apps
            Path = C:\Software\Apps
            Ensure = Present
            ReadAccess = "Everyone"
        }
    }
}