# Localized	09/15/2018 04:55 AM (GMT)	303:6.40.10614 	DNSServer.psd1

# Only add new (name,value) pairs to the end of this table
# Do not remove, insert or re-arrange entries
ConvertFrom-StringData @'
       ###PSLOC start localizing
       #
       # helpID = VersionTooLow
       #
IPAddressExists_helpTopic=http://go.microsoft.com/fwlink/?LinkId=121988
IPAddressExists_title=DNS: IP addresses must be configured on {0}
IPAddressExists_problem=There are no IP addresses associated with {0}.
IPAddressExists_impact=Without an IP address, the computer cannot communicate with other computers on the network or the Internet.
IPAddressExists_resolution=Click Start, click Network, click Network and Sharing Center, and then click Change adapter settings to configure a valid IP address on the adapter.
IPAddressExists_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

IPv4DHCPConfiguration_helpTopic=http://go.microsoft.com/fwlink/?LinkId=121986
IPv4DHCPConfiguration_title=DNS: {0} should have static IPv4 settings
IPv4DHCPConfiguration_problem={0} has dynamically assigned Internet Protocol version 4 (IPv4) addresses.
IPv4DHCPConfiguration_impact=Dynamic IP addresses can change, preventing clients from locating server resources.
IPv4DHCPConfiguration_resolution=Click Start, click Network, click Network and Sharing Center, and then click Change adapter settings to configure a static IP address on the interface.
IPv4DHCPConfiguration_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

IPAutoConfiguration_helpTopic=http://go.microsoft.com/fwlink/?LinkId=121982
IPAutoConfiguration_title=DNS: The IP address {0} on {1} must be accessible to clients
IPAutoConfiguration_problem={1} has an autonet IP address.
IPAutoConfiguration_impact=Without a valid IP address, the computer will not communicate with other network computers.
IPAutoConfiguration_resolution=Click Start, click Network, click Network and Sharing Center, and then click Change adapter settings to configure valid IP addresses on the adapter.
IPAutoConfiguration_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

NoDNSServerConfigured_helpTopic=http://go.microsoft.com/fwlink/?LinkId=121981
NoDNSServerConfigured_title=DNS: {0} must have configured DNS servers
NoDNSServerConfigured_problem={0} does not have any DNS servers configured.
NoDNSServerConfigured_impact=If DNS servers are not configured, the computer cannot resolve names or connect to network resources. Critical operations related to Active Directory Domain Services (AD DS) might also fail.
NoDNSServerConfigured_resolution=Click Start, click Network, click Network and Sharing Center, and then click Change adapter settings to configure at least two DNS servers per interface.
NoDNSServerConfigured_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

DNSServerConfigured_helpTopic=http://go.microsoft.com/fwlink/?LinkId=121980
DNSServerConfigured_title=DNS: {0} should be configured to use both a preferred and an alternate DNS server
DNSServerConfigured_problem={0} has only the preferred DNS server configured.
DNSServerConfigured_impact=The use of a single DNS server per interface does not allow for redundancy and failover. If the configured DNS server becomes unavailable, the computer cannot resolve names and will not connect to other resources.
DNSServerConfigured_resolution=Click Start, click Network, click Network and Sharing Center, and then click Change adapter settings to configure at least two DNS servers per interface.
DNSServerConfigured_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

DNSLoopback_helpTopic=http://go.microsoft.com/fwlink/?LinkId=121979
DNSLoopback_title=DNS: DNS servers on {0} should include their own IP addresses on their interface lists of DNS servers
DNSLoopback_problem={0} on the target computer that is a DNS server does not have its own IP addresses in the list of DNS servers.
DNSLoopback_impact=The inclusion of its own IP address in the list of DNS servers improves performance and increases availability of DNS servers.
DNSLoopback_resolution=Click Start, click Network, click Network and Sharing Center, and then click Change adapter settings to add the loopback IP address to the list of DNS servers on all active interfaces. The loopback IP address should not be the first server in the list.
DNSLoopback_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

DNSAutoConfig_helpTopic=http://go.microsoft.com/fwlink/?LinkId=121977
DNSAutoConfig_title=DNS: The DNS server {0} on {1} must be accessible to clients.
DNSAutoConfig_problem={1} is configured with an autonet IP address as a DNS server.
DNSAutoConfig_impact=A DNS server that belongs to an IP address range that is not valid can prevent this computer from resolving names and connecting to network resources.
DNSAutoConfig_resolution=Click Start, click Network, click Network and Sharing Center, and then click Change adapter settings to remove all invalid or unresponsive DNS servers.
DNSAutoConfig_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

Resolve_Status_DNSSuffix_helpTopic=http://go.microsoft.com/fwlink/?LinkId=121973
Resolve_Status_DNSSuffix_title=DNS: The DNS server {0} on {1} must resolve names in the primary DNS domain zone
Resolve_Status_DNSSuffix_problem=The DNS server {0} on {1} did not successfully resolve the name for the start of authority (SOA) record of the zone hosting the computer's primary DNS domain name.
Resolve_Status_DNSSuffix_impact=Active Directory Domain Services (AD DS) operations that depend on locating domain controllers will fail.
Resolve_Status_DNSSuffix_resolution=Click Start, click Network, click Network and Sharing Center, and then click Change adapter settings to remove or replace all invalid or unresponsive DNS servers.
Resolve_Status_DNSSuffix_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

Resolve_Status_DNSForest_helpTopic=http://go.microsoft.com/fwlink/?LinkId=121974
Resolve_Status_DNSForest_title=DNS: The DNS server {0} on {1} must resolve names in the forest root domain name zone
Resolve_Status_DNSForest_problem=The DNS server {0} on {1} did not successfully resolve the name for the start of authority (SOA) record of the zone hosting the computer's forest root domain name.
Resolve_Status_DNSForest_impact=Active Directory Domain Services (AD DS) operations that depend on locating domain controllers will fail.
Resolve_Status_DNSForest_resolution=Click Start, click Network, click Network and Sharing Center, and then click Change adapter settings to remove all invalid or unresponsive DNS servers.
Resolve_Status_DNSForest_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

Resolve_Status_DNS_LDAP_helpTopic=http://go.microsoft.com/fwlink/?LinkId=121972
Resolve_Status_DNS_LDAP_title=DNS: The DNS server {0} on {1} must resolve LDAP resource records for the domain controller
Resolve_Status_DNS_LDAP_problem=The DNS server {0} on {1} did not successfully resolve the name {2}.
Resolve_Status_DNS_LDAP_impact=Active Directory Domain Services (AD DS) operations that depend on locating domain controllers will fail.
Resolve_Status_DNS_LDAP_resolution=Click Start, click Network, click Network and Sharing Center, and then click Change adapter settings to configure DNS servers that can resolve the name {2}.
Resolve_Status_DNS_LDAP_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

Resolve_Status_DNS_PDC_helpTopic=http://go.microsoft.com/fwlink/?LinkId=121971
Resolve_Status_DNS_PDC_title=DNS: The DNS server {0} on the {1} must resolve PDC resource records for the domain controller
Resolve_Status_DNS_PDC_problem=The DNS server {0} on {1} did not successfully resolve the name {2}.
Resolve_Status_DNS_PDC_impact=Active Directory Domain Services (AD DS) operations that depend on locating a Primary Domain Controller will fail.
Resolve_Status_DNS_PDC_resolution=Click Start, click Network, click Network and Sharing Center, and then click Change adapter settings to configure DNS servers that can resolve the name {2}.
Resolve_Status_DNS_PDC_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

Resolve_Status_DNS_GC_helpTopic=http://go.microsoft.com/fwlink/?LinkId=121970
Resolve_Status_DNS_GC_title=DNS: The DNS server {0} on {1} must resolve Global Catalog resource records for the domain controller
Resolve_Status_DNS_GC_problem=The DNS server {0} on {1} did not successfully resolve the name {2}.
Resolve_Status_DNS_GC_impact=Active Directory Domain Services (AD DS) operations that depend on locating a Global Catalog will fail.
Resolve_Status_DNS_GC_resolution=Click Start, click Network, click Network and Sharing Center, and then click Change adapter settings to configure DNS servers that can resolve the name {2}.
Resolve_Status_DNS_GC_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

Resolve_Status_DNS_KDC_helpTopic=http://go.microsoft.com/fwlink/?LinkId=121967
Resolve_Status_DNS_KDC_title=DNS: The DNS server {0} on {1} must resolve Kerberos resource records for the domain controller
Resolve_Status_DNS_KDC_problem=The DNS server {0} on {1} did not successfully resolve the name {2}.
Resolve_Status_DNS_KDC_impact=Active Directory Domain Services (AD DS) operations that depend on locating a Kerberos Key Distribution Center(KDC) will fail.
Resolve_Status_DNS_KDC_resolution=Click Start, click Network, click Network and Sharing Center, and then click Change adapter settings to configure DNS servers that can resolve the name {2}.
Resolve_Status_DNS_KDC_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

Resolve_Status_DNS_HOST_A_helpTopic=http://go.microsoft.com/fwlink/?LinkId=130024
Resolve_Status_DNS_HOST_A_title=DNS: The DNS server {0} on {1} must resolve the name of this computer
Resolve_Status_DNS_HOST_A_problem=The DNS server {0} on {1} did not successfully resolve the name of the address (A) record for this computer.
Resolve_Status_DNS_HOST_A_impact=Other domain controllers might not be able to resolve this computer's name. The computer might not be able to connect to network resources.
Resolve_Status_DNS_HOST_A_resolution=Click Start, click Network, click Network and Sharing Center, and then click Change adapter settings to configure DNS servers that are able to resolve names for your enterprise.
Resolve_Status_DNS_HOST_A_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

BindingOrder_helpTopic=http://go.microsoft.com/fwlink/?LinkId=121966
BindingOrder_title=DNS: Valid network interfaces should precede invalid interfaces in the binding order.
BindingOrder_problem=A disabled or invalid adapter precedes a valid adapter in the network interface binding order list.
BindingOrder_impact=The binding order determines when network interfaces will be used to make network connections by the computer. A disabled adapter high in the binding order can degrade performance.
BindingOrder_resolution=Click Start, click Network, click Network and Sharing Center, click Change adapter settings, and then press the Alt key, click Advanced, and click Advanced Settings to move all disabled and invalid interfaces to the bottom of the binding order list.
BindingOrder_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

    #  Resources added for MBCAv2 start below

Generic_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice.

DNSLoopbackFirst_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188760
DNSLoopbackFirst_impact=If the loopback IP address is the first entry in the list of DNS servers, Active Directory might be unable to find its replication partners.
DNSLoopbackFirst_problem=The network adapter {0} does not list the local server as a DNS server; or it is configured as the first DNS server on this adapter.
DNSLoopbackFirst_resolution=Configure adapter settings to add the loopback IP address to the list of DNS servers on all active interfaces, but not as the first server in the list.
DNSLoopbackFirst_title=DNS: DNS servers on {0} should include the loopback address, but not as the first entry.

NoIPAddressesExist_helpTopic=http://go.microsoft.com/fwlink/?LinkId=121988
NoIPAddressesExist_impact=The DNS server will fail to resolve any DNS queries.
NoIPAddressesExist_problem=No network adapters are installed and enabled with either the IPv4 or IPv6 protocol.
NoIPAddressesExist_resolution=Install and enable a network adapter and add either the IPv4 or IPv6 protocol.
NoIPAddressesExist_title=DNS: The DNS server must have an IP address.

Param_Blocklist_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188763
Param_Blocklist_impact=Users might register DNS names that have special significance. By default, the Global Query Block List contains the strings "wpad" and "isatap".
Param_Blocklist_problem=The DNS Global Query block list is enabled but empty. The default strings ("wpad" and "isatap") have been removed.
Param_Blocklist_resolution=Disable the Global Query Block List, or add the strings "wpad" and "isatap" to the list if you do not have these services deployed in your environment.
Param_Blocklist_title=DNS: If the Global Query Block List is enabled, then it should not be empty.

Param_CacheLockingOff_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188764
Param_CacheLockingOff_impact=A low cache locking value increases the chance of a successful cache poisoning attack. Network traffic might be directed to a malicious site.
Param_CacheLockingOff_problem=The cache locking value {0}% is less than 90%. By default, the cache locking value is 100%.
Param_CacheLockingOff_resolution=Configure the cache locking value to be 90% or greater.
Param_CacheLockingOff_title=DNS: Cache locking should be configured to 90% or greater.

Param_ForwardingTimeout_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188767
Param_ForwardingTimeout_impact=The timeout value {0} is not within the recommended range of 2 to 10 seconds. DNS resolutions failures can occur if the value is too small. A timeout value of more than 10 seconds can cause DNS resolution delays.
Param_ForwardingTimeout_problem=The forwarding timeout value is less than 2 seconds or greater than 10 seconds.
Param_ForwardingTimeout_resolution=Configure the forwarding timeout value to a value between 2 seconds and 10 seconds.
Param_ForwardingTimeout_title=DNS: The forwarding timeout value should be 2 to 10 seconds.

Param_Hosts_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188769
Param_Hosts_impact=Errors in the Hosts file on a DNS server can cause problems with name resolution on your network.
Param_Hosts_problem=The Hosts file {0} on the DNS server is not empty.
Param_Hosts_resolution=Review the entries in your Hosts file, which is located at {1}.
Param_Hosts_title=DNS: The Hosts file {0} on the DNS server should be empty.

Param_RegistrationEnabled_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188771
Param_RegistrationEnabled_impact=IP addresses on the interface will not be automatically registered in DNS.
Param_RegistrationEnabled_problem=The interface {0} is not configured to register its addresses in DNS.
Param_RegistrationEnabled_resolution=Configure the interface {0} to register the connection's addresses in DNS.
Param_RegistrationEnabled_title=DNS: Interface {0} on the DNS server should be configured to register its IP addresses in DNS.

Param_RootHints_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188773
Param_RootHints_impact=The DNS server will fail to resolve DNS queries for DNS zones for which it is not authoritative.
Param_RootHints_problem=If recursion is enabled then either root hints or forwarders must be configured.
Param_RootHints_resolution=Configure root hints or enable forwarding and configure forwarding servers.
Param_RootHints_title=DNS: The DNS server must have root hints or forwarders configured.

Param_ScavengingServer_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188774
Param_ScavengingServer_title=DNS: The scavenging interval should be within the recommended range.
Param_ScavengingServer_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice. The scavenging interval {0} is within the recommended range.

Param_ScavengingServer_AgingDisabled_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188775
Param_ScavengingServer_AgingDisabled_impact=The size of the DNS database can become excessive if scavenging is not enabled.
Param_ScavengingServer_AgingDisabled_problem=Scavenging is disabled on the DNS server.
Param_ScavengingServer_AgingDisabled_resolution=Enable scavenging on the DNS Server.
Param_ScavengingServer_AgingDisabled_title=DNS: The DNS server should have scavenging enabled.

Param_ScavengingServer_IntervalRange_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188776
Param_ScavengingServer_IntervalRange_impact=An incorrect value will lead to scavenging being run less or more often than desired.
Param_ScavengingServer_IntervalRange_problem=The server scavenging interval has been set to a non-recommended value of {0}.
Param_ScavengingServer_IntervalRange_resolution=Set the server scavenging interval to a value between 6 hours and 28 days.
Param_ScavengingServer_IntervalRange_title=DNS: The scavenging interval {0} should be set to a recommended value.

Param_ScavengingZone_AgingDisabled_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188778
Param_ScavengingZone_AgingDisabled_title=DNS: Zone {0} record aging is disabled, so scavenging will not occur.
Param_ScavengingZone_AgingDisabled_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice. Scavenging parameters were not evaluated because record aging is disabled. Enable aging for the zone {0} if scavenging is desired.

Param_ScavengingZone_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188777
Param_ScavengingZone_title=DNS: Zone {0} should have scavenging enabled with recommended parameters.
Param_ScavengingZone_compliant=The DNS Best Practices Analyzer scan has determined that you are in compliance with this best practice. Zone {0} has scavenging enabled with recommended parameters.

Param_ScavengingZone_NoScavengeServers_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188780
Param_ScavengingZone_NoScavengeServers_impact=DNS records in the zone {0} will not be scavenged.
Param_ScavengingZone_NoScavengeServers_problem=Scavenging is enabled but there are no scavenging servers specified for the zone {0}.
Param_ScavengingZone_NoScavengeServers_resolution=Configure the list of DNS scavenging servers for the zone.
Param_ScavengingZone_NoScavengeServers_title=DNS: Zone {0} scavenging server list should not be empty.

Param_ScavengingZone_RefreshNonDefault_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188781
Param_ScavengingZone_RefreshNonDefault_impact=The DNS server will scavenge resource records too frequently or not frequently enough.
Param_ScavengingZone_RefreshNonDefault_problem=The refresh and no-refresh scavenging intervals for the zone {0} are not set to the default values.
Param_ScavengingZone_RefreshNonDefault_resolution=Configure the refresh and no-refresh intervals for the zone {0} to the default values.
Param_ScavengingZone_RefreshNonDefault_title=DNS: Zone {0} scavenging parameters should be set to default values.

Param_SocketPoolOff_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188782
Param_SocketPoolOff_impact=The DNS server is more vulnerable to DNS spoofing attacks.
Param_SocketPoolOff_problem=The value of {0} in the Windows Registry is configured to a value of {1}.
Param_SocketPoolOff_resolution=Enable the socket pool and configure a recommended value for MaxUserPort.
Param_SocketPoolOff_title=DNS: The socket pool should be enabled with recommended settings.

Param_TimeoutOffset_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188783
Param_TimeoutOffset_impact=The DNS server will fail to respond to queries for external zones if forwarding servers are not available.
Param_TimeoutOffset_problem=The forwarding timeout {0} is greater than or equal to the recursion timeout {1}.
Param_TimeoutOffset_resolution=Configure the recursion timeout to be greater than the forwarding timeout.
Param_TimeoutOffset_title=DNS: The recursion timeout must be greater than the forwarding timeout.

Resolve_Forwarders_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188784
Resolve_Forwarders_impact=Unresponsive forwarders can cause delays and failures in DNS resolution.
Resolve_Forwarders_problem=The forwarder {0} is not responding to DNS queries.
Resolve_Forwarders_resolution=Remove the unresponsive forwarder {0} from the list of forwarders.
Resolve_Forwarders_title=DNS: Forwarding server {0} should respond to DNS queries.

Resolve_Forwarders_AllFail_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188785
Resolve_Forwarders_AllFail_impact=DNS queries for external zones might fail.
Resolve_Forwarders_AllFail_problem=All DNS servers configured in the list of forwarders are unresponsive.
Resolve_Forwarders_AllFail_resolution=Configure valid DNS servers in the list of forwarders.
Resolve_Forwarders_AllFail_title=DNS: At least one DNS server on the list of forwarders must respond to DNS queries.

Resolve_Forwarders_Autoconfig_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188786
Resolve_Forwarders_Autoconfig_impact=DNS queries for external zones might fail.
Resolve_Forwarders_Autoconfig_problem=A link-local IP address {0} is configured as a forwarding server.
Resolve_Forwarders_Autoconfig_resolution=Remove the link-local forwarder IP address {0} from the list of forwarders.
Resolve_Forwarders_Autoconfig_title=DNS: The list of forwarding servers must not contain the link-local IP address {0}.

Resolve_Forwarders_Loopback_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188787
Resolve_Forwarders_Loopback_impact=DNS queries for external zones might fail.
Resolve_Forwarders_Loopback_problem=A loopback IP address {0} is configured as a forwarding server.
Resolve_Forwarders_Loopback_resolution=Remove the loopback forwarder IP address {0} from the list of forwarders.
Resolve_Forwarders_Loopback_title=DNS: The list of forwarding servers must not contain the loopback address {0}.

Resolve_Forwarders_OnlyOne_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188788
Resolve_Forwarders_OnlyOne_impact=The forwarder {0} is a single point of failure.
Resolve_Forwarders_OnlyOne_problem=There is only one forwarder configured on the DNS server.
Resolve_Forwarders_OnlyOne_resolution=Configure additional forwarders on the DNS server.
Resolve_Forwarders_OnlyOne_title=DNS: More than one forwarding server should be configured.

Resolve_Mismatch_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188789
Resolve_Mismatch_impact=DNS queries might fail or be delayed.
Resolve_Mismatch_problem=The DNS servers {0} and {1} do not respond identically to queries for the forest root domain.
Resolve_Mismatch_resolution=Configure DNS servers on the network interface so that either both respond or neither responds to queries for the forest root domain.
Resolve_Mismatch_title=DNS: DNS servers assigned to the network adapter should respond consistently.

Resolve_Peers_AllMasterServersFail_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188790
Resolve_Peers_AllMasterServersFail_impact=The secondary zone {0} will not be updated.
Resolve_Peers_AllMasterServersFail_problem=None of the master servers configured for zone {0} are responding.
Resolve_Peers_AllMasterServersFail_resolution=Validate the list of master servers for the zone {0}.
Resolve_Peers_AllMasterServersFail_title=DNS: Zone {0} master servers must respond to queries for the zone.

Resolve_Peers_AllSecondaryServersFail_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188791
Resolve_Peers_AllSecondaryServersFail_impact=Secondary servers will fail DNS queries for the zone {0}.
Resolve_Peers_AllSecondaryServersFail_problem=None of the secondary servers configured for zone {0} are responding.
Resolve_Peers_AllSecondaryServersFail_resolution=Validate secondary servers for zone {0}.
Resolve_Peers_AllSecondaryServersFail_title=DNS: Zone {0} secondary servers must respond to queries for the zone.

Resolve_Peers_MasterServers_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188792
Resolve_Peers_MasterServers_impact=The secondary zone {0} will not be transferred from the master DNS server {1}.
Resolve_Peers_MasterServers_problem=The secondary zone {0} does not exist on the master server {1}.
Resolve_Peers_MasterServers_resolution=Add the zone {0} to the master server {1} or remove {1} from the list of master servers.
Resolve_Peers_MasterServers_title=DNS: Zone {0} master server {1} must respond to queries for the zone.

Resolve_Peers_MissingMasterServers_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188793
Resolve_Peers_MissingMasterServers_impact=The zone will not be updated on secondary DNS servers.
Resolve_Peers_MissingMasterServers_problem=There are no master servers configured for the zone {0}.
Resolve_Peers_MissingMasterServers_resolution=Update the master servers list for the zone {0}.
Resolve_Peers_MissingMasterServers_title=DNS: Zone {0} master server list must not be empty.

Resolve_Peers_MissingNotifyServers_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188794
Resolve_Peers_MissingNotifyServers_impact=Secondary servers for the zone {0} will not be notified of changes to zone records.
Resolve_Peers_MissingNotifyServers_problem=The list of servers receiving zone update notifications for the zone {0} is empty.
Resolve_Peers_MissingNotifyServers_resolution=Add secondary servers to the zone update notification list for the zone {0}.
Resolve_Peers_MissingNotifyServers_title=DNS: Zone {0} update notification list must not be empty.

Resolve_Peers_MissingSecondaryServers_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188795
Resolve_Peers_MissingSecondaryServers_impact=Zone transfers will be denied from this DNS server.
Resolve_Peers_MissingSecondaryServers_problem=Zone transfers are allowed for the primary zone {0} but no secondary servers are configured.
Resolve_Peers_MissingSecondaryServers_resolution=Add secondary servers to the list of hosts that are allowed to receive zone transfers for the zone {0}.
Resolve_Peers_MissingSecondaryServers_title=DNS: Zone {0} secondary servers list should not be empty.

Resolve_Peers_NotifyServers_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188798
Resolve_Peers_NotifyServers_impact=Zone update notifications for zone {0} will be ignored by the secondary server {1} since it does not host the zone.
Resolve_Peers_NotifyServers_problem=The secondary server {1} is configured to receive zone update notifications for the zone {0}, but it does not host the zone.
Resolve_Peers_NotifyServers_resolution=Remove the secondary server {1} from the list of secondary servers to be notified for updates to zone {0}.
Resolve_Peers_NotifyServers_title=DNS: Zone {0} should be present on the secondary server {1} configured to receive zone update notifications.

Resolve_Peers_ScavengeServers_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188799
Resolve_Peers_ScavengeServers_impact=The server {1} cannot scavenge records in the zone {0}.
Resolve_Peers_ScavengeServers_problem=The DNS server {1} is listed as a scavenging server for zone {0}, but does not host this zone.
Resolve_Peers_ScavengeServers_resolution=Remove the server {1} from the list of scavenging servers for the zone {0}.
Resolve_Peers_ScavengeServers_title=DNS: Zone {0} scavenging servers should host the zone.

Resolve_Peers_SecondaryServers_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188802
Resolve_Peers_SecondaryServers_impact=DNS queries for the zone {0} might fail.
Resolve_Peers_SecondaryServers_problem=The secondary DNS server {1} does not respond to queries for the zone {0}.
Resolve_Peers_SecondaryServers_resolution=Verify that the server {1} is a secondary DNS server that hosts the zone {0}.
Resolve_Peers_SecondaryServers_title=DNS: Zone {0} secondary server {1} should respond to queries for the zone.

Resolve_RootHints_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188803
Resolve_RootHints_impact=The DNS server might be unable to resolve external host names.
Resolve_RootHints_problem=The root hint server {0} is not responding.
Resolve_RootHints_resolution=Validate network connectivity to root hint servers. Remove {0} from the list if it is unresponsive.
Resolve_RootHints_title=DNS: Root hint server {0} must respond to NS queries for the root zone.

Resolve_RootHints_AllFail_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188805
Resolve_RootHints_AllFail_impact=The DNS server might be unable to resolve external host names.
Resolve_RootHints_AllFail_problem=All root hints failed an NS query for the root zone.
Resolve_RootHints_AllFail_resolution=Configure the list of root hints with name servers that are responding.
Resolve_RootHints_AllFail_title=DNS: At least one name server in the list of root hints must respond to queries for the root zone.

Resolve_RootHints_Autoconfig_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188807
Resolve_RootHints_Autoconfig_impact=The DNS server might be unable to resolve external host names.
Resolve_RootHints_Autoconfig_problem=A link-local address is configured in the list of root hints.
Resolve_RootHints_Autoconfig_resolution=Remove the link-local address from the list of root hints.
Resolve_RootHints_Autoconfig_title=DNS: The list of root hints must not contain the link-local IP address {0}.

Resolve_RootHints_Loopback_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188808
Resolve_RootHints_Loopback_impact=The DNS server might be unable to resolve external host names.
Resolve_RootHints_Loopback_problem=The IP address of this DNS server or the loopback address is configured in the list of root hints.
Resolve_RootHints_Loopback_resolution=Remove the loopback or host IP address from the list of root hints.
Resolve_RootHints_Loopback_title=DNS: The list of root hints must not contain the host IP address or loopback address {0}.

Resolve_RootHints_OnlyOne_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188809
Resolve_RootHints_OnlyOne_impact=Loss of the single root hint server {0} will prevent the DNS server from being able to resolve external host names.
Resolve_RootHints_OnlyOne_problem=The root hint {0} that has been configured for the DNS server is a single point of failure.
Resolve_RootHints_OnlyOne_resolution=Add additional root hints to the list of root hint servers.
Resolve_RootHints_OnlyOne_title=DNS: The list of root hints should contain more than one entry.

Resolve_Status_DNS_HOST_AAAA_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188810
Resolve_Status_DNS_HOST_AAAA_impact=The DNS server might be unavailable on the network.
Resolve_Status_DNS_HOST_AAAA_problem=The DNS server {0} on {1} did not successfully resolve the DNS name of this computer.
Resolve_Status_DNS_HOST_AAAA_resolution=Configure DNS servers on the network adapter that can resolve names in the host domain.
Resolve_Status_DNS_HOST_AAAA_title=DNS: The DNS server {0} configured on the adapter {1} should resolve the name of this computer.

Zone_Status_AD_helpTopic=http://go.microsoft.com/fwlink/?LinkId=188812
Zone_Status_AD_title=DNS: Zone {0} is Active Directory integrated and should be present and configured as primary.

Zone_Status_AD_NotPresent_helpTopic=http://go.microsoft.com/fwlink/?LinkId=189238
Zone_Status_AD_NotPresent_impact=DNS queries for the Active Directory integrated zone {0} might fail.
Zone_Status_AD_NotPresent_problem=The Active Directory integrated DNS zone {0} was not found.
Zone_Status_AD_NotPresent_resolution=Restore the Active Directory integrated DNS zone {0}.
Zone_Status_AD_NotPresent_title=DNS: Zone {0} is an Active Directory integrated DNS Zone and must be available.

Zone_Status_AD_NotPrimary_helpTopic=http://go.microsoft.com/fwlink/?LinkId=189239
Zone_Status_AD_NotPrimary_impact=DNS queries for the Active Directory integrated zone {0} might fail.
Zone_Status_AD_NotPrimary_problem=The zone {0} is Active Directory integrated but the zone type is not configured as primary.
Zone_Status_AD_NotPrimary_resolution=Configure the zone type for the zone {0} as a primary.
Zone_Status_AD_NotPrimary_title=DNS: Zone {0} is an Active Directory integrated DNS zone and must be configured as primary.

Zone_Status_AD_NotRunning_helpTopic=http://go.microsoft.com/fwlink/?LinkId=189240
Zone_Status_AD_NotRunning_impact=The DNS server will not respond to queries for the zone {0}.
Zone_Status_AD_NotRunning_problem=The Active Directory integrated zone {0} is unavailable because it is not running.
Zone_Status_AD_NotRunning_resolution=Start the Active Directory integrated zone {0}.
Zone_Status_AD_NotRunning_title=DNS: Zone {0} is an Active Directory integrated DNS zone and must be running.

Zone_Status_XFR_helpTopic=http://go.microsoft.com/fwlink/?LinkId=189298
Zone_Status_XFR_impact=Contents of the zone {0} on this DNS server are out of date.
Zone_Status_XFR_problem=The results of the last zone transfer were {1} for the zone {0}.
Zone_Status_XFR_resolution=Verify that zone transfers are allowed to this DNS server.
Zone_Status_XFR_title=DNS: Zone {0} transfers from the primary to the secondary DNS server must be successful.

'@
