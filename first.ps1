# story line: review the security event log
# Directory to save files:
$myDir = "C:\Users\Silent_Desktop\Documents\Sys 320\"

#list all the avalible windows event logs
Get-EventLog -list 

# Create a promp to allow user to select the log to view
$readLog = Read-host -Prompt "please select a log to review from the list above"

# Create a prompt to allow user to select what to search
$toSearch = Read-host -Prompt "please enter in your keyword or phrase to search "

# Print the results for the log
Get-EventLog -Logname $readLog -Newest 40 | where {$_.Message -ilike "*$toSearch*" } | export-csv -NoTypeInformation `
-Path "$myDir\securityLogs.csv"
