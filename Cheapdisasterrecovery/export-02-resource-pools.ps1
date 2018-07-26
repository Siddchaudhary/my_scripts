Add-PSSnapin VMware.VimAutomation.Core
If ($globale:DefaultVIServers ) {
	Disconnect-VIServer -Server $global:DefaultVIServers -Force
	}

$sourceVI = Read-Host "Please enter name or IP address of the source Server"
$datacenter = Read-Host "DataCenter name in VC"
$creds = get-credential
connect-viserver -server $sourceVI -Credential $creds

$report = @()
$report = Get-ResourcePool 
$report | Export-Clixml "c:\Temp\02-$($datacenter)-resourcepools.xml"

Disconnect-VIServer "*" -Confirm:$False
