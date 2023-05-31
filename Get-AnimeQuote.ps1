<#
	.Synopsis
	Get the random anime quote and send via webhook
	
	.Version
	1.0

	.Description
	Get-AnimeQuote gets an anime quote via API and posts to Teams.

	.Link
	https://katanime.vercel.app/api/getrandom
#>

#IMPORT THE CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1


#BASE URLS
#$animeQuoteUrl = "https://animechan.vercel.app/api/random"; #SUSPENDED 2023-05-31
$animeQuoteUrl = 'https://katanime.vercel.app/api/getrandom';

#CALL THE API TO GET THE JSON
$json = Invoke-WebRequest $animeQuoteUrl;

#CHECK THE JSON RETURN (IN CASE API FAILS)
#Write-Output $json.Content;

#PREPARE A HASHTABLE
$hashtable = @{}

#CONVERT THE JSON TO A HASHTABLE
(ConvertFrom-Json $json).psobject.properties | ForEach-Object { $hashtable[$_.Name] = $_.Value }

#EXTRACT THE RELEVANT DETAILS
#$quote = $hashtable["quote"];             #OLD VERSION
#$anime = $hashtable["anime"];             #OLD VERSION
#$character = $hashtable["character"];     #OLD VERSION

$quote = $hashtable.result[0].english;
$anime = $hashtable.result[0].anime;
$character = $hashtable.result[0].character;

#==========================
# HEADING (WORD OF THE DAY)
#==========================
$headerText = [TextBlock]::new();
$headerText.setText("Daily Anime Quote:");
$headerText.setWeight('default');

$headerWord = [TextBlock]::new();
$headerWord.setText("$quote");
$headerWord.setWeight('bolder');
$headerWord.setSize('extraLarge');

$animeText = [TextBlock]::new();
$animeText.setSize('small');
$animeText.setStyle('heading');
$animeText.setText("Anime: $anime");
$animeText.setWeight('bolder');

$charText = [TextBlock]::new();
$charText.setSize('small');
$charText.setStyle('heading');
$charText.setText("Character: $character");
$charText.setWeight('bolder');


#THE ENTIRE CONTENT IS ONE COLUMN/CONTAINER
$content = @(
	$headerText.out(), 
	$headerWord.out(), 
	$animeText.out(),
	$charText.out()
);

#GET ANIME LINK
$animeLink = "https://en.wikipedia.org/wiki/" + ($anime).replace(" ","_");
	
#ADD ACTION.OPENURL
$action = [ActionOpenUrl]::new($animeLink,"View $anime on Wikipedia");

#PUT THE ARRAY OF CONTENT IN A CONTAINER
$fullContainer = [Container]::new();
$fullContainer.setItems($content);
$fullContainer.setSelectAction($action.out());

#WRAP IN AN ADAPTIVE CARD
[AdaptiveCard]$card = [AdaptiveCard]::new($fullContainer.out());

#WRAP THE ADAPTIVE CARD IN A MESSAGE
[Message]$message = [Message]::new($card.object);
#STRINGIFY THE FINAL MESSAGE - THIS *MUST* USE THE out() METHOD
$output = $message.out();

#OUTPUT TO SCREEN FOR CHECKING
Write-Output $output;
#pause;
#exit 1;

#SAVE TO FILE (lastCardOutput.json)
$output > "C:\Users\matthew.tiernan\Desktop\POWERSHELL\test\TeamsCards\lastCardOutput.json";

#SEND TO TEAMS
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;
