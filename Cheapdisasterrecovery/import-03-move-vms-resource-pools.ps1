Add-PSSnapin VMware.VimAutomation.Core
If ($globale:DefaultVIServers) {
	Disconnect-VIServer -Server $global:DefaultVIServers -Force
	}

$destVI = Read-Host "Please enter name or IP address of the DESTINATION Server"
$datacenter = Read-Host "DataCenter van destination vCenter"
$creds = get-credential
connect-viserver -server $destVI -Credential $creds


##IMPORT FOLDERS
$vmpools = @()
$vmpools = Import-Csv "c:\csv-files\02-$($datacenter)-resourcepools-with-vms.csv" | Sort-Object -Property Path
$vm=@()

ForEach( $vm in $vmpools ) {

	Move-VM -VM (Get-vm $vm.vmname) -Destination (Get-ResourcePool $vm.RPoolName)
	}

Disconnect-VIServer "*" -confirm:$false

