param(
    [string] $vcenter,
    [string] $cluster,
    [string] $oldpg,
    [string] $newpg,
    [string] $vlan )

# Add the VI-Snapin if it isn't loaded already
if ( (Get-PSSnapin -Name "VMware.VimAutomation.Core" -ErrorAction SilentlyContinue) -eq $null )
{
    Add-PSSnapin -Name "VMware.VimAutomation.Core"
}

if ( !($vcenter) -or !($cluster) -or !($oldpg) -or !($newpg) -or !($vlan) )
{
    Write-Host `n "rename-pg.ps1: <vcenter-server> <cluster> <oldpg> <newpg>" `n
    Write-Host "This script renames each port group with the name <oldpg> to <newpg>" `n
    Write-Host "   <vcenter-server>  - DNS name of your vCenter server." `n
    Write-Host "   <cluster>         - Display-Name of the vCenter cluster, on which we are"
    Write-Host "                       gonna create the new portgroup." `n
    Write-Host "   <oldpg>           - Name of the old portgroup that is to be replaced (ie VLAN2)." `n
    Write-Host "   <newpg>           - Name of the new portgroup (ie PG-VLAN2-Production)." `n
    Write-Host "   <vlan>            - VLAN-ID for the new port group." `n
    exit 1
}

Connect-VIServer -Server $vcenter

Get-Cluster $cluster | Get-VMHost | Get-VirtualSwitch -Name "vSwitch0" | `
	New-VirtualPortGroup -Name $newpg -VlanId $vlan
Get-Cluster $cluster | Get-VM | Get-NetworkAdapter | Where { $_.NetworkName -eq "$oldpg" } | `
	Set-NetworkAdapter -NetworkName $newpg -Confirm:$false
Get-Cluster $cluster | Get-VMHost | %{Get-View (Get-View $_.ID).configmanager.networkSystem} | %{$_.RemovePortGroup($oldpg)}

Disconnect-VIServer -server $vcenter -Confirm:$false
