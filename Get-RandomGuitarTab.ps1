<#
	.Synopsis
	Get a random guitar tab and send via webhook
	
	.Version
	1.0

	.Description
	Get-RandomGuitarTab gets a random guitar tab via API/Web Scraping and posts to Teams.

	.Link
	https://www.songsterr.com/sitemap-chords-1.xml
#>

#IMPORT THE CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

#CLEAR SCREEN
Cls;

#GET A RANDOM PAGE ID
$randomId = Get-Random -Maximum 15;
#GET THE BASE PAGE + RANDOM ID, e.g. https://www.songsterr.com/sitemap-chords-1.xml
$baseUrl = "https://www.songsterr.com/sitemap-chords-";
$url = ($baseUrl + $randomId + ".xml");
#CONFIRM THE URL TO GET
Write-Output $url;

#CALL THE API TO GET THE XML
[xml]$xml = (Invoke-WebRequest $url).Content;

#STORE THE COUNT OF SONGS
$songCount = $xml.urlset.url.length;

#GET A RANDOM SONG ID (UP TO THE NUMBER OF RESULTS IN THE XML
$randomSongId = Get-Random -Maximum $songCount;

#SELECT THIS SONG (FIRST 1 = 1 URL, SKIP $randomSongId URLS)
$selected = ($xml.urlset.url | Select -First 1 -Skip $randomSongId).loc;

#DEBUG OUTPUT
Write-Output "The Selected Song is: ";
Write-Output $selected;

#LOAD THE CONTENT FROM THE SELECTED URL
$html = (Invoke-WebRequest $selected).Content;

#EXTRACT THE TITLE (FOR INFO, HIDDEN IN OUTPUT)
$titleRegex = "<title>(?<title>[\w ]*) \|.*<\/title>";
$html -match $titleRegex > $silent;
if($null -ne $Matches){
    Write-Output "The Selected Title found as: ";
    Write-Output $Matches.title;
}else{
    Write-Output "cannot find title";
}

<#
#EXTRACT THE CHORDS SECTION
$chordsRegex = '<section id="chords" class="D0ez9">(?<chords>.*)<\/section>';
$html -match $chordsRegex > $silent;
if($null -ne $Matches){
    Write-Output "Chords Found as: ";
    $chords = $Matches.chords;
}else{
    Write-Output "Cannot find chords";
}
#>

#https://learn.microsoft.com/en-us/microsoftteams/platform/task-modules-and-cards/cards/cards-format?tabs=adaptive-md%2Cdesktop%2Cconnector-html


#https://microlink.io/docs/api/parameters/screenshot/fullPage

#GET SCREENSHOT OF THE LINK
$microlinkBase = "https://api.microlink.io/?url=";
#$microlinkSuffix = "&screenshot=true";       #TOP-PART SCREENSHOT
$microLinkSuffix = "&screenshot&fullPage";    #FULL PAGE SCREENSHOT?

$microLink = ($microlinkBase + $selected + $microlinkSuffix);

$microlinkJson = Invoke-WebRequest $microLink;

$json = $microlinkJson.Content;

$jsonObj = $json | ConvertFrom-Json;

if($jsonObj.status -ne "success"){
    Write-Output "Error getting screenshot data - exiting...";
    exit 1;
}

$screenshotUrl = $jsonObj.data.screenshot.url;
#Write-oUtput $url;

#GENERATE AN IMAGE ELEMENT
$image = [Image]::new();
$image.setUrl($screenshotUrl);
$image.setSize('extralarge');


#==========================
# HEADING (TAB OF THE DAY)
#==========================
#GET THE CURRENT DAY AND MONTH IN TEXT FOR HEADER OUTPUT
$month = (Get-Date).ToString("MM");
$monthName = (Get-Culture).DateTimeFormat.GetMonthName($month);
$day = (Get-Date).ToString("dd");

$headerText = [TextBlock]::new();
$headerText.setText("Tab of the Day");
$headerText.setWeight('default');

$headerWord = [TextBlock]::new();
$headerWord.setText("$day $monthName");
$headerWord.setWeight('bolder');
$headerWord.setSize('extraLarge');

#PREPARE A CONTAINER TO STORE DEFINITIONS
#$eventsContainer = [Container]::new();

<#
#==========================
# PASTE CHORDS
#==========================
$chordBlock = [TextBlock]::new();
$chordBlock.setText($chords);
$chordBlock.setSize('small');
#$thisEvent.setHorizontalAlignment('left');
	
#ADD TO THE DEFINITION CONTAINER
$eventsContainer.addItem($chordBlock.out());
#>

#THE ENTIRE CONTENT IS ONE COLUMN/CONTAINER
$content = @(
	$headerText.out(), 
	$headerWord.out(), 
    $image.out()
	#$eventsContainer.out()
);

#ADD ACTION.OPENURL
$action = [ActionOpenUrl]::new($selected,"View this tab on Songsterr");

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

#SAVE TO FILE (lastCardOutput.json)
$output > "C:\Users\matthew.tiernan\Desktop\POWERSHELL\test\TeamsCards\lastCardOutput.json";

#OUTPUT TO SCREEN FOR CHECKING
Write-Output $output;
#pause;

#DEBUG - PREVENT TEAMS SEND
#exit 1;

#SEND TO TEAMS
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;