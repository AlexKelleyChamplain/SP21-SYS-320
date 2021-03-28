#use the Get-WMIobject cmdlet
#Get-WmiObject -Class Win32_service | select Name, PathName, ProcessId

#Get-WmiObject -list | where { $_.Name -ilike "win32_*" } | sort-object

#Get-WmiObject -Class Win32_Account | Get-Member

# Task: Grab the network adapter info using the WHMI Class
# Get the IP address, defualt gateway, and the dns servers.
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName .

# expanded info
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName . | Select-Object -Property [a-z]* -ExcludeProperty IPX*,WINS*