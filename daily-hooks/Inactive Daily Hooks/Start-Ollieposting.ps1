#INCLUDE CARD GENERATION FUNCTIONS
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\random\Imports.ps1

#Cls;
Write-Output 'Starting...';

#DEFINE HOURS TO POST
$hours = @('09', '10', '11', '12', '13', '14', '15', '16', '17');

#CREATE ARRAY OF TIMES
$times = @();

#FLAG IF WE WANT AN IMMEDIATE ALERT (ADD TO TIME ARRAY FOR NOW + 1 MINUTE)
$addImmediateAlert = $true;

if($addImmediateAlert -eq $true){

    #GET THE CURRENT HOUR AND MINUTE
    $currentHour = Get-Date -Format HH;
    $currentMinute = Get-Date -Format mm;
    #THE NUMBER OF MINUTES AHEAD TO SET AS THIS TIME
    $soonDiff = 1;

    #IF THIS TIME IS WITHIN $soonDiff MINS OF THE END OF THE HOUR (i.e. $min + $soonDiff > 60)
    if(([int]$currentMinute + $soonDiff) -gt 59){
        $currentMinute = $currentMinute + $soonDiff;
        #INCREMENT THE HOUR
        $currentHour = [int]$currentHour + 1;
        #SET THE ALERT TO BE AT 60 - $min
        $currentMinute = 60 - [int]$currentMinute;
    }else{
        #JUST INCREMENT MINUTE
        $currentMinute = [int]$currentMinute + $soonDiff;
    }

    #CREATE TIME STRING
    $soon = ($currentHour + ':' + $currentMinute + ':00');
    Write-Output "Adding immediate alert at $soon";

    #ADD THIS TIME TO THE ARRAY
    $thisHour = @($soon);
    $times = $times + $thisHour;
}

foreach($hour in $hours){

    #GENERATE A RANDOM FIRST TIME FOR THIS HOUR
    $first = Get-Random -Maximum 60;

    #GENERATE A RANDOM SECOND TIME FOR THIS HOUR
    $second = Get-Random -Maximum 60;
    #IF THE TIMES THIS HOUR ARE TOO CLOSE TOGETHER
    if(($second - $first) -lt 5){
        #SIMPLY SPACE WITH 60 - $first
        $second = 60 - $first;
    }

    #NOW CONVERT TO STRINGS
    $first = $first.toString();
    #AND TURN INTO A TIME STRING
    $first = $hour + ':' + $first.PadLeft(2,'0') + ':00';
    #SAME FOR THE SECOND TIME
    $second = $second.toString();
    $second = $hour + ':' + $second.PadLeft(2,'0') + ':00';
    
    $thisHour = @($first, $second);
    #Write-Output $thisHour;
    $times = $times + $thisHour;
}

Write-Output $times;

#CONVERT THIS TO AN ARRAYLIST
[System.Collections.ArrayList]$timesList = ($times);

#THE TIME TO WAIT BETWEEN CHECKS
$updateSeconds = 30;
#THE INTERVAL TO ALERT FROM (WITHIN x SECONDS)
$alertSeconds = 60;
#INITIALISE THE RUN INDEX (FOR OUTPUT ONLY)
$runIndex = 1;

while ($true){

    #STORE CURRENT TIME
    $now = Get-Date;
    $printTime = Get-Date -format "dd/MM/yyyy HH:mm:ss";
    #dddd	Day of the week - full name
    #MM	Month number
    #dd	Day of the month - 2 digits
    #yyyy	Year in 4-digit format
    #HH:mm	Time in 24-hour format - no seconds

    Write-output "==================================";
    #Write-output " ";
	Write-output "#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#";
	Write-output "Run #$runIndex started at $printTime";
	Write-output "#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#";

    #CALCULATE THE START INDEX
    #WE WILL BE REMOVING ELEMENTS, SO NEED TO 
    #START AT A LATER INDEX EACH TIME ELEMENTS ARE REMOVED
    $startIndex = $times.length - $timesList.Count;

    #ITERATE THROUGH ALL THE ITEMS IN THE TIMESLIST
    for($i = 0; $i -lt $times.length; $i++){

        #IF WE HAVE GONE PAST THE END OF THE LIST, SKIP 
        if($i -ge $timesList.Count){
            Write-Output "Past the end of the times list, skipping...";
            #SKIP REMAINDER
            break;
        }else{
            #GET THE CURRENT TIME FROM THE TIMES ARRAY
            $time = $times[$i + $startIndex];
            Write-Output "Check $i - $time";

            #IS THIS TIME STILL PRESENT IN THE TIME LIST?
            if($timesList.Contains($time)){
                    
                    #SPLIT TIME AND GENERATE FAKE TIME
                    $splitTime = $time.split(':');
                    $fakeTime = Get-Date -Hour $splitTime[0] -Minute $splitTime[1] -Second $splitTime[2];    

                    #GET TIME DIFFERENCE
                    $timeDiff = $fakeTime - $now;
                    $totalSecs = $timeDiff.TotalSeconds;
                    
                    #CHECK TIME DIFF
                    if($totalSecs -lt $alertSeconds -And $totalSecs -gt 0){
                        
                        Write-Host "ALERT SENT: $fakeTime";

                        #REMOVE INTERESTING TIME FROM THE ARRAY AT $i
                        $timesList.Remove($time);

                        <#
                        Sender: $name@insurethat.com
                        Subject: RE: RE: That thing...
                        Body: Hi Development,\n$message
                        #>

                        #GET RANDOM SENDER
                        $sender = & C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\random\Get-RandomName.ps1;
                       
                        #GET RANDOM BODY
                        $messageObj = & C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\random\Get-RandomMessage.ps1;
                        
                        #GET RANDOM CONTACT (PASSING IN THE "$sender" WHICH IS A RANDOMLY-GENERATED NAME)
                        $contact = & C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\random\Get-RandomContact.ps1 -name $sender;

                        #SENDER
                        $senderFullName = $sender.first + " " + $sender.last;
                        $senderEmail = $contact.email;
                        $senderTextBlock = [TextBlock]::new();
                        $senderTextBlock.setText("From: $senderFullName ($senderEmail)");
                        $senderTextBlock.setSize('normal');
                        $senderTextBlock.setWeight('lighter');
                        $senderTextBlock.setHorizontalAlignment('left');

                        #SUBJECT
                        $subjectTextBlock = [TextBlock]::new();
                        $subjectTextBlock.setText("Subject: RE: Ollieposting");
                        $subjectTextBlock.setSize('large');
                        $subjectTextBlock.setWeight('bolder');
                        $subjectTextBlock.setHorizontalAlignment('left');

                        #BODY INTRO
                        $intro = $messageObj.intro;
                        #Write-Host ("INTRO: " + $intro);
                        $bodyIntroTextBlock = [TextBlock]::new();
                        $bodyIntroTextBlock.setText("*$intro*");
                        $bodyIntroTextBlock.setSize('normal');
                        #$bodyIntroTextBlock.setColor('light');
                        $bodyIntroTextBlock.setWeight('lighter');
                        $bodyIntroTextBlock.setHorizontalAlignment('left');
                        $bodyIntroTextBlock.setSeparator($true);
                        #BODY REASON
                        $reason = $messageObj.reason;
                        #Write-Host ("REASON: " + $reason);
                        $bodyReasonTextBlock = [TextBlock]::new();
                        $bodyReasonTextBlock.setText("*$reason*");
                        $bodyReasonTextBlock.setSize('normal');
                        #$bodyReasonTextBlock.setColor('light');
                        $bodyReasonTextBlock.setWeight('lighter');
                        $bodyReasonTextBlock.setHorizontalAlignment('left');

                        #BODY OUTRO
                        $outro = $messageObj.outro;
                        #Write-Host ("OUTRO: " + $outro);
                        $bodyOutroTextBlock = [TextBlock]::new();
                        $bodyOutroTextBlock.setText("*$outro*");
                        $bodyOutroTextBlock.setSize('normal');
                        #$bodyOutroTextBlock.setColor('light');
                        $bodyOutroTextBlock.setWeight('lighter');
                        $bodyOutroTextBlock.setHorizontalAlignment('left');

                        #BODY FOOTER
                        $senderFirstName = $sender.first;
                        $bodyFooterTextBlock = [TextBlock]::new();
                        $bodyFooterTextBlock.setText("*$senderFirstName*");
                        $bodyFooterTextBlock.setSize('normal');
                        #$bodyFooterTextBlock.setColor('light');
                        $bodyFooterTextBlock.setWeight('lighter');
                        $bodyFooterTextBlock.setHorizontalAlignment('left');


                        #PUT THE ITEMS IN AN ARRAY
                        $items = @(
                            $senderTextBlock.out(), 
                            $subjectTextBlock.out(), 
                            $bodyIntroTextBlock.out(),
                            $bodyReasonTextBlock.out(),
                            $bodyOutroTextBlock.out(),
                            $bodyFooterTextBlock.out()
                        );

                        #WRAP IN A CONTAINER
                        $containerBlock = [Container]::new();
                        $containerBlock.setItems($items);

                        #WRAP IN AN ADAPTIVE CARD
                        [AdaptiveCard]$card = [AdaptiveCard]::new($containerBlock.out());

                        #WRAP THE ADAPTIVE CARD IN A MESSAGE
                        [Message]$message = [Message]::new($card.object);

                        #STRINGIFY THE FINAL MESSAGE - THIS *MUST* USE THE out() METHOD
                        $output = $message.out();
                        
                        #SAVE TO FILE (lastCardOutput.json)
                        $output > "C:\Users\matthew.tiernan\Desktop\POWERSHELL\test\TeamsCards\lastCardOutput.json";

                        Write-Host $output;

                        #SEND TEAMS MESSAGE
                        Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;
                        #Write-output $output;
                    }
            }
        }
    }

    #OUTPUT FOOTER FOR THIS RUN
    $now = Get-Date;
	#Write-output "#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#";
    Write-output "-------------------------------";    	
    Write-output "Run #$runIndex finished at $now";
	#Write-output "#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#";
    Write-output "Unalerted Times:";
    Write-output $timesList;
    Write-output "==================================";
    Write-output " ";
    $runIndex++;

	#THEN SLEEP FOR $updateSeconds
	Start-Sleep -Milliseconds ($updateSeconds * 1000);
}