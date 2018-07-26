Add-PSSnapin VMware.VimAutomation.Core
If ($globale:DefaultVIServers) {
	Disconnect-VIServer -Server $global:DefaultVIServers -Force
	}

$sourceVI = Read-Host "Please enter name or IP address of the source Server"
$datacenter = Read-Host "DataCenter naam in VC"
$creds = get-credential
connect-viserver -server $sourceVI -Credential $creds

$report =@()
get-vm | % {
	for($i = 0; $i -lt $_.CustomFields.Count; $i ++ ){
		$row = "" | Select VMname, FieldKey, FieldValue
		$row.VMname = $_.Name
		$row.FieldKey = $_.CustomFields.Keys[$i]
		$row.FieldValue = $_.CustomFields.Values[$i]
		$report += $row
	}
}

$report | Export-Csv "c:\csv-files\07-$($datacenter)-attributes-of-VMs.csv" -NoTypeInformation


Disconnect-VIServer "*" -Confirm:$False