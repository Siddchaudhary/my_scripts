Add-PSSnapin VMware.VimAutomation.Core
If ($globale:DefaultVIServers ) {
	Disconnect-VIServer -Server $global:DefaultVIServers -Force
	}

$sourceVI = Read-Host "Please enter name or IP address of the source Server"
$datacenter = Read-Host "DataCenter naam in VC"
$creds = get-credential
connect-viserver -server $sourceVI -Credential $creds

##Import VM Custom Attributes and Notes
$NewAttribs = Import-Csv "C:\csv-files\07-$($datacenter)-attributes-of-VMs.csv"

foreach($line in $NewAttribs){

	    Set-CustomField -Entity (get-vm $line.VMName) -Name $line.FieldKey -Value $line.FieldValue -confirm:$false 
		
}
	


Disconnect-VIServer "*" -Confirm:$False