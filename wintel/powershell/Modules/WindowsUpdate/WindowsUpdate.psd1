#
# Module manifest for module 'WindowsUpdate'
#

@{

# Version number of this module.
ModuleVersion = '1.0.0.0'

# ID used to uniquely identify this module
GUID = 'db6155f2-9e89-45cf-876a-f15141294f5b'

# Author of this module
Author = 'Microsoft Corporation'

# Company or vendor of this module
CompanyName = 'Microsoft Corporation'

# Copyright statement for this module
Copyright = '(c) Microsoft Corporation. All rights reserved.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# List of all modules packaged with this module
ModuleList = @('.\WindowsUpdateLog.psm1')

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @('.\WindowsUpdateLog.psm1')

# Functions to export from this module
FunctionsToExport = @('Get-WindowsUpdateLog')
AliasesToExport = @()
CmdletsToExport = @()

# HelpInfo URI of this module
HelpInfoURI = 'https://go.microsoft.com/fwlink/?LinkId=614995'

CompatiblePSEditions = @('Desktop', 'Core')
}
