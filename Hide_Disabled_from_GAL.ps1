<#
.SYNOPSIS
  Hides disabled users from the GAL

.DESCRIPTION
  Pulls a list of all users that are disabled in AD
  Sets msExchHideFromAddressLists true

.PARAMETER
  $users: A list of all users who are currently disabled in AD

.NOTES
  Version:        1.0
  Author:         Julian Ontiveros
  Creation Date:  April 20, 2017
  Purpose/Change: Initial script development

#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

$username = "<USERNAME>"
$password = cat C:\Users\julian\Documents\WindowsPowerShell\mysecurestring.txt | convertto-securestring
$cred = new-object -typename System.Management.Automation.PSCredential `
    -argumentlist $username, $password

#Find a list of all users where "Enabled" is false (disabled users)
Write-Host "Pulling list of disabled users..."
$users = Get-ADUser -Credential $cred -Filter {Enabled -eq $false}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

#Replace the msExchHideFromAddressLists attribute with True
Write-Host "Changing attribute to hide from address lists..."
foreach($user in $users){
    Set-ADUser -Identity $user.objectGUID -replace @{msExchHideFromAddressLists=$true} -Credential $cred 
}

Write-Host "All done!"