Add-PSSnapin VMware.VimAutomation.Core
If ($globale:DefaultVIServers ) {
	Disconnect-VIServer -Server $global:DefaultVIServers -Force
	}

$sourceVI = Read-Host "Please enter name or IP address of the source Server"
$datacenter = Read-Host "DataCenter naam in VC"
$creds = get-credential
connect-viserver -server $sourceVI -Credential $creds

$report = @()
$report = Get-CustomAttribute -TargetType VirtualMachine 
$report | Export-Csv "c:\csv-files\01-$($datacenter)-attributes.csv" -NoTypeInformation

Disconnect-VIServer "*" -Confirm:$False




