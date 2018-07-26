Add-PSSnapin VMware.VimAutomation.Core
If ($globale:DefaultVIServers ) {
	Disconnect-VIServer -Server $global:DefaultVIServers -Force
	}

$destVI = Read-Host "Please enter name or IP address of the destination Server"
$datacenter = Read-Host "DataCenter naam in VC"
$creds = get-credential
connect-viserver -server $destVI -Credential $creds


# move the vm's to correct location
$VMfolder = @()
$VMfolder = import-csv "c:\csv-files\04-$($datacenter)-vms-with-FolderPath.csv" | Sort-Object -Property Path


foreach($guest in $VMfolder){
	$key = @()
	$key =  Split-Path $guest.Path | split-path -leaf
	if ($key -eq $datacenter) {
		Write-Host "Root folder $guest.path"
		## 
		Move-VM (Get-VM $guest.Name) -Destination "vm"
		}
		else
		{
		Move-VM (Get-VM $guest.Name) -Destination (Get-folder $key) 
		}
}


Disconnect-VIServer "*" -Confirm:$False