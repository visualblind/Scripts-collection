netsh interface ipv4 set dnsservers name="Local Network Area" source=dhcp register=none

$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration `
 | where{$_.IPEnabled -eq "TRUE"}
 Foreach($NIC in $NICs) {
 $NIC.SetDynamicDNSRegistration("FALSE")
}