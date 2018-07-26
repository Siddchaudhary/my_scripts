Add-PSSnapin VMware.VimAutomation.Core
If ($globale:DefaultVIServers) {
	Disconnect-VIServer -Server $global:DefaultVIServers -Force
	}

$sourceVI = Read-Host "Please enter name or IP address of the source Server"
$datacenter = Read-Host "DataCenter name of source vCenter"
$creds = get-credential
connect-viserver -server $sourceVI -Credential $creds

##Export VM Custom Attributes and notes

$vmlist = get-datacenter $datacenter -Server $sourceVI| get-vm 
$Report =@()
    foreach ($vm in $vmlist) {
        $row = "" | Select Name, Notes
        $row.name = $vm.Name
		$row.Notes = $vm | select Notes
        $Report += $row
    }

$report | Export-Csv "c:\csv-files\06-$($datacenter)-notes-of-VMs.csv" -NoTypeInformation
  
Disconnect-VIServer "*" -Confirm:$False  
