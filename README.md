rename-pg.ps1
==========
Usage: rename-pg.ps1: <vcenter-server> <cluster> <switch> <oldpg> <newpg>

<vcenter-server>  - DNS name of your vCenter server
<cluster>         - Display-Name of the vCenter cluster, on which we are going to create the new portgroup.
<switch>          - Name of distributed switch where you want to modify the portgroups.
<oldpg>           - Name of the old portgroup that is to be replaced (ie VLAN2).
<newpg>           - Name of the new portgroup (ie PG-VLAN2-Production).
<vlan>            - VLAN-ID for the new port group.

