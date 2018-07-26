Add-PSSnapin VMware.VimAutomation.Core
If ($global:DefaultVIServers) {
	Disconnect-VIServer -Server $global:DefaultVIServers -Force
	}

$destVI = Read-Host "Please enter name or IP address of the DESTINATION Server"
$datacenter = Read-Host "DataCenter of destination vCenter"
$creds = get-credential
connect-viserver -server $destVI -Credential $creds

$report = @()
$report = Import-Csv "c:\csv-files\01-$($datacenter)-attributes.csv"
foreach ($CustAttrib in $report){
	New-CustomAttribute -Name $CustAttrib.Name -TargetType $CustAttrib.TargetType
	
	}

Disconnect-VIServer "*" -Confirm:$False



	


