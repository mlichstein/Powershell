rename-pg.ps1
==========
This script will rename an existing distributed switch portgroup. It creates a new portgroup, moves all interfaces from the old portgroup to the new portgroup, and then deletes the old portgroup.

The script will prompt for the following:  
**vCenter Name**: The name of the vCenter instance with the switch you want to modify.  
**Switch Name**: The name of the VMWare distributed virtual switch.  
**Old Portgroup**: The name of the portgroup that you want to remove.  
**New Portgroup**: The name of the portgroup that you want to create.  
**VLAN**: The VLAN number for the new portgroup.  