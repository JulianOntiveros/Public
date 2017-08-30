<#
.SYNOPSIS
  Reboot servers (from a list) at 3am the next day
  Works well with the Servers_Pending_Reboot.ps1 script

.DESCRIPTION
  Path file must be updated first
  Script checks for a file from the given path
  Servers are then scheduled to reboot at 3:00 am the next day

.PARAMETERS
  $server: Input found from given path
  $rebootTime: Add one day to today (defaults to 12:00am midnight) then add three hours (3:00am)

.INPUTS
  None

.OUTPUTS
  None

.NOTES
  Version:        1.0
  Author:         Julian Ontiveros
  Creation Date:  April 6, 2017
  Purpose/Change: Initial script development

#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

$servers = Get-Content -path "C:\Users\julian\Desktop\reboot.txt"
$rebootTime = (Get-Date).AddDays(1).Date.AddHours(3)

#-----------------------------------------------------------[Execution]------------------------------------------------------------ 

ForEach($server in $servers){
    
    shutdown -r -m $server -t ([decimal]::round(((Get-Date).AddDays(1).Date.AddHours(3) - (Get-Date)).TotalSeconds))
}