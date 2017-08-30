#requires -version 5
<#
.SYNOPSIS
  Script that needs to be run when terminating a user account

.DESCRIPTION
  Script performs the following actions:
    1. Prompt for username of person to disable
	  2. Prompt for username of person to grant email access
    3. Remove all group membership from user
	  4. Change user description to "Termination Date: $date"
    5. Disable AD account
    6. Move AD account to Terminated Users OU
    7. Reset account password to randomly generated password
    8. Hide user from Exchange Address Lists
    9. Grants email rights to prompted user in O365
	  10. Remove user from all shared mailboxes
	  11. Change O365 license to Exchange Online license

.PARAMETER
	$pass: Randomly generated password
	$Username: Username of person being terminated
	$MailboxRights: Username of person being granted full access to mailbox
	$Date: Todays date, formatted M/DD/YYYY
	$Cred: Credential for modifying Active Directory attributes
  $Access: What level of access to look for, in the shared mailboxes of $Username
	$Mailboxes: Pull the list of all mailboxes in O365, then filter for $Username's permissions

.NOTES
  Version:        1.1
  Author:         Julian Ontiveros
  Creation Date:  5/3/2017
  Purpose/Change: Added Item 8
  
#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

Add-Type -AssemblyName System.Web
$pass = [System.Web.Security.Membership]::GeneratePassword(8,2)
$Username = Read-Host 'Username to disable.....(in username form e.g. JSmith)'
$MailboxRights = Read-Host 'Who to grant email permissions to.....(in username form e.g. JSmith) - press [enter] for none'
$Date = Get-Date -format d
$Cred = Get-Credential -Message 'Enter credentials for connecting to AD (in the form cb\JSmith)'

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Import-Module ActiveDirectory

# Remove group membership from user account
Write-Host "Removing AD Groups..."
Get-ADPrincipalGroupMembership -Credential $Cred -Identity $Username | % {Remove-ADPrincipalGroupMembership -Identity $Username -MemberOf $_ -Confirm:$False};

# Change user description to "Termination Date"
Write-Host "Adding terminate date to description..."
Set-ADUser -Credential $Cred $Username -Description "Termination Date: $date";

# Disable AD account, then move user to Terminated Users OU
Write-Host "Disabling account and moving to Terminated Users OU..."
Get-ADUser -Credential $Cred $Username | Disable-ADAccount -PassThru | Move-ADObject -TargetPath "<TERMINATED OU PATH> E.G. OU=Terminated Users,OU=COMPANY";

# Hide user from Exchange Address Lists
Write-Host "Hiding user from Exchange Address Lists..."
Set-ADUser -Identity $user.objectGUID -replace @{msExchHideFromAddressLists=$true};

# Scramble AD password
Write-Host "Scrambling password..."
Set-ADAccountPassword -Credential $Cred $Username -reset -newpassword (ConvertTo-SecureString -AsPlainText $pass -Force)

# Connect to O365
& '.\Connect to O365.ps1'

# Grant Full Access mailbox rights to prompted user
Write-Host "Adding $MailboxRights to mailbox permissions..."
Add-MailboxPermission $Username@celticbank.com -User $MailboxRights -AccessRights FullAccess -InheritanceType All -Automapping $false

# Remove user from all shared mailboxes
Write-Host "Removing user from all shared mailboxes...(this step can take 5 minutes)"
$Access = "FullAccess"
$Mailboxes = Get-mailbox -ResultSize "unlimited" | Get-MailboxPermission -User $Username | 
             ? { ($_.AccessRights.ToString() -ne "NT AUTHORITY\SELF") -and ($_.Identity -notlike $Username) -or ($_.AccessRights.ToString() -eq "FullAccess") } |
             Select Identity, User
             
# Exports each mailbox access to a temporary csv file, then uses the csv to remove rights, and deletes the csv
ForEach ($Mailbox in $Mailboxes) 
    {
        $Mailboxes | Export-Csv "c:\temp\permcsv.csv" -nti      
        $RemovePerms = Import-csv "c:\temp\permcsv.csv"

        ForEach ($ID in $RemovePerms) 
            {
                $ID.Identity
                $ID.User
                     
                Remove-MailboxPermission -Identity $ID.Identity -User $ID.User -AccessRights $Access -InheritanceType All -confirm:$false
      }

                Remove-Item "c:\temp\permcsv.csv" -force
}

# Change O365 license to Exchange Online
Write-Host "Changing License from Office 365 to Exchange Online"
Set-MsolUserLicense -UserPrincipalName "$username@DOMAIN.com" -RemoveLicenses "COMPANYID:ENTERPRISEPACK" -AddLicenses "COMPANYID:EXCHANGESTANDARD"


Write-Host "Done!"