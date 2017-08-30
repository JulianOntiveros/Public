<#
.SYNOPSIS
  Connect to O365

.DESCRIPTION
  1. Combines username and password into a $cred credential
  2. Connect to O365 subscription with Connect-MsolService
  3. Create a new PSSession on the O365 Exchange Center
  4. Import that PSSession into your own local PSSession

.PARAMETERS
  $username: Username of person connecting to O365
  $password: Secure string of password.
    Created by following http://stackoverflow.com/questions/6239647/using-powershell-credentials-without-being-prompted-for-a-password
  $cred: Combining the $username and $password into a single parameter
    Created by following http://stackoverflow.com/questions/6239647/using-powershell-credentials-without-being-prompted-for-a-password
  $Session: Create a PSSession to O365  

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

$username = "<username>@<domain.com>"
$password = cat C:\Users\julian\Documents\WindowsPowerShell\mysecurestring_julian.txt | convertto-securestring
$cred = new-object -typename System.Management.Automation.PSCredential `
    -argumentlist $username, $password

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Connect-MsolService -Credential $cred

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $cred -Authentication Basic -AllowRedirection

Import-PSSession $Session