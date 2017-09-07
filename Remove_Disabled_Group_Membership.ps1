<#
.SYNOPSIS
  Removes the AD group membership for each disabled user

.PARAMETER
  $cred - prompt for AD credentials for modifying groups in AD
  $Users - list of all users that are not enabled
    Generated by running: Get-ADUser -Credential $cred -Filter {Enabled -eq $false} | select-object Samaccountname | out-file disabledusers.txt

.NOTES
  Version:        1.2
  Author:         Julian Ontiveros
  Creation Date:  Sept 6, 2017
  Purpose/Change: Updated script to pull ADUser properties from $users

#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

#Script Parameters go here
$Cred = Get-Credential -Message 'Enter credentials for connecting to AD (in the form cb\JSmith)'
$users = ForEach ($user in $(Get-Content C:\temp\disabledusers.txt)) 
  {
      Get-AdUser $user -Properties memberof
  }

#-----------------------------------------------------------[Execution]------------------------------------------------------------

#Script Execution goes here

Import-Module ActiveDirectory

Write-Host "Removing AD Groups..."

ForEach ($User in $Users) 
{
  $user.memberof | ForEach-Object { Remove-ADGroupMember -Identity $_ -Members $user.samaccountname -Confirm:$false};
}