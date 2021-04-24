######################### List/kill VMs
esxcli vm process list
esxcli vm process kill --type= [soft,hard,force] --world-id= WorldNumber
esxcli vm process kill -t=soft -w=WorldID
esxcli vm process kill -t=hard -w=WorldID
esxcli vm process kill -t=force -w=WorldID

#Using the ESXi command-line utility vim-cmd to power off the virtual machine

#On the ESXi console, enter Tech Support mode and log in as root.
#For more information, see Tech Support Mode for Emergency Support (1003677).

######################### Get a list of all registered virtual machines

vim-cmd vmsvc/getallvms
 
######################### Get virtual machine state

vim-cmd vmsvc/power.getstate VMID
 
######################### Shutdown virtual machines

vim-cmd vmsvc/power.shutdown VMID

#Note: If the virtual machine fails to shut down, run this command:

vim-cmd vmsvc/power.off VMID


######################### HOST UPGRADE #########################

# Set maintenance mode
esxcli system maintenanceMode set –enable true

# List images in offline bundle
esxcli software sources profile list -d /vmfs/volumes/datastore1/VMware-ESXi-7.0.0-15843807-depot.zip

# Upgrade ESXi
esxcli software profile update -d /vmfs/volumes/datastore1/VMware-ESXi-7.0.0-15843807-depot.zip -p <ESXi Image Name>
esxcli software profile update -d /vmfs/volumes/datastore1/VMware-ESXi-7.0.0-15843807-depot.zip -p ESXi-7.0.0-15843807-standard

#BAD: esxcli software vib update -d /vmfs/volumes/datastore1/VMware-ESXi-7.0.0-15843807-depot.zip -p ESXi-7.0.0-15843807-standard

################################################################

######################### ENABLE USB DRIVERS

esxcli software component apply -d /vmfs/volumes/5c7c8eb2-dfb3e413-3690-001fbc0f29c1/_SOFTWARE/VMWare/USBNIC/ESXi701-VMKUSB-NIC-FLING-40599856-component-17078334.zip
/vmfs/volumes/5c7c8eb2-dfb3e413-3690-001fbc0f29c1/_SOFTWARE/VMWare/USBNIC/ESXi701-VMKUSB-NIC-FLING-40599856-component-17078334.zip

######################### ENABLE/DISABLE FIREWALL

esxcli network firewall set --enabled false
esxcli network firewall set --enabled true

######################### LIST NIC

esxcli network nic list

######################### iperf3 Syntax

#server:
iperf3.copy -s -i 10 --bind <ip address> --port <port#> -V

#client:
iperf3 -i 5 -t 30 -p <port#> --bidir --get-server-output -c <ip address>
iperf3 -V -i 10 -t 300 -p <port#> --parallel 4 --bidir --get-server-output -c <ip address>


######################### Output host storage devices

esxcli storage core device list | grep '  Display Name:' | sed 's/ *Display Name: //'


######################## Storage Drivers / Firmware

#identify driver name used:

esxcli storage core adapter list

#This to identify installed driver version:

for a in $(esxcfg-scsidevs -a | awk '{print $2}'); do echo $a\t$(vmkload_mod -s $a | grep -i version); done

#To identify controller firmware You can do this:

ls -al /proc/scsi

mptspi <-- directory for LSI SAS Controller

qla#### <-- QLogic HBA, #### is the model of the HBA

lpfc <-- Emulex HBA

ls -a /proc/scsi/qla2340/

head -2 2

#QLogic PCI to Fibre Channel Host Adapter for QLA2340 :

Firmware version: 3.03.19, Driver version 7.07.04.2vmw

# Identify HBA vendor information:

esxcli storage core adapter list | awk '{print $1}' | grep [0-9] | while read a; do vmkchdev -l | grep $a; done

