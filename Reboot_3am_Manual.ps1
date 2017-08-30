<#
.SYNOPSIS
  Receive user-inputted server name to reboot the next day

.DESCRIPTION
  Script prompts user to enter a server name
  Server is then scheduled to reboot at 3:00 am the next day

.PARAMETERS
  $server: Input received from the user at the console
  $rebootTime: Add one day to today (defaults to 12:00am midnight) then add three hours (3:00am)

.INPUTS
  Requires user to enter a server name to reboot

.OUTPUTS
  None

.NOTES
  Version:        1.0
  Author:         Julian Ontiveros
  Creation Date:  April 6, 2017
  Purpose/Change: Initial script development

.EXAMPLE
  Julian@CB-0694-JULTPX1 :> .\Reboot_3am_Manual.ps1
  Enter Server Name: cbswsus
#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

$server = Read-Host 'Enter Server Name'
$rebootTime = (Get-Date).AddDays(1).Date.AddHours(3)

#-----------------------------------------------------------[Execution]------------------------------------------------------------

shutdown -r -m $server -t ([decimal]::round(((Get-Date).AddDays(1).Date.AddHours(3) - (Get-Date)).TotalSeconds))