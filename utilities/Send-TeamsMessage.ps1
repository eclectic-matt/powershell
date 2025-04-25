#WEBHOOK FOR TEAMS

#==============================
#HOW TO USE THIS COMMAND
#ENSURE THAT YOUR MESSAGE IS WRAPPED IN DOUBLE-QUOTES, THAT SEEMS TO WORK:
#Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 ""$Message""" > $silent; 
#==============================

#REFERENCE:
# https://learn.microsoft.com/en-us/outlook/actionable-messages/message-card-reference
# https://learn.microsoft.com/en-us/outlook/actionable-messages/adaptive-card

#THE MESSAGE TO SEND
#param ($Message);
$Message = $args[0];
$raw = $args[1];

#NEW - SPECIFY THE CHANNEL TO POST IN
$channel = $args[2];

if($null -eq $channel){

    #ASSUME POSTING TO THE DAILY POWERSHELL - General CHANNEL
    Write-Host "SENDING TO Daily Powershell - General";
        
    #TEAMS URI UPDATED (FORCED) BY MICROSOFT 2024-11-05 
    $teamsUri = "ANONYMISED";

}else{

    #SEND TO THE SPECIFIED CHANNEL (General or Drinks Orders)
    Switch ($channel)
    {
        "General" {
            Write-Host "SENDING TO Daily Powershell - General";
            
            #TEAMS URI UPDATED (FORCED) BY MICROSOFT 2024-11-05 
            $teamsUri = "ANONYMISED";

        }
        "Drinks Orders" {
            Write-Host "SENDING TO Daily Powershell - Drinks Orders";
             
            #TEAMS URI UPDATED (FORCED) BY MICROSOFT 2024-11-05 
            $teamsUri = "ANONYMISED";
        }
    }

}

#THE URI FOR THE TEAMS WEBHOOK (Daily Powershell)
#$teamsUri = "ANONYMISED";

#Write-Host $Message;

#TESTING - FOR SENDING ADAPTIVE CARDS
if($raw -eq "true"){

	#INVOKE A RAW WEB REQUEST TO POST TO THIS WEBHOOK
	$response = Invoke-WebRequest -Method 'POST' -ContentType "application/json" -Body "$Message" $teamsUri
    if($response.StatusCode -eq 200){
	    Write-Host "RAW Teams Message Sent";
    }else{
        Write-Host ("Error while sending via RAW: " + $response.RawContent);
    }

}else{

	#ESCAPE SPECIAL CHARACTERS
	$bSlashChar = '&#92;';
	$aposChar = '&#x27;';
	$Message = $Message.replace('\',$bSlashChar);
	#######$Message = $Message.replace("'",$aposChar);
	$Message = $Message.replace("""",$aposChar);	#ADDED FOR SENDING LOGS WITH "" IN THE STRING

	#INVOKE A WEB REQUEST TO POST TO THIS WEBHOOK
	$response = Invoke-WebRequest -Method 'POST' -ContentType "application/json" -Body "{`"text`" : `"$Message`"}" $teamsUri
	if($response.StatusCode -eq 200){
	    Write-Host "TEXT Teams Message Sent";
    }else{
        Write-Host ("Error while sending via TEXT: " + $response.RawContent);
    }
}

#GET THE NAME OF THE CALLING SCRIPT (Get-DinoTopTrumps,Alert-InterestingTime)
$scriptName = @(Get-PSCallStack)[1].InvocationInfo.MyCommand.Name
$now = Get-Date -Format "yyyy-MM-dd HH:mm:ss";
$length = $Message.length;

#GET THE INVOCATION PATH (e.g. C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\RUN-DAILYHOOKS.ps1)
$splitPath = Split-Path $MyInvocation.MyCommand.Path;
#GET THE ROOT (POWERSHELL) FOLDER (e.g. C:\Users\matthew.tiernan\Desktop\POWERSHELL\)
$rootFolder = Split-Path -Path $splitPath -Parent -Resolve;
#THEN GET THE CHILD utilities DIRECTORY (e.g. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities)
$utilitiesFolder = Join-Path -Path $rootFolder -ChildPath "utilities";

#LOG MESSAGES SENT
$logPath = "$utilitiesFolder\logs\webhooklog.csv";
#script,time,length
Add-Content $logPath "$scriptName,$now,$length" 

return $response;
