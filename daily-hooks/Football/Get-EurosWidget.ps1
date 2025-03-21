<#
    GET THE LAST RACE RESULTS 
#>

#IMPORT THE CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

#BASE URLS
$baseUrl = "https://v3.football.api-sports.io";

#GRABBED FROM THE BLOCK ABOVE AND HARD-CODED
$eurosLeagueId = 4;

#CHECK USAGE AND LIMITS AT:
# https://dashboard.api-football.com/profile?access

#GET API KEY FROM SECRET STORE
$keyFileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\api\apiKeys.json";
$keyFile = Get-Content -Path $keyFileName -Raw;
$keysJSON = ConvertFrom-Json $keyFile;
$apiSportsApiKey = $keysJSON.keys.apiSports;

#SET API HEADERS
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]";
$headers.Add('data-host', 'v3.football.api-sports.io');
$headers.Add('data-key', $apiSportsApiKey);
$headers.Add('data-league', $eurosLeagueId);

#https://www.api-football.com/documentation-v3#tag/Widgets/operation/get-widget-games
#DEFINE API URL TO CALL 

$fixturesUrl = "https://v3.football.api-sports.io/widgets/game";

#CALL THE API
$json = Invoke-RestMethod $fixturesUrl -Method 'GET' -Headers $headers;

Write-Host $json.errors;

Write-Host $json.response;

#STORE THE RESPONSE
$results = $json.response;

Write-Host $results.ToString();

exit; 


foreach($result in $results){
    
    #REFORMAT DATE/TIME RETURNED
    $eventDate = [datetime]$result.fixture.date;
    #$dateString = ($eventDate.ToLongDateString() + " at " + $eventDate.ToLongTimeString());
    $timeStr = Get-Date $eventDate -format "h:mmtt";
    
    #$dateString = ($eventDate.ToShortDateString() + " " + $eventDate.ToShortTimeString());
    #Write-Host $dateString;
    #Write-Host ($eventDate.ToShortDateString() + " " + $timeStr);

    #ADD FACTS
	$fact = [Fact]::new();

    #HIGHLIGHT ENGLAND MATCHES?
    #$highlight = false;
    if( ($result.teams.home.name -eq "England") -or ($result.teams.away.name -eq "England") ){
        #$highlight = true;
        #Write-Host ("*" + $result.teams.home.name + " vs. " + $result.teams.away.name + " (" + $dateString + ")*");
        #$fact.setTitle("*" + $result.teams.home.name + " vs. " + $result.teams.away.name + "*");
        #$fact.setValue("*" + $dateString + "*");
        $fact.setTitle("*" + $eventDate.ToShortDateString() + " " + $timeStr + "*");
        $fact.setValue("*" + $result.teams.home.name + " vs. " + $result.teams.away.name + "*");
    }else{
        #Write-Host ($result.teams.home.name + " vs. " + $result.teams.away.name + " (" + $dateString + ")");
        #$fact.setTitle($result.teams.home.name + " vs. " + $result.teams.away.name);
        #$fact.setValue($dateString);
        $fact.setTitle($eventDate.ToShortDateString() + " " + $timeStr);
        $fact.setValue($result.teams.home.name + " vs. " + $result.teams.away.name);
    }
	
	$factArr = $factArr + $fact.out();
}

#exit 1;

#SET FACT SET
$facts.setFacts($factArr);


#THE ENTIRE CONTENT IS ONE COLUMN/CONTAINER
$content = @(
	$header.out(), 
	$facts.out()
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