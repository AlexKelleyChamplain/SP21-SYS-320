  
#StoryLine- Incident Response Toolkit

    #Variable for Directory
    $dir = Read-Host -Prompt "Enter the direcroty whenre your information will be saved"
    
    #Input checking directory
    $testPath = Test-Path $dir
    DO {
        if ( !$testPath){
            $dir = Read-Host -Prompt "Enter a directory"
            $testPath = Test-Path $dir
            }
        } while(!$testPath)
    
    #Boolean for input error. 
    $inputerror = "abc".Length -eq 5
    #Variable for the Hash Function
    DO {
        $hash = Read-Host -Prompt "Witch hash algorith do you want to use? enter in MD4, MD5, SHA1, SHA256 or SHA512"
        #Default value
        if ($hash -like ""){
        $hash = "MD5"
        }
        #Creates an array 
        $hashnames = @("MD4", "MD5", "SHA1", "SHA256", "SHA512")
    
        #checing the hash input
    
            Foreach ($hashname in $hashnames){
                if ($hash = $hashname){
                    $inputerror = "abc".Length -eq 3
                    }
                   }
            } while(!$inputerror)
            

#save files to CSV
Function saveFile($VariableName, $fileName){
    #Renaming- With date and time
    $date = Get-Date -Format "MM-dd-yyyy-HH-mm"
    $exportName = $fileName + "-" + $date
    echo $exportName
    #creates the name
    $path = $dir + "\" + $exportName + ".csv"
    echo $path
    echo $VariableName | Export-Csv -Path $path -NoTypeInformation -ErrorAction Inquire

    #creating variable for the filehash file
    $hashLoc = $dir + "\Hashcheck-" + $date + ".csv"
    Get-FileHash $path | Export-Csv -Path $hashLoc -Append
    }

#Running processes
Function Get-Processes{
    #Assign a value
    $process = @( Get-Process |Select-Object ProcessName, Path )
    #Call save function
    saveFile $process "Processes"
    }
#all registered services 
Function Get-Services{
    #Assign a value
    $service = @( Get-WmiObject win32_service | select DisplayName, State, PathName, Name )
    #Call save function
    saveFile $service "RegisteredServices"
    }

#all TCP network sockets
Function NetTCPConnections{
    #Assign a value 
    $NetTCPConnection = @( Get-NetTCPConnection )
    #Call save function
    saveFile $NetTCPConnection "TcpConnections"
    }

#all user account info
Function UserAccount{
    #Assign a value
    $UserAccount = @( Get-WmiObject -Class Win32_UserAccount )
    #Call save function
    saveFile $UserAccount "AccountInformation"
    }

#All NetworkAdapterConfig info
Function NetAdapter{
    #Assign a value 
    $NetAdapter = @( Get-NetAdapter -Name * -IncludeHidden )
    #Call save function
    saveFile $NetAdapter "NetworkAdapters"
    }



#All LOcation data
Function Location{
    #Assign a value 
    $Location = @(Get-Location )
    #Call save function
    saveFile $Location "Location"
    }
#gets any location data saved on the computers firmaware and its directory location

#All provider
Function provider{
    #Assign a value 
    $provide = @(Get-PSProvider | Format-List )
    #Call save function
    saveFile $provider "PSProvider "
    }
    # gets the PowerShell providers in the current session.

#All packages installed by users
Function Package{
    #Assign a value 
    $Package = @(Get-AppxPackage -AllUserse | Format-List  )
    #Call save function
    saveFile $Package "AppxPackage "
    }

#All event log info
Function event{
    #Assign a value 
    $event = @( Get-Event )
    #Call save function
    saveFile $event "Event"
    }
    #this comand lists all the events that have ocured so you can see what went wrong if there is an error





function MainMenu{
    cls
    echo " main menu"
    $userInput = Read-Host -Prompt "Type q to quit, all to run all tools, list to use a single tool."
    DO {
    if ($userInput -like "q"){
    Exit
    }
    ElseIf ($userInput -like "all"){
    Get-Processes
    Get-Services
    NetTCPConnections
    UserAccount
    NetAdapter
    Get-Location
    Get-PSProvider
    Get-AppxPackage
    Get-Event
    MainMenu
    }
    ElseIf ($userInput -like ""){
    Get-Processes
    Get-Services
    NetTCPConnections
    UserAccount
    NetAdapter
    Get-Location
    Get-PSProvider
    Get-AppxPackage
    Get-Event
    MainMenu
    }
    ElseIf ($userInput -like "list"){
    echo "
    These are the possible tools:
    Get-Processes
    Get-Services
    NetTCPConnections
    UserAccount
    NetAdapter
    Get-Location
    Get-PSProvider
    Get-AppxPackage
    Get-Event
    "
    $inputerror2 = "abc".Length -eq 5
    #Create an array for valid inputs
    $ToolNames = @("Get-Processes", "Get-Services", "NetTCPConnections", "UserAccount", "NetAdapter", "Get-LocationGet", "PSProviderGet", "AppxPackageGet", "Event")
    DO {
        $ToolName = Read-Host -Prompt "what tool do you want to run. press enter to return too main"
        #Default value
        if ($ToolName -like ""){
        MainMenu
        }
        #Loop for checking toolname
    
            Foreach ($tool in $ToolNames){
            #if statement to check if the input is valid
                if ($ToolName = $tool){
                    $inputerror2 = "abc".Length -eq 3
                    }
        }
        } while(!$inputerror2)
   if ($inputerror2){
   Invoke-Expression $ToolName
   }
            
            Else {
            echo "invalid input valid inputs are: *enter, all, q, list"
            sleep 2
            MainMenu
            $Error = "abc".Length -eq 5
            }}
    } While (!$Error)
    }
    
MainMenu
#ssh in
New-SSHSession -ComputerName '192.168.4.50' —Credential (Get-credential alex.kelley@cyber.local)
Set-SCPFile -ComputerName '192.168.4.50' -Credential (Get-credential alex.kelley@cyber.local)
#creates the file
-RemotePath 'c:\Documents' -LocalFile 'C:\Documents\powershell.zip'
#check for file
Get-SCPFile -ComputerName '192.168.4.50' -Credential (Get-credential alex.kelley@cyber.local)