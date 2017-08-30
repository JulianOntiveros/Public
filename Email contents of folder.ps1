<#
.SYNOPSIS
  Email folder contents

.DESCRIPTION
  Crawl through $Files and email each one to $MailTo, then move each $File to the new destination

.PARAMETERS
  $SmtpServer: Office 365 SMTP server
  $SmtpUser: User that will be used to email the script
  $Files: Location of the files that will be sent
  $Mailto: Who to email each file to
  $MailFrom: Who the email will come from
  $OFS: Formatting to add spaces in body
  $Body: Simple body of email
  $FileName: Discovered so the email subject can be the name of the file

.NOTES
  Version:        1.1
  Author:         Julian Ontiveros
  Creation Date:  April 6, 2017
  Purpose/Change: Remove credentials, run script without authentication
#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

$SmtpServer = '<SMTPSERVER>'
$SMTPUser = '<SMTPUSERNAME>'
$Files = (Get-ChildItem "<FILE LOCATION PATH>" | Select-Object FullName).FullName
$MailtTo = '<RECIPIENTUSER>'
$MailFrom = '<SMTPUSERNAME>'
$OFS = "`r`n`r`n"
$Body = "This message was created automatically" + $OFS + "Please report any errors or incorrect computers to the Sysadmin team"

#-----------------------------------------------------------[Execution]------------------------------------------------------------

Foreach($File in $Files){

	$FileName = Get-ChildItem $File | select-object -ExpandProperty Name `

	Send-MailMessage `
		-To "$MailtTo" `
		-from "$MailFrom" `
		-Subject $FileName `
		-SmtpServer $SmtpServer `
		-UseSsl `
		-Attachment $File `
		-Body $Body

    Move-Item -Path $File -Destination "<ITEM MOVE PATH>"
}
 