param(
    [string] $vcenter,
    [string] $switch,
    [string] $oldpg,
    [string] $newpg,
    [string] $vlan )

# Add the VI-Snapin if it isn't loaded already
if ( (Get-PSSnapin -Name "VMware.VimAutomation.Core" -ErrorAction SilentlyContinue) -eq $null )
{
    Add-PSSnapin -Name "VMware.VimAutomation.Core"
    Add-PSSnapin -Name "VMware.VimAutomation.Vds"
}

if ( !($vcenter) -or !($switch) -or !($oldpg) -or !($newpg) -or !($vlan) )
{
    Write-Host `n "rename-pg.ps1: <vcenter-server> <cluster> <switch> <oldpg> <newpg>" `n
    Write-Host "This script renames each port group with the name <oldpg> to <newpg>" `n
    Write-Host "   <vcenter-server>  - DNS name of your vCenter server." `n
    Write-Host "   <switch>          - Name of distributed switch where you want to modify the portgroups." `n
    Write-Host "   <oldpg>           - Name of the old portgroup that is to be replaced (ie VLAN2)." `n
    Write-Host "   <newpg>           - Name of the new portgroup (ie PG-VLAN2-Production)." `n
    Write-Host "   <vlan>            - VLAN-ID for the new port group." `n
    exit 1
}

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