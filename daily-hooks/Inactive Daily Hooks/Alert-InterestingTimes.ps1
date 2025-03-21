#INCLUDE CARD GENERATION FUNCTIONS
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

<#
  JUST TO REMIND MYSELF,
  THIS FILE WAS LINKED UP TO:
  
  ADMIN: https://app.wiremock.cloud/mock-apis/72lzz/stubs/4fb310c5-13af-4a13-a4f4-d9d559a36adc
  (LOGIN WITH GITHUB)

  WEBHOOK TO: https://72lzz.wiremockapi.cloud/
  
  USAGE: @reply-bot 11:22:33
  
  WHICH RETURNS "DEADLY TIME SNIPE" ETC
#>


#CREATE ARRAY OF TIMES
$times = @();

#ADD TO ARRAY

#9AM - 10AM
$nineAm = @('09:09:09');
$times = $times + $nineAm;

#10AM - 11AM
$tenAm = @('10:00:01', '10:10:10', '10:11:12','10:20:30');
$times = $times + $tenAm;

#11AM - 12PM
$elevenAm = @('11:00:11', '11:11:11', '11:12:13', '11:12:22', '11:22:33');
$times = $times + $elevenAm;

#12PM - 1PM
$twelvePm = @('12:12:12', '12:13:14', '12:22:21', '12:34:56');
$times = $times + $twelvePm;

#1PM - 2PM
$onePm = @('13:13:13', '13:14:15', '13:33:31', '13:33:37');
$times = $times + $onePm;

#2PM - 3PM
$twoPm = @('14:14:14', '14:15:16', '14:44:41');
$times = $times + $twoPm;

#3PM - 4PM
$threePm = @('15:15:15', '15:16:17', '15:22:51', '15:55:51');
$times = $times + $threePm;

#4PM - 5PM
$fourPm = @('16:16:16', '16:17:18', '16:20:00');
$times = $times + $fourPm;

#5PM - 6PM
$fivePm = @('17:18:19');
$times = $times + $fivePm;

#6PM - 7PM
$sixPm = @('18:00:08');
$times = $times + $sixPm;

#CONVERT THIS TO AN ARRAYLIST
[System.Collections.ArrayList]$timesList = ($times);

#THE TIME TO WAIT BETWEEN CHECKS
$updateSeconds = 30;
#THE INTERVAL TO ALERT FROM (WITHIN x SECONDS)
$alertSeconds = 120;
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
                        
                        Write-Output "ALERT SENT: $fakeTime";
                        #MAKE THE INTRO TEXT BLOCK
                        $introTextBlock = [TextBlock]::new();
                        $introTextBlock.setText('Interesting Time Alert');
                        $introTextBlock.setSize('normal');
                        $introTextBlock.setFontType('monospace');

                        #MAKE THE BIG TIME TEXT BLOCK
                        $timeTextBlock = [TextBlock]::new();
                        $timeTextBlock.setText("$time");
                        $timeTextBlock.setSize('extraLarge');
                        $timeTextBlock.setColor('attention');

                        #REMOVE INTERESTING TIME FROM THE ARRAY AT $i
                        $timesList.Remove($time);
                    
                        #IF WE HAVE NOT GONE PAST THE END OF THE TIMESLIST
                        if($i -lt $timesList.Count){
                            #GET THE NEXT TIME TO ALERT (NOW AT INDEX $i AFTER .Remove)
                            $nextTime = $times[$i + $startIndex + 1];
                            #MAKE THE NEXT TIME TEXT BLOCK
                            $nextTimeBlock = [TextBlock]::new();
                            $nextTimeBlock.setText("The next interesting time is at $nextTime");
                            $nextTimeBlock.setSize('small');

                        }else{
                            #GENERATE AN EMPTY NEXT TIME BLOCK (ENSURES METHODS AVAILABLE)
                            $nextTimeBlock = [TextBlock]::new();
                            $nextTimeBlock.setText(" ");
                            $nextTimeBlock.setSize('small');
                        }

                        #ADD A REPLY BOT NOTE
                        $replyBotBlock = [TextBlock]::new();
                        $replyBotBlock.setText("To get a score, reply to 'reply-bot' with your time, e.g. '@reply-bot $time'");
                        $replyBotBlock.setSize('small');

                        #PUT THE ITEMS IN AN ARRAY
                        $items = @($introTextBlock.out(), $timeTextBlock.out(), $nextTimeBlock.out(), $replyBotBlock.out());

                        #WRAP IN A CONTAINER
                        $containerBlock = [Container]::new();
                        $containerBlock.setItems($items);

                        #WRAP IN AN ADAPTIVE CARD
                        $card = [AdaptiveCard]::new($containerBlock.out());
                        
                        #WRAP IN A MESSAGE AND OUTPUT
                        $output = [Message]::new($card.object).out();

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