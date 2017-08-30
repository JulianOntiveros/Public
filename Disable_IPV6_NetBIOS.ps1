<#
.SYNOPSIS
  Disable IPV6 and NetBIOS on all adapters
  

.DESCRIPTION
  Script is applied via GPO to all servers, and runs during logon

.NOTES
  Version:        1.0
  Author:         Julian Ontiveros
  Creation Date:  April 6, 2017
  Purpose/Change: Initial script development
#>

#-----------------------------------------------------------[Execution]------------------------------------------------------------

# Disable IPV6 on all adapters with the word ethernet in the name
# This will un-check the box under Ethernet properties named 'Internet Protocol Version 6 (TCP/IPv6)'
Disable-NetAdapterBinding -Name "*ethernet*" -ComponentID ms_tcpip6

# Disable NetBIOS on all adapters with the word ethernet in the description
# Goes into the Advanced Properties of TCP/IPv4 and changes the NetBIOS setting to 'Disable NetBIOS over TCP/IP'
$adapter = Get-WmiObject Win32_NetworkAdapterConfiguration |  Where Description -like "*Ethernet*"
$adapter.SetTcpIPNetbios(2)