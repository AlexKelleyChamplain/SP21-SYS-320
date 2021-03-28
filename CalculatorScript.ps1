#storyline: to use powershell to start and stop the calculator process
#start the calculator prosses 
calc

#stops it for 5 sec so we can see it wokr
Start-Sleep -Seconds 5

#stops the calculator prosses
Stop-Process -Name calc
