@{
ModuleVersion = '1.0'
GUID = '28c9a37e-c849-4370-b672-e5563447b0e1'
Author="Microsoft Corporation"
CompanyName="Microsoft Corporation"
Copyright="© Microsoft Corporation. All rights reserved."
HelpInfoUri="http://go.microsoft.com/fwlink/?LinkId=626871"
ModuleToProcess="Microsoft.ConfigCI.Commands"
PowerShellVersion="3.0"
CLRVersion="4.0"
CmdletsToExport=@(
    "Get-SystemDriver",
    "New-CIPolicyRule",
    "New-CIPolicy",
    "Get-CIPolicy",
    "Merge-CIPolicy",
    "Remove-CIPolicyRule",
    "Edit-CIPolicyRule",
    "Set-RuleOption",
    "Set-HVCIOptions",
    "Set-CIPolicySetting",
    "Set-CIPolicyIdInfo",
    "Get-CIPolicyIdInfo",
    "Get-CIPolicyInfo",
    "Add-SignerRule",
    "Set-CIPolicyVersion",
    "ConvertFrom-CIPolicy")
FunctionsToExport=@()
AliasesToExport=@()
}
