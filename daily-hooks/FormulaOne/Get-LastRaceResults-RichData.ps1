<#
    GET THE LAST RACE RESULTS 
#>

#IMPORT THE CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

#BASE URLS
$baseUrl = "https://v1.formula-1.api-sports.io/";

#CHECK USAGE AND LIMITS AT:
# https://dashboard.api-football.com/profile?access

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

#DEFINE API URL TO CALL
$raceUrl = $baseUrl + "/races?last=1&timezone=Europe/London";
Write-Host ("CALLING: " + $raceUrl); 

#CALL THE API
$json = Invoke-RestMethod $raceUrl -Method 'GET' -Headers $headers
#STORE THE RESPONSE
$results = $json.response;
#Write-Host $results;
#STORE RACE ID 
$raceId = $results.id;
$raceName = $results.type;
$competitionName = $results.competition.name;
#Write-Host ("Results of the " + $raceName + " of the " + $competitionName);

#GET RESULTS
$rankingsUrl = ("https://v1.formula-1.api-sports.io/rankings/races?race=" + $raceId);
$json = Invoke-RestMethod $rankingsUrl -Method 'GET' -Headers $headers
#STORE THE RESPONSE
$results = $json.response;
#Write-Host $results;

#GENERATE THE CARD USING FUNCTIONS 
$header = [TextBlock]::new();
$header.setText("Results of the " + $raceName + " - " + $competitionName);
$header.setSize('large');
$header.setFontType('monospace');
$header.setWeight('bolder');

#PREPARE FACTS ARRAY
$facts = [FactSet]::new();
$factArr = @();

$index = 1;
foreach($result in $results){
    Write-Host ($index.ToString() + ": " + $result.driver.name + " - _" + $result.team.name + "_ (" + $result.time + ")");
    #ADD FACTS
	$fact = [Fact]::new();
	$fact.setTitle("$index");
	$fact.setValue($result.driver.name + " - _" + $result.team.name.Trim() + "_ (" + $result.time + ")");
	$factArr = $factArr + $fact.out();
    $index++;
}

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
exit 1;

#SEND TO TEAMS (Drinks Orders)
#Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true"" ""Drinks Orders""" > $silent;

#SEND TO TEAMS (General)
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;