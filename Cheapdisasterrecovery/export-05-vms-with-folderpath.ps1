Add-PSSnapin VMware.VimAutomation.Core
If ($globale:DefaultVIServers) {
	Disconnect-VIServer -Server $global:DefaultVIServers -Force
	}

$sourceVI = Read-Host "Please enter name or IP address of the source Server"
$datacenter = Read-Host "DataCenter name in source vCentern"
$creds = get-credential
connect-viserver -server $sourceVI -Credential $creds


filter Get-FolderPath {
    $_ | Get-View | % {
        $row = "" | select Name, Path
        $row.Name = $_.Name

        $current = Get-View $_.Parent
        $path = $_.Name
        do {
            $parent = $current
            if($parent.Name -ne "vm"){$path = $parent.Name + "\" + $path}
            $current = Get-View $current.Parent
        } while ($current.Parent -ne $null)
        $row.Path = $path
        $row
    }
}


##Export all VM locations
$report = @()
$report = get-datacenter $datacenter -Server $sourceVI| get-vm | Get-Folderpath
$report | Export-Csv "c:\csv-files\04-$($datacenter)-vms-with-FolderPath.csv" -NoTypeInformation

Disconnect-VIServer "*" -Confirm:$False  
