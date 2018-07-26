Add-PSSnapin VMware.VimAutomation.Core
If ($globale:DefaultVIServers) {
	Disconnect-VIServer -Server $global:DefaultVIServers -Force
	}

$destVI = Read-Host "Please enter name or IP address of the DESTINATION Server"
$datacenter = Read-Host "DataCenter van destination vCenter"
$creds = get-credential
connect-viserver -server $destVI -Credential $creds


##IMPORT FOLDERS
$vmfolder = Import-Csv "c:\csv-files\03-$($datacenter)-Folders-with-FolderPath.csv" | Sort-Object -Property Path

foreach($folder in $VMfolder){
    $key = @()
    $key =  ($folder.Path -split "\\")[-2]
    if ($key -eq "vm") {
        get-datacenter $datacenter -Server $destVI | get-folder vm | New-Folder -Name $folder.Name
        } else {
        get-datacenter $datacenter -Server $destVI | get-folder vm | get-folder $key | New-Folder -Name $folder.Name 
        }
}


Disconnect-VIServer "*" -confirm:$false
    
