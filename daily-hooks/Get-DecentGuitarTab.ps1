<#
	.Synopsis
	Get a random guitar tab and send via webhook
	
	.Version
	1.0

	.Description
	Get-RandomGuitarTab gets a random guitar tab via API/Web Scraping and posts to Teams.

	.Link
	https://www.songsterr.com?pattern=Cool%20Band%20Name
#>

#IMPORT THE CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

#CLEAR THE SCREEN BETWEEN RUNS?
Cls;

<#
    SONGSTERR SEARCH AND EXTRACT
#>

#DEFINE THE BAND NAMES TO GET TABS FOR
$patternList = @(
    "Led Zeppelin",
    "Deftones",
    "Tool",
    "The Rolling Stones",
    "The Beatles",
    "Limp Bizkit",
    "Metallica",
    "Guns N' Roses",
    "Nirvana",
    "Pearl Jam",
    "Soundgarden",
    "Red Hot Chili Peppers",
    "Dire Straits",
    "Ozzy Osbourne",
    "Rage Against The Machine",
    "Pantera",
    "Slayer",
    "Megadeth",
    "Foo Fighters",
    "Radiohead",
    "The Eagles"
);

#OR DEFINE SOME RANDOM WORDS TO SEARCH FOR
$patternList = @(
    "love",
    "hate",
    "small",
    "big",
    "willy",
    "cry",
    "laugh",
    "live",
    "work",
    "sleep",
    "stop",
    "start"
);



$randomPatternId = Get-Random -Maximum $patternList.Count;
$randomPattern = $patternList[$randomPatternId];

Write-Host ("Searching for songs containing: " + $randomPattern);

#Define the base url
$baseUrl = "https://www.songsterr.com";

#The search page works with a ?pattern= selector
$searchPageUrl = ($baseUrl + "?pattern=" + $randomPattern);
#The returned front-page search links have this class
$searchLinksClass = "B0cew";

#USE TLS1.2 TO ENSURE LOADING CORRECTLY
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#LOAD THE WEBPAGE
$req = Invoke-Webrequest -URI $searchPageUrl

#STORE THE RETURNED SEARCH LINKS IN AN ARRAY
$searchLinks = $req.ParsedHtml.getElementsByClassName($searchLinksClass);
#GET THE NUMBER OF RETURNED LINKS
$tabCount = $searchLinks.Length;
Write-Host ("Found " + $tabCount + " tabs");
#SELECT A RANDOM INDEX FROM THE NUMBER OF MATCHES
$randomTabId = Get-Random -Maximum $tabCount;
#SELECT THE RANDOM TAB LINK
$selectedLink = $searchLinks | Select -First 1 -Skip $randomTabId;
#THIS IS RETURNED WITH "about:" SO STRIP THIS OUT
$formattedLink = $selectedLink.href -Replace("about:","")
#THEN APPEND THE HREF TO THE BASE URL
$selected = $baseUrl + $formattedLink;
Write-Host $selected;


<# 
    SCREENSHOT SECTION 
    See: https://microlink.io/docs/api/parameters/screenshot/fullPage
#>

#BASE MICROBASE SCREENSHOT LINK
$microlinkBase = "https://api.microlink.io/?url=";

#THE TAB "LINES" ARE IN DIVS WITH THIS CLASS NAME
$dataLineClassName = "D2820n";
#SUFFIX DEFINES SCREENSHOT SETTINGS:
# - SCREENSHOT THE "#tablature" ELEMENT
# - WAIT FOR auto, ONCE ALL PAGE CONTENT LOADED
# - ALSO WAIT FOR div.D2820n (THE TAB LINES LOADED)
#$microLinkSuffix = "&screenshot.fullPage.element=#tablature&waitUntil=auto&waitForSelector=div.D2820n";
$microLinkSuffix = "&screenshot.fullPage&viewport=deviceScaleFactor=0.5&viewport.isLandscape=false&waitUntil=auto&waitForSelector=div.D2820n&scroll=#footer";

#APPEND THESE TO MAKE THE FULL MICROLINK URL
$microLink = ($microlinkBase + $selected + $microlinkSuffix);

$microlinkJson = Invoke-WebRequest $microLink;

$json = $microlinkJson.Content;

$jsonObj = $json | ConvertFrom-Json;

if($jsonObj.status -ne "success"){
    Write-Output "Error getting screenshot data - exiting...";
    exit 1;
}

$screenshotUrl = $jsonObj.data.screenshot.url;
$tabTitle = $jsonObj.data.title.ToString();
#Remove the "| Songsterr Tabs with Rhythm" which is part of the page title
$tabTitle = $tabTitle -Replace("\| Songsterr Tabs with Rhythm","");
#Write-output $jsonObj;
#exit;

#GENERATE AN IMAGE ELEMENT
$image = [Image]::new();
$image.setUrl($screenshotUrl);
$image.setSize('stretch');
#$image.setSize('extralarge');


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

$titleText = [TextBlock]::new();
$titleText.setText("$tabTitle");
$titleText.setWeight('bolder');
$titleText.setSize('extraLarge');

#THE ENTIRE CONTENT IS ONE COLUMN/CONTAINER
$content = @(
	$headerText.out(), 
	$headerWord.out(), 
    $titleText.out(),
    $image.out()
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