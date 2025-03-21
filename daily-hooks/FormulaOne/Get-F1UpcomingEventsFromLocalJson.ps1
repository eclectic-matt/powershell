<#
	.Synopsis
	Get F1 Live Feed and send via webhook
	
	.Version
	1.0

	.Description
	Get-F1-LiveFeed scrapes the Race Fans RSS feed news and posts to Teams.

	.Link
	https://www.racefans.net/feed/
#>

#ONE-TIME INSTALL (HTML PARSING)
#Install-Module -Name PowerHTML

#==================

#IMPORT THE CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

Cls;


#PREPARE A CONTAINER TO STORE DEFINITIONS
$eventsContainer = [Container]::new();

#GET UPCOMING EVENTS FROM THE LOCAL JSON FILE
$scheduleFileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\data\formula1\f1schedule.json";
$scheduleFile = Get-Content -Path $scheduleFileName -Raw;
$scheduleJSON = ConvertFrom-Json $scheduleFile;
$schedule = $scheduleJSON.schedule;
$numberOfCompetitions = $schedule.length;

#==========================
# HEADING (UPCOMING F1)
#==========================
$headerText = [TextBlock]::new();
#$headerText.setText("Upcoming F1 Races - Next " + $numberOfEvents.ToString() + " Events");
#Write-Host ("NO NEW F1 NEWS - Showing Next " + $numberOfCompetitions.ToString() + " Upcoming Competitions");
#$headerText.setText("NO NEW F1 NEWS - Showing Next " + $numberOfCompetitions.ToString() + " Upcoming Competitions");
$headerText.setText("Showing Next " + $numberOfCompetitions.ToString() + " Upcoming F1 Competitions");
$headerText.setSize('extralarge');
$headerText.setWeight('default');

foreach($event in $schedule){

    Write-Host $event.title;
    $sessions = $event.sessions;

    #OUTPUT COMPETITION HEADING
    $thisEventHead = [TextBlock]::new();
    $thisEventHead.setText("# " + $event.title + " at " + $event.track);
    $thisEventHead.setSize('large');
    $thisEventHead.setWeight('bolder');
	$thisEventHead.setHorizontalAlignment('left');
    #ADD TO THE DEFINITION CONTAINER
	$eventsContainer.addItem($thisEventHead.out());

    foreach($session in $sessions){
        Write-Host ("-> " + $session.title + " [" + $session.date + " from " + $session.time.start + " - " + $session.time.finish + "]");

        #EVENT DETAILS DATE FORMATTING
        $eventDate = [datetime]$session.date;
        $dateString = ($eventDate.ToLongDateString());# + " at " + $eventDate.ToLongTimeString());
        #Write-Host $dateString;

        #$eventDetails = ("* " + $session.type.ToUpper() + " (" + $session.title +  ") on " + $dateString);
        $eventDetails = ("* " + $session.title +  " on " + $dateString + " from " + $session.time.start + " - " + $session.time.finish);
        Write-Host ($eventDetails);
        $eventIndex++;

        #EVENT DETAILS OUTPUT
        $thisEventText = [TextBlock]::new();
        $thisEventText.setText($eventDetails);
        $thisEventText.setSize('medium');
	    $thisEventText.setHorizontalAlignment('left');

        #ADD TO THE DEFINITION CONTAINER
	    $eventsContainer.addItem($thisEventText.out());

    }

}

#=================


#THE ENTIRE CONTENT IS ONE COLUMN/CONTAINER
$content = @(
	$headerText.out(), 
	$eventsContainer.out()
);

#PUT THE ARRAY OF CONTENT IN A CONTAINER
$fullContainer = [Container]::new();
$fullContainer.setItems($content);

#WRAP IN AN ADAPTIVE CARD
[AdaptiveCard]$card = [AdaptiveCard]::new($fullContainer.out());

#WRAP THE ADAPTIVE CARD IN A MESSAGE
[Message]$message = [Message]::new($card.object);
#STRINGIFY THE FINAL MESSAGE - THIS *MUST* USE THE out() METHOD
$output = $message.out();

#SAVE TO FILE (lastCardOutput.json)
$output > "C:\Users\matthew.tiernan\Desktop\POWERSHELL\test\TeamsCards\lastCardOutput.json";

#OUTPUT TO SCREEN FOR CHECKING
Write-Output $output;
#pause;
#exit 1;

#SEND TO TEAMS (Drinks Orders)
#Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true"" ""Drinks Orders""" > $silent;

#SEND TO TEAMS (General)
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;