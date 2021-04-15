#Storyline - skrip to allow userrs to select the prosses they want to see
function user_input() {
    cls
    # list the event logs
    $theLogs = Get-Service | select Status, Name, DisplayName 
    # Initialize the array to store the logs
    $arrLog = @()
    foreach ($tempLog in $theLogs) {
        # Add each log to the array
        # NOTE: These are stored in the array as a hashtable in the format:
        # @{Log=LOGNAME}
        $arrLog += $tempLog
}
# test to be sure our array is being populated.
#$arrlog
# Prompt the user for the log to view or quit.
    $readLog = read-host -Prompt “Please enter Services to see all services, stopped to see stopped services and running to see only running services. Q to quit"
# Check if the user wants to quit.
    if ($readLog -like “Services") {
    #Stop executing the program and close the script
    Get-Service | select Status, Name, DisplayName
    $count = 1
    }
    if ($readLog -like “stopped") {
    #Stop executing the program and close the script
    Get-Service | Where-Object {$.Status -eq "Stopped"}
    $count = 1
    }
    if ($readLog -like “running") {
    #Stop executing the program and close the script
    Get-Service | Where-Object {$_.Status -eq "Running"}
    $count = 1
    }
    if ($readLog -match “^[qQ]$") {
    #Stop executing the program and close the script
    break
    }
     if ($count -ne 1){
        write-host -Backgroundcolor red -Foregroundcolor white “only all, stopped and running are accepted as commands."
        sleep 2
        user_input
    }
}
user_input