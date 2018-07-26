Add-PSSnapin VMware.VimAutomation.Core
If ($globale:DefaultVIServers) {
	Disconnect-VIServer -Server $global:DefaultVIServers -Force
	}

$destVI = Read-Host "Please enter name or IP address of the DESTINATION Server"
$datacenter = Read-Host "DataCenter van destination vCenter"
$clustername = Read-Host "Cluster naam"
$creds = get-credential
connect-viserver -server $destVI -Credential $creds

$cluster = Get-ResourcePool -Location ( Get-Cluster $clustername ) -Name Resources
$report = Import-Clixml "c:\Temp\02-$($datacenter)-resourcepools.xml"
foreach ($ResPool in $report){
	If ( $ResPool.Name -ne $cluster.Name ) {
		New-ResourcePool -Location $cluster `
			-Name ($ResPool.Name) `
			-CpuExpandableReservation ($ResPool.CpuExpandableReservation) `
			-CpuLimitMhz ($ResPool.CpuLimitMHz) `
			-CpuReservationMhz ($ResPool.CpuReservationMHz) `
			-CpuSharesLevel ($ResPool.CpuSharesLevel) `
			-MemExpandableReservation ($ResPool.MemExpandableReservation) `
			-MemLimitMB ($ResPool.MemLimitMB) `
			-MemReservationMB ($ResPool.MemReservationMB) `
			-MemsharesLevel ($ResPool.MemSharesLevel)	
		}
}

Disconnect-VIServer "*" -Confirm:$False

