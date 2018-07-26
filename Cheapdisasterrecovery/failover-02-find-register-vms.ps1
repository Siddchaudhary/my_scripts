Add-PSSnapin VMware.VimAutomation.Core
If ($globale:DefaultVIServers ) {
	Disconnect-VIServer -Server $global:DefaultVIServers -Force
	}

$sourceVI = Read-Host "Please enter name or IP address of the source Server"
$datacenter = Read-Host "DataCenter naam in VC"
$vSphereHost = Read-Host "Welke ESX host worden de VMs op geregistreerd"
$Cluster = Read-Host "Welke Cluster worden de VMs in geplaatst"
$creds = get-credential
connect-viserver -server $sourceVI -Credential $creds

$folder = Get-View (Get-Datacenter -Name $DataCenter | Get-Folder -Name "vm").ID
$pool = Get-View (Get-Cluster -Name $Cluster | Get-ResourcePool -Name "Resources").ID
$guestname = [regex]"^([\w]+).vmx"
 
$esxImpl = Get-VMHost -Name $vSphereHost
$esx = Get-View $esxImpl.ID 
$dsBrowser = Get-View $esx.DatastoreBrowser
foreach($dsImpl in $dsBrowser.Datastore){
  $ds = Get-View $dsImpl
  $vms = @()
  foreach($vmImpl in $ds.Vm){
    $vm = Get-View $vmImpl
    $vms += $vm.Config.Files.VmPathName
  }
  $datastorepath = "[" + $ds.Summary.Name + "]"
  
  $searchspec = New-Object VMware.Vim.HostDatastoreBrowserSearchSpec
  $searchSpec.matchpattern = "*.vmx"
 
  $taskMoRef = $dsBrowser.SearchDatastoreSubFolders_Task($datastorePath, $searchSpec) 
  $task = Get-View $taskMoRef 
  while ($task.Info.State -eq "running"){$task = Get-View $taskMoRef}
 
  foreach ($file in $task.info.Result){
    $found = $FALSE
    foreach($vmx in $vms){
      if(($file.FolderPath + $file.File[0].Path) -eq $vmx){
        $found = $TRUE
      }
    }
    if (-not $found -and $file.File -ne $null){
      $vmx = $file.FolderPath + $file.File[0].Path
      $res = $file.File[0].Path -match $guestname
      $folder.RegisterVM_Task($vmx,$matches[1],$FALSE,$pool.MoRef,$null)	
    }
  }
}

Disconnect-VIServer "*" -Confirm:$False
