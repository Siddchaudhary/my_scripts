# Stoppen alle VMs
Add-PSSnapin VMware.VimAutomation.Core
If ($globale:DefaultVIServers -eq ""  ) {
	Disconnect-VIServer -Server $global:DefaultVIServers -Force
	}

 $destVI = Read-Host "Please enter name or IP address of the destination Server"
 $datacenter = Read-Host "DataCenter naam in VC"
 $creds = get-credential
 connect-viserver -server $destVI -Credential $creds
 

$report =@()
get-vm | % {
for($i = 0; $i -lt $_.CustomFields.Count; $i ++ ){
		$row = "" | Select VMname, FieldKey, FieldValue
		
		if ( $_.CustomFields.Keys[$i] -eq "BootPriority" ) {
			$row.VMname = $_.Name
			$row.FieldKey = $_.CustomFields.Keys[$i]
			$row.FieldValue = $_.CustomFields.Values[$i]
			$report += $row
			}
	}
}

$SortReport = $report | sort FieldValue 
Write-Host "Uitvoer v sort report" 
$SortReport

$vm = @()
Foreach( $vm in $SortReport) {
		
		Write-Host $vm.VMname | Get-View
		Start-VM -VM $vm.VMname -Confirm:$false
		}


Disconnect-VIServer "*" -Confirm:$False