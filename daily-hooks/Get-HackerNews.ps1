<#
	.Synopsis
	Get the top 10 stories on Hacker News
	
	.Version
	0.1

	.Description
	Get-HackerNews gets the top 10 stories via API and posts to Teams.

	.Link
	https://github.com/HackerNews/API?tab=readme-ov-file#new-top-and-best-stories
#>

#ONE-TIME INSTALL (HTML PARSING)
#Install-Module -Name PowerHTML

#IMPORT THE CLASSES
#. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

#BASE URLS
$topStoriesUrl = "https://hacker-news.firebaseio.com/v0/topstories.json"; 

$itemDetailsUrl = "https://hacker-news.firebaseio.com/v0/item/";

#CALL THE API TO GET THE JSON
$json = Invoke-WebRequest $topStoriesUrl;

#CHECK THE JSON RETURN (IN CASE API FAILS)
#Write-Output $json.Content;

#CONVERT THE JSON TO AN OBJECT
$content = ConvertFrom-Json $json.Content;

#==========================
# HEADING (HACKER NEWS)
#==========================
$headerText = [TextBlock]::new();
$headerText.setText("Hacker News - Top Stories");
$headerText.setSize('extralarge');
$headerText.setWeight('default');

$mainUrl = "https://news.ycombinator.com/";
$mainUrlText = ("See more at: [" + $mainUrl + "](" + $mainUrl + ")");

$headerLinkText = [TextBlock]::new();
$headerLinkText.setText($mainUrlText);
$headerLinkText.setSize('extralarge');
$headerLinkText.setWeight('default');


#PREPARE ARRAY OF NEWS ITEMS
$newsItems = [System.Collections.ArrayList]@();

#PREPARE A CONTAINER TO STORE DEFINITIONS
$eventsContainer = [Container]::new();

#==========================
# ITERATE NEWS ITEMS
#==========================

for($i = 0; $i -lt 10; $i++){

    $itemId = $content[$i];

    Write-Host "=====================================";
    Write-Host ("Getting item " + ($i+1) + " with ID " + $itemId);
    Write-Host "=====================================";

    $itemUrl = ($itemDetailsUrl + $itemId + ".json");
    $itemJson = Invoke-WebRequest $itemUrl;
    $itemContent = ConvertFrom-Json $itemJson.Content;
    #DEBUG
    #Write-Host $itemContent;
    Write-Host $itemContent.title;

    #$itemString = "_'" + $itemContent.title + "'_ - by " + $itemContent.by + " - [" + $itemContent.url + "](" + $itemContent.url + ")";
    #Write-Host $itemString;
    #$newsItems.Add($itemString);

    #NEWS ITEM HEADING
    $thisEventHead = [TextBlock]::new();
    $thisEventHead.setText("'" + $itemContent.title + "' by _" + $itemContent.by + "_");
    $thisEventHead.setSize('large');
    $thisEventHead.setWeight('bolder');
	$thisEventHead.setHorizontalAlignment('left');

    #ADD TO THE DEFINITION CONTAINER
	$eventsContainer.addItem($thisEventHead.out());

    #NEWS ITEM LINK
	$thisEvent = [TextBlock]::new();
    $thisEvent.setText("[" + $itemContent.url + "](" + $itemContent.url + ")");
    $thisEvent.setSize('default');
	$thisEvent.setHorizontalAlignment('left');
	
	#ADD TO THE DEFINITION CONTAINER
	$eventsContainer.addItem($thisEvent.out());
}


#THE ENTIRE CONTENT IS ONE COLUMN/CONTAINER
$content = @(
	$headerText.out(), 
    $headerLinkText.out(), 
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

#SAVE OUTPUT TO FILE
$output | Set-Content -Path "$hooksFolder\lastCardOutput.json" -Encoding 'UTF8';

#SEND TO TEAMS
Invoke-Expression -Command "$utilitiesFolder\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;