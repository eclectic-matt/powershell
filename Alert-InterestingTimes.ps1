<#
	ALERT USERS OF INTERESTING TIMES COMING UP
#>

$interestingTimes = @();

#ADD TO ARRAY

#INCREMENTAL TIMES
$newElement = @('10:11:12');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('11:12:13');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('12:13:14');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('13:14:15');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('14:15:16');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('15:16:17');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('16:17:18');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('17:18:19');
$interestingTimes = $interestingTimes + $newElement;
#
$newElement = @('12:34:56');
$interestingTimes = $interestingTimes + $newElement;

#FUNNY TIMES
$newElement = @('13:33:37');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('16:20:00');
$interestingTimes = $interestingTimes + $newElement;

#DUPLICATED NUMBER TIMES
$newElement = @('09:09:09');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('11:11:11');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('10:10:10');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('12:12:12');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('13:13:13');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('14:14:14');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('15:15:15');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('16:16:16');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('11:22:33');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('11:12:22');
$interestingTimes = $interestingTimes + $newElement;

#PALINDROMIC NUMBERS
$newElement = @('11:00:11');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('12:22:21');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('13:33:31');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('14:44:41');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('15:55:51');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('15:22:51');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('10:00:01');
$interestingTimes = $interestingTimes + $newElement;
$newElement = @('18:00:08');
$interestingTimes = $interestingTimes + $newElement;

#THE TIME TO WAIT BETWEEN CHECKS
$updateSeconds = 30;
$runIndex = 1;

while ($true){

	#$nearestTime = Get-Date -Hour 0 -Minute 0 -Second 0;
	$now = Get-Date;# -Format "yyyy-MM-dd HH:mm:ss";

	Write-output "#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#";
	Write-output "Run #$runIndex started at $now";
	Write-output "#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#";

	foreach ($time in $interestingTimes ){

		$splitTime = $time.split(':');
		
		$fakeTime = Get-Date -Hour $splitTime[0] -Minute $splitTime[1] -Second $splitTime[2];
		#Write-output $fakeTime;
		$timeDiff = $fakeTime - $now;
		$totalSecs = $timeDiff.TotalSeconds;
		#Write-Output "Difference between '$now' and '$fakeTime' is $totalSecs";
		if($totalSecs -lt 60 -And $totalSecs -gt 0){
			Write-Output "ALERT SENT: " . $fakeTime;
			$output = "'<h1>Interesting Time Alert!</h1><br>Nearly about to hit an interesting time - $time'";
			Invoke-Expression -Command "path\to\powershell\utilities\Send-TeamsMessage.ps1 $output" > $silent; 
		}
	}

	$runIndex++;
	#SLEEP FOR $updateSeconds
	Start-Sleep -Milliseconds ($updateSeconds * 1000);
	Write-output " ";
}
