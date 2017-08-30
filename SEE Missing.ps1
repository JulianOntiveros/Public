<#
.SYNOPSIS
  Query SCCM Device Collection to find which computers are missing SEE (Symantec Endpoint Encryption)

.DESCRIPTION
  Reaches out to cbsCM01 and queries the device collection specified
  **This script is automatically run from cbsCM01 as a scheduled task every Sunday at 11:59pm

.PARAMETERS
  $SiteServer: cbsCM01, the Configuration Manager site server
  $SiteCode: our Configuration Manager site code
  $Collection: Specify which collection you want to query from
  $Date: Todays date, formatted for the file name

.INPUTS
  Specify the Collection Name you would like to query using $CollectionName

.OUTPUTS
  Outputs a .txt file with the list

.NOTES
  Version:        1.0
  Author:         Julian Ontiveros
  Creation Date:  April 7, 2017
  Purpose/Change: Initial script development

.EXAMPLE
  Example output file:
    Name                                                                                                                   
    ----                                                                                                                   
    PC01
    PC02
    PC03  
  
#>

#---------------------------------------------------------[Script Parameters]------------------------------------------------------

$SiteServer = '<SMSSITESERVER>'
$SiteCode = '<SMSSITECODE>'
$CollectionName = 'SEE Missing (non Apple)'
$Date = Get-Date -f D

#-----------------------------------------------------------[Execution]------------------------------------------------------------
	
# Load Configuration Manager module
Import-Module "F:\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"
# Change to the site code
cd <SMSSITECODE>

#Query $CollectionName for list of computers and output it
Get-CMDevice -CollectionName $CollectionName | Select -Property Name | Out-File "filesystem::<FILELOCATION>\Laptops missing SEE (non-Apple) as of $date.txt"