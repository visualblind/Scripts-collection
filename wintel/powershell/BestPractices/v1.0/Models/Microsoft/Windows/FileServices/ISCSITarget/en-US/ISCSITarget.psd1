# Localized	03/08/2022 02:20 PM (GMT)	303:6.40.10614 	ISCSITarget.psd1
# Localized	02/29/2012 05:57 AM (GMT)	303:4.80.0411 	ISCSITarget.psd1
#
# WinTarget BPA Localization File
#

ConvertFrom-StringData @'
###PSLOC - Start Localization

    # check role service is installed
FeatureInstalled_Title=The iSCSI Target Server role service must be installed.
FeatureInstalled_Problem=The iSCSI Target Server role service is not installed.
FeatureInstalled_Impact=The scan will be unsuccessful if the iSCSI Target Server role service is not installed.
FeatureInstalled_Resolution=Using Server Manager, install the iSCSI Target Server role service.
FeatureInstalled_Compliant=The File and Storage Services Best Practices Analyzer scan has determined that you are in compliance with this best practice.

    # check service is running
ServiceRunning_Title=The WinTarget service must be running.
ServiceRunning_Problem=The WinTarget service is not running.
ServiceRunning_Impact=iSCSI Target Server will be unable to provide block storage to iSCSI initiators.
ServiceRunning_Resolution=Start the WinTarget service.
ServiceRunning_Compliant=The File and Storage Services Best Practices Analyzer scan has determined that you are in compliance with this best practice.

    # check service is auto-start
ServiceAutoStart_Title=The WinTarget service must start automatically.
ServiceAutoStart_Problem=The WinTarget service Startup Type is not set to Automatic.
ServiceAutoStart_Impact=Upon a machine restart, the WinTarget service will not automatically start. Therefore, iSCSI clients will be unable to connect.
ServiceAutoStart_Resolution=Set the WinTarget service Startup Type to Automatic.
ServiceAutoStart_Compliant=The File and Storage Services Best Practices Analyzer scan has determined that you are in compliance with this best practice.


    # check target access should be restricted
RestrictedTargetAccess_Title=iSCSI target access should be restricted.
RestrictedTargetAccess_Problem=The following iSCSI target has been detected with unrestricted access, with associated iSCSI initiator IQN specified as "*". iSCSI target: {0}
RestrictedTargetAccess_Impact=Assigning "*" as iSCSI initiator IQN, allows any initiator to logon to the iSCSI target and access the associated VHDs.
RestrictedTargetAccess_Resolution=Change the iSCSI initiator assignment from "*" to a specific initiator IQN. Unspecified iSCSI initiators will be unable to logon to the iSCSI target.
RestrictedTargetAccess_Compliant=The File and Storage Services Best Practices Analyzer scan has determined that you are in compliance with this best practice.


    # check all targets should be in use
UnusedTargets_Title=All iSCSI targets should be in use.
UnusedTargets_Problem=The following iSCSI target has no VHD assigned: iSCSI target: {0}
UnusedTargets_Impact=iSCSI targets with no VHD assigned can still connect to the iSCSI initiator, but are not usable.
UnusedTargets_Resolution=Remove any iSCSI targets no longer in use.
UnusedTargets_Compliant=The File and Storage Services Best Practices Analyzer scan has determined that you are in compliance with this best practice.


    # check portals for firewall settings
FirewallOpened_Title=Firewall ports needed by iSCSI target must be open.
FirewallOpened_Problem=The following firewall port needed by iSCSI target is not open: IP:{0} Port:{1}
FirewallOpened_Impact=ISCSI initiators will be unable to access block resources due to blocked network traffic by the firewall.
FirewallOpened_Resolution=Verify all firewall ports needed by iSCSI target are open using Group Policy or Windows Firewall.
FirewallOpened_Compliant=The File and Storage Services Best Practices Analyzer scan has determined that you are in compliance with this best practice.


    # check all nodes are reachable if in a cluster
UnReachableNodesInCluster_Title=All nodes in a failover cluster must be accessible.
UnReachableNodesInCluster_Problem=The following nodes in the failover cluster are not accessible: {0}
UnReachableNodesInCluster_Impact=iSCSI Target Server will be unable to failover to inaccessible nodes: {0}
UnReachableNodesInCluster_Resolution=Verify all cluster nodes are online using the Validate a Configuration Wizard.
UnReachableNodesInCluster_Compliant=The File and Storage Services Best Practices Analyzer scan has determined that you are in compliance with this best practice.


    # check all nodes have service installed and running if in a cluster
ServiceInstallationInCluster_Title=The WinTarget service must be running on all nodes of a failover cluster.
ServiceInstallationInCluster_Problem=The WinTarget service is not running on the following nodes in the failover cluster: {0}
ServiceInstallationInCluster_Impact=The WinTarget service will not function when resources fail over to nodes that do not have the WinTarget service running.
ServiceInstallationInCluster_Resolution=Start the WinTarget service on each node of the failover cluster.
ServiceInstallationInCluster_Compliant=The File and Storage Services Best Practices Analyzer scan has determined that you are in compliance with this best practice.


###PSLOC - End Localization
'@
