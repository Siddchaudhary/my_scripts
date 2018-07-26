$report = @()
$vms = Get-VM

Foreach( $vm in $vms) {

	$RPool = Get-ResourcePool -VM $vm.Name
	
	$row = "" | Select VMname,  RPoolName
	$row.VMname = $vm.Name
	$row.RPoolName = $RPool.Name
	$report += $row
	
	}

$report | Export-Csv "c:\csv-files\02-$($datacenter)-resourcepools-with-vms.csv" -NoTypeInformation





