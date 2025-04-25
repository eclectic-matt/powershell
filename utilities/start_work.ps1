
$vpnName = "ANONYMISED";
$user = "ANONYMISED";
$pass = "ANONYMISED";

#ASK IF "CONNECT TO VPN"
$confirmation = Read-Host "Do you want to connect to the VPN?"
if ($confirmation -eq 'y') {

    #GET VPN CONNECTION
    $vpn = Get-VpnConnection -Name $vpnName;
    
    if($vpn.ConnectionStatus -eq "Disconnected"){
        #OPEN VPN
        Write-Output "Connecting to VPN...";
	    rasdial $vpnName $user $pass;
        Start-Sleep -Seconds 2
    }
}

#OPEN NETWORK DRIVES
Write-Output "Opening network drives...";
explorer D:
#explorer L:
#Start-Sleep -Seconds 1

function Open-AppInSeparateProcess($filePath){
    #https://www.reddit.com/r/PowerShell/comments/m91ipj/comment/grr8tgq
    #$GoXLRAPP = "/c start """" ""C:\ProgramData\Microsoft\Windows\Start Menu\Programs\GOXLR App\GOXLR App.lnk"" && exit"
    #Start-Process -FilePath CMD.exe -ArgumentList $GoXLRAPP

    $fileLink = "/c start """" ""$filePath"" && exit";
    Start-Process -FilePath CMD.exe -ArgumentList $fileLink;
}




#=========

#OPEN KEYLOCKER
Write-Output "Opening password manager...";
Set-Clipboard -Value ANONYMISED
Invoke-Item "C:\Users\matthew.tiernan\Desktop\Matt.kdbx"

#OPEN PRTG MONITOR
Write-Output "Opening PRTG...";
Invoke-Item "C:\Program Files\Paessler\PRTG Desktop\prtgdesktop.exe";

#OPEN OUTLOOK
Write-Output "Opening email...";
Invoke-Item "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE";

#OPEN VS CODE 
Write-Output "Opening VS Code...";
$vsCodePath = "C:\Program Files\Microsoft VS Code (Portable)\Code.exe";
#Invoke-Item $vsCodePath;
Open-AppInSeparateProcess($vsCodePath);
#Invoke-Item "C:\Program Files\Microsoft VS Code (Portable)\Code.exe";
#Start-Process -FilePath "C:\Program Files\Microsoft VS Code (Portable)\Code.exe" -NoNewWindow;

#OPEN OBSIDIAN
Write-Output "Opening Obsidian";
#Invoke-Item "C:\Users\matthew.tiernan\AppData\Local\Obsidian\Obsidian.exe";
Open-AppInSeparateProcess("C:\Users\matthew.tiernan\AppData\Local\Obsidian\Obsidian.exe");

#OPEN ASANA
#Write-Output "Opening Asana...";
#$asanaPath = "C:\Users\matthew.tiernan\AppData\Local\Asana\app-2.1.2\Asana.exe";
#Invoke-Item $asanaPath;
#Start-Process "https://app.asana.com/0/home/";
#Invoke-Item "C:\Users\matthew.tiernan\AppData\Local\Asana\app-2.1.0\Asana.exe";
#Start-Process -FilePath "C:\Users\matthew.tiernan\AppData\Local\Asana\app-2.1.0\Asana.exe" -NoNewWindow;

#OPEN TEAMS
#Write-Output "Opening MS Teams...";
#Invoke-Item "C:\Program Files (x86)\Teams Installer\Teams.exe"

#==========

#OPEN KEY WEBSITES
Write-Output "Opening key websites...";
#- OPEN TIMESHEET
Start-Process https://docs.google.com/spreadsheets/d/ANONYMISED/edit?usp=sharing
#Start-Process https://outlook.office365.com/mail/inbox
#- OPEN IMS TASKS
Start-Process https://ims.xepta.com/tasks/
#- OPEN MS OFFICE TO-DOs (USE OUTLOOK PANEL)
#Start-Process https://to-do.office.com/tasks/myday
Start-Sleep -Seconds 1

#OPEN TOMORROW WEBSITES
#Write-Output "Opening saved websites...";
#foreach($line in Get-Content .\tomorrow.txt) {
#    Start-Process $line
#}

#NEW - UPDATE SVN
#Invoke-Item "C:\Users\matthew.tiernan\Desktop\updateSVN.ps1"
invoke-expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\updateSVN.ps1"

#CHECK IF THERE IS A SAVED SET OF OPEN CODE FILES
#if(Test-Path -Path "C:\Users\matthew.tiernan\Desktop\open-files.code-workspace" -PathType Leaf){

	#OPEN RECENT CODE FILES
#	Invoke-Item "C:\Users\matthew.tiernan\Desktop\open-files.code-workspace"
#}

#RUN WIKI JOBS DAILY TO KEEP MAINTENANCE QUEUE LOW
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Run-WikiJobs.ps1 10";


#ASK IF SENDING "DAILY HOOKS"
$confirmation = Read-Host "Do you want to call Run-DailyHooks?"
if ($confirmation -eq 'y') {
	#SEND THE WORD OF THE DAY
	Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\RUN-DAILYHOOKS.ps1";
}

#ASK IF STARTING LOG PARSER
#$confirmation = Read-Host "Do you want to start the Log Parser?"
#if ($confirmation -eq 'y') {
#	#START THE LOG PARSER
#	Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\logs\logParse.ps1";
#}

#>

#ASK IF YOU WANT TO START OLLIEPOSTING?
$confirmation = Read-Host "Do you want to start Ollieposting?"
if ($confirmation -eq 'y') {
    #START OLLIEPOSTING
	Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\Inactive Daily Hooks\Start-Ollieposting.ps1";
}else{
    #WAIT FOR USER TO CLOSE
    Read-Host -Prompt "Press any key to continue";
    exit 0;
}
