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

#OUTPUT UPCOMING COMPETITIONS

#BASE URLS
$baseUrl = "https://v1.formula-1.api-sports.io/";

#GET API KEY FROM SECRET STORE
$keyFileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\api\apiKeys.json";
$keyFile = Get-Content -Path $keyFileName -Raw;
$keysJSON = ConvertFrom-Json $keyFile;
$apiSportsApiKey = $keysJSON.keys.apiSports;

#SET API HEADERS
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]";
$headers.Add('x-rapidapi-host', 'v1.formula-1.api-sports.io');
$headers.Add('x-rapidapi-key', $apiSportsApiKey);

#=========
# GET RACES
#=========
#https://api-sports.io/documentation/formula-1/v1#tag/Races/operation/get-races

#LIMIT TO A NUMBER OF EVENTS
$numberOfEvents = 50; #CHOSEN AS IT CUTS OFF NEATLY FOR NOW (MAY NEED TO ADJUST)

#LIMIT TO A NUMBER OF COMPETITIONS
$numberOfCompetitions = 5;

#==========================
# HEADING (UPCOMING F1)
#==========================
$headerText = [TextBlock]::new();
#$headerText.setText("Upcoming F1 Races - Next " + $numberOfEvents.ToString() + " Events");
Write-Host ("NO NEW F1 NEWS - Showing Next " + $numberOfCompetitions.ToString() + " Upcoming Competitions");
$headerText.setText("NO NEW F1 NEWS - Showing Next " + $numberOfCompetitions.ToString() + " Upcoming Competitions");
$headerText.setSize('extralarge');
$headerText.setWeight('default');

#DEFINE API URL TO CALL
$raceUrl = $baseUrl + "/races?next=" + $numberOfEvents + "&timezone=Europe/London";
Write-Host "CALLING: " + $raceUrl; 

#CALL THE API
$json = Invoke-RestMethod $raceUrl -Method 'GET' -Headers $headers
#STORE THE RESPONSE
$results = $json.response;

#INITIALIZE CURRENT COMPETITION TO $null
$currentCompetition = $null;

#$eventIndex = 1;
$competitionIndex = 0;

foreach($result in $results){

    #STORE COMPETITION ID
    $nextCompetition = $result.competition.id;

    #IF OUTPUTTING NEW COMPETITION
    if($currentCompetition -ne $nextCompetition){

        #IF REACHED COMPETITION LIMIT
        if($competitionIndex -ge $numberOfCompetitions){
            break;
        }

        $competitionIndex++;
        
        #NEW COMPETITION
        Write-Host ($competitionIndex.ToString() + " => " + $result.competition.name + " at " + $result.circuit.name);
        
        #OUTPUT COMPETITION HEADING
        $thisEventHead = [TextBlock]::new();
        $thisEventHead.setText("# " + $result.competition.name + " at " + $result.circuit.name);
        $thisEventHead.setSize('large');
        $thisEventHead.setWeight('bolder');
	    $thisEventHead.setHorizontalAlignment('left');
        #ADD TO THE DEFINITION CONTAINER
	    $eventsContainer.addItem($thisEventHead.out());
        #STORE CURRENT COMPETITION
        $currentCompetition = $result.competition.id;
    }
    
    #EVENT DETAILS DATE FORMATTING
    $eventDate = [datetime]$result.date;
    $dateString = ($eventDate.ToLongDateString() + " at " + $eventDate.ToLongTimeString());
    $eventDetails = ("* " + $result.type + " on " + $dateString);
    #Write-Host ($eventIndex.ToString() + " => " + $eventDetails);
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