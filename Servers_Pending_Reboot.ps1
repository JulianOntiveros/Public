#requires -version 5
<#
.SYNOPSIS
  Output a list of all servers that are pending a reboot
  Works well with the Reboot_3am_Pull_from_Script.ps1 script

.DESCRIPTION
  Import Active Directory
  Generate a list of all servers (query based on OU)
  Search for the specific registry key 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' value 'PendingFileRenameOperations'
  Output the servers containing that registry key
  The .csv can then be imported into Reboot_3am_Pull_from_Script.ps1

.PARAMETERS
  $filename: Get the name of this file
  $servers: Query to find the servers in AD, based on OS
  $path: Registry key path
  $name: Registry key value

.INPUTS
  None

.OUTPUTS
  Outputs .csv file

.NOTES
  Version:        1.0
  Author:         Julian Ontiveros
  Creation Date:  April 7, 2017
  Purpose/Change: Initial script development

#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

Import-Module ActiveDirectory

$filename = [io.path]::GetFileNameWithoutExtension($path)

$servers = Get-ADComputer -Filter * -Properties operatingsystem |
	where operatingsystem -match 'server' |
	select name
	
$path = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager'
$name = 'PendingFileRenameOperations'

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Invoke-command -ComputerName $servers.name -Ea 0 -ScriptBlock {
	Get-ItemProperty -Path $using:path -Name $using:name} |
	
 Select-Object pscomputername | Out-File "<FILE SAVE LOCATION>\Servers_Pending_Reboot.csv"