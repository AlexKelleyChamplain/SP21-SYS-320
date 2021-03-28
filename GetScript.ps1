#storyline: Using the get-service and get-process
Get-Service |Select ServiceName| Export-Csv -Path "C:\Users\Silent_Desktop\Documents\Sys320\week327\New folder\MyServices.csv" -NoTypeInformation
Get-Process |Select ProcessName| Export-Csv -Path "C:\Users\Silent_Desktop\Documents\Sys320\week327\New folder\MyProcesses.csv" -NoTypeInformation
