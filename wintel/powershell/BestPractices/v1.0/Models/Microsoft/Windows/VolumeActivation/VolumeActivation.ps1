#
# ----------------------------------------------------------
# Translations definition (Fallback text for psd1)
# ----------------------------------------------------------
#
data _system_translations {
ConvertFrom-StringData @'

    rule0_Title      = KMS host key is not installed.
    rule0_Problem    = KMS host key needs to be installed for the Volume Activation Services to work.
    rule0_Impact     = Without a KMS host key, the Volume Activation Services will not be able to function properly.
    rule0_Resolution = Install a KMS host key  using slmgr.vbs /ipk [KMS host key] in a command prompt window.
    rule0_Compliant  = The Volume Activation Best Practices Analyzer has determined that you are in compliance with this best practice.

    rule1_Title      = An inbound Windows Management Instrumentation (WMI) firewall exception is not enabled.
    rule1_Problem    = An inbound Windows Management Instrumentation (WMI) firewall exception needs to be enabled for the Volume Activation Tools to connect to the target computer.
    rule1_Impact     = Without an inbound exception for the Windows Management Instrumentation (WMI), the Volume Activation Tools will not be able to connect to the target computer for volume activation management.
    rule1_Resolution = If the computer is running Windows Vista or later or Windows Server 2008 or later (other than Server Core), go to Administration Tools and open Windows Firewall with Advanced Security. In the navigation pane click Inbound Rules. In the details pane select Windows Management Instrumentation (WMI-In). In the Actions pane click Enable Rule.
    rule1_Compliant  = The Volume Activation Best Practices Analyzer has determined that you are in compliance with this best practice.

    rule2_Title      = An inbound Windows Firewall Remote Management (RPC) firewall exception is not enabled.
    rule2_Problem    = An inbound Windows Firewall Remote Management (RPC) firewall exception needs to be enabled for the Volume Activation Tools to query and configure firewall settings on the target computer.
    rule2_Impact     = Without an inbound exception for the Remote Management (RPC), the Volume Activation Tools will not be able to query or configure firewall settings on the target computer.
    rule2_Resolution = If the computer is running Windows Vista or later or Windows Server 2008 or later (other than Server Core), go to Administration Tools and open Windows Firewall with Advanced Security. In the navigation pane click Inbound Rules. In the details pane select Remote Management (RPC). In the Actions pane click Enable Rule.
    rule2_Compliant  = The Volume Activation Best Practices Analyzer has determined that you are in compliance with this best practice.

    rule3_Title      = An inbound Key Management Service (TCP) firewall exception is not enabled.
    rule3_Problem    = An inbound Key Management Service (TCP) firewall exception needs to be enabled for the Volume Activation Tools to query or configure KMS settings on the target computer.
    rule3_Impact     = Without an inbound exception for the Key Management Service (TCP), the Volume Activation Tools will not be able to query or configure KMS settings on the target computer.
    rule3_Resolution = If the computer is running Windows Vista or later or Windows Server 2008 or later (other than Server Core), go to Administration Tools and open Windows Firewall with  Advanced Security. In the navigation pane click Inbound Rules. In the details pane select Key Management Service (TCP-In). In the Actions pane click Enable Rule.
    rule3_Compliant  = The Volume Activation Best Practices Analyzer has determined that you are in compliance with this best practice.

    rule4_Title      = Key Management Service activation count is not large enough.
    rule4_Problem    = This issue may occur if not enough client computers have been added to the KMS pool on the Key Management Service (KMS) host. A minimum of 25 computers must be in the KMS pool.
    rule4_Impact     = KMS will not be able to activate client machines if the KMS pool contains fewer than 25 clients.
    rule4_Resolution = To resolve this issue, determine how many computers are in the KMS pool on the KMS host, open a command prompt window, type slmgr.vbs /dli and press Enter. Then add more computers so that the KMS pool contains at least 25 computers.
    rule4_Compliant  = The Volume Activation Best Practices Analyzerhas determined that you are in compliance with this best practice.

'@
}

Import-LocalizedData -BindingVariable _system_translations -fileName VolumeActivation.psd1

#
# ----------------------------------------------------------
# CONSTANTS
# ----------------------------------------------------------
#
# Custom namespace
$NS = "http://schemas.microsoft.com/mbca/models/VolumeActivation/2011/02"

# Firewall
$FW_DIRECTION_IN = 1
$FW_PROTOCOL_TCP = 6
$FW_PROFILE_DOMAIN = 1

# SPPSVC
$SERVICE_NAME = "sppsvc"
$MIN_KMS_COUNT = 25
$PKEY_NOT_INSTALLED = 3221549076

$WINMGMT = "winmgmt"
$WMI_GROUPING = "@FirewallAPI.dll"

$FIREWALL = "policyagent"

#
# ----------------
# HELPER FUNCTIONS
# ----------------
#
function Initialize($computerName)
{
    $global:softwareLicensingService = Get-WmiObject -Class SoftwareLicensingService -ComputerName $computerName 
    $global:softwareLicensingProduct = Get-WmiObject -Class SoftwareLicensingProduct -ComputerName $computerName  -filter "Description Like '%VOLUME_KMS%'"
}

function IsKmsInstalled()
{
    foreach ($objItem in $softwareLicensingProduct)
    {
        if (($objItem.Description.Contains("VOLUME_KMSCLIENT") -ne 'true') -and ($objItem.LicenseStatusReason -ne $PKEY_NOT_INSTALLED))
        {
            $csvlkProduct = $objItem
        }
    }
    return $csvlkProduct
}

function GetKmsCount($csvlk)
{
    if ($csvlk -ne $null)
    {           
        return ($csvlk.KeyManagementServiceCurrentCount)
    }        
    return -1
}

function IsFirewallEnabled($ServiceName, $Protocol, $LocalPorts, $Direction, $Grouping, $Profiles)
{
    $fw = New-Object -ComObject hnetcfg.fwpolicy2
    $rules = $fw.rules
    
    if ($ServiceName)   { $rules = $rules | Where-Object { $_.serviceName -eq $ServiceName } }
    if ($Protocol)      { $rules = $rules | Where-Object { $_.Protocol -eq $Protocol } }
    if ($LocalPorts)    { $rules = $rules | Where-Object { $_.LocalPorts -eq $LocalPorts } }
    if ($Direction)     { $rules = $rules | Where-Object { $_.Direction -eq $Direction } }
    if ($Grouping)      { $rules = $rules | Where-Object { $_.Grouping.startsWith($Grouping) } }
    if ($Profiles)      { $rules = $rules | Where-Object { $_.Profiles -band $Profiles } }

    return (@($rules).Count -eq 1 -and $rules.Enabled -eq 'true')
}

#
# -------------------
# DISCOVERY FUNCTIONS
# -------------------
#

function DiscoverKms()
{
    $kmsNode = @{}
    
    $csvlk = IsKmsInstalled
    
    $kmsNode.isKmsInstalled = $csvlk -ne $null
    $kmsNode.kmsCount = GetKmsCount($csvlk)
    
    $kmsNode
}

function DiscoverFirewall()
{
    $firewallNode = @{}

    $keyManagementServiceListeningPort = $softwareLicensingService.KeyManagementServiceListeningPort
       
    $firewallNode.kms = IsFirewallEnabled $SERVICE_NAME $FW_PROTOCOL_TCP $keyManagementServiceListeningPort $FW_DIRECTION_IN $null $FW_PROFILE_DOMAIN

    $firewallNode.wmi = IsFirewallEnabled $WINMGMT $FW_PROTOCOL_TCP $null $FW_DIRECTION_IN $WMI_GROUPING $FW_PROFILE_DOMAIN

    $firewallNode.firewall = IsFirewallEnabled $FIREWALL $FW_PROTOCOL_TCP $null $FW_DIRECTION_IN $WMI_GROUPING $FW_PROFILE_DOMAIN

    $firewallNode
}

#
# ----------------------------------------------------------
# RULE VIOLATION GENERATOR
# ----------------------------------------------------------
#
function RuleViolation()
{
    $xdoc.DocumentElement.CreateNavigator().AppendChild(
@"
<Violation>
    <ID>$args</ID>
</Violation>
"@
)
}

#
# ----------------------------------------------------------
# RULE VIOLATION DETECTORS
# ----------------------------------------------------------
#
$detectors = {

    if ($discov.kms.isKmsInstalled -ne 'true')
    {
        #
        # Rule 0
        #
        RuleViolation 0
    }
    else
    {
        #
        # Rule 1
        #
        if (!$discov.firewall.wmi)
        {
            RuleViolation 1
        }

        #
        # Rule 2
        #
        if (!$discov.firewall.firewall)
        {
            RuleViolation 2
        }

        #
        # Rule 3
        #
        if (!$discov.firewall.kms)
        {
            RuleViolation 3
        }

        #
        # Rule 4
        #
        if ($discov.kms.kmsCount -lt $MIN_KMS_COUNT)
        {
            RuleViolation 4
        }
    }
}

#
# ----------------------------------------------------------
# Set Vars
# ----------------------------------------------------------
#
$computerName = "."

#
# ----------------------------------------------------------
# Script Body
# ----------------------------------------------------------
#

# Rule violation document
$xdoc = [xml]"<VolumeActivationComposite xmlns='$NS' />"

# Wrapper for element creation function in custom namespace
# NOTE: These global variables are used in above rule generator functions
$create = ({$xdoc.createElement($args[0], $NS)}).invokeReturnAsIs
$addElem = $xdoc.DocumentElement.appendChild

# Make discoveries
# NOTE: Used by rule violation detectors
Initialize($computerName)

$discov = @{}
$discov.kms = (DiscoverKms)
$discov.firewall = (DiscoverFirewall)

# Run violation detectors
.($detectors)

# Save xml document (Test Only)
#$xdoc.save("$HOME\Desktop\volumeactivation_violations.xml")

# Return the xml document
$xdoc