# Add the VI-Snapin if it isn't loaded already
if ( (Get-PSSnapin -Name "VMware.VimAutomation.Core" -ErrorAction SilentlyContinue) -eq $null )
{
    Add-PSSnapin -Name "VMware.VimAutomation.Core"
    Add-PSSnapin -Name "VMware.VimAutomation.Vds"
}

$vcenter = Read-Host "Enter the vCenter name: "
$switch = Read-Host "Enter the switch name: "
$oldpg = Read-Host "Enter the OLD portgroup name: "
$newpg = Read-Host "Enter the NEW portgroup name: "
$vlan = Read-Host "Enter the VLAN ID for the new portgroup: "

Connect-VIServer -Server $vcenter

#Create new portgroup
Get-VDSwitch -Name $switch | New-VDPortGroup -Name $newpg -VlanId $vlan

#Move VM adapters to new portgroup
$oldpg_temp = Get-VDPortGroup -Name $oldpg
$net_adpaters = Get-NetworkAdapter -RelatedObject $oldpg_temp
Set-NetworkAdapter -NetworkAdapter $net_adpaters -Portgroup $newpg -Confirm:$false

#Delete old portgroup
Get-VDPortGroup -Name $oldpg -VDSwitch $switch | Remove-VDPortGroup -Confirm:$false

Disconnect-VIServer -server $vcenter -Confirm:$false