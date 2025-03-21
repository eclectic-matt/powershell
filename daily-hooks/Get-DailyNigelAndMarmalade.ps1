<#
	.Synopsis
	Get a random Nigel and Marmalade video and send via webhook
	
	.Version
	1.0

	.Description
	Get-DailyNigelAndMarmalade gets a YT video and posts to Teams.

	.Link
	https://developers.google.com/youtube/v3/docs/search/list?apix=true&apix_params=%7B%22part%22%3A%5B%22id%22%2C%22snippet%22%5D%2C%22channelId%22%3A%22UCUM6KH8_sU6hkA8byqfkyUA%22%7D
#>

#IMPORT THE CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

#CLEAR THE SCREEN BETWEEN RUNS?
#Cls;

<#
    YOUTUBE DAILY NIGEL AND MARMALADE
#>

#GET API KEY FROM SECRET STORE
$keyFileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\api\apiKeys.json";
$keyFile = Get-Content -Path $keyFileName -Raw;
$keysJSON = ConvertFrom-Json $keyFile;
$apiKey = $keysJSON.keys.youtubeApi;

#STORE CHANNEL ID (Tom Bates)
$channelId = "UCUM6KH8_sU6hkA8byqfkyUA";
#STORE SEARCH TERM (Nigel and Marmalade)
$searchTerm = "Nigel%20and%20Marmalade";

#SET FULL API URL
$apiUrl = ("https://youtube.googleapis.com/youtube/v3/search?part=id&part=snippet&channelId=" + $channelId + "&q=" + $searchTerm + "&maxResults=75&type=video&videoDuration=short&key=" + $apiKey);

#SET API HEADERS
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]";
$headers.Add('Accept', 'application/json');

#CALL THE API, PASSING HEADERS
$json = Invoke-RestMethod $apiUrl -Method 'GET' -Headers $headers;
Write-Host $json;
Write-Host $json.pageInfo.totalResults;
#exit;


#STORE THE ITEMS
$items = $json.items;

#SELECT A RANDOM ITEM
$itemCount = $items.length;

#===========================
#GET THE RECENT UPDATES 
# TO PREVENT DUPLICATION
#===========================
$recentName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\data\recentNigelAndMarmalade.json";
$recentFile = Get-Content -Path $recentName -Raw;
$recentJSON = ConvertFrom-Json $recentFile;
$recentArray = $recentJSON.recent;
$recentList = New-Object System.Collections.ArrayList($null)
$recentList.AddRange($recentArray);
$recentCount = $recentJSON.recentCount;

#GET AN ITEM ON THE RECENT LIST (FORCE THE FIRST WHILE LOOP BELOW)
$videoId = $recentList[0];

#===========================
# CHECK FOR UNIQUE VIDEO ID
#===========================
while($recentList.Contains($videoId)){
    #GET A NEW ITEM
    $randomIndex = Get-Random -Maximum $itemCount;
    $item = $items[$randomIndex];
    #GET THE VIDEO ID (CHECKS NOT IN RECENT LIST)
    $videoId = $item.id.videoId;
}

#===========================
# UPDATE RECENT JSON
#===========================
#STORE THE NEW VIDEO ID IN THE RECENT LIST
$recentList.Add($videoId) > $silent;
#NEW ENVIRO GENERATED - CHECK IF CAPACITY REACHED
if( ($recentList.length + 1) -gt $recentCount){
    Write-Host ("Recent list full - removing " + $recentList[0]);
    #REMOVE THE FIRST ELEMENT FROM THE RECENT LIST
    $recentList.Remove($recentList[0]) > $silent;
}

#MODIFY RECENT LIST
$recentHash = @{
    'recent' = @($recentList)
    'recentCount' = ($recentCount)
}

#STORE TO JSON FILE
$newRecentJSON = $recentHash | ConvertTo-Json -Depth 3 | Out-File $recentName;


#UNIQUE VIDEO ID FOUND - PREPARE OUTPUT
$videoUrl = ("https://www.youtube.com/watch?v=" + $videoId);
$title = $item.snippet.title; 
$thumbnailUrl = $item.snippet.thumbnails.high.url;

#Write-Host ("TITLE: " + $title);
#Write-Host ("VideoUrl: " + $videoUrl);
#Write-Host ("THUMBNAIL: " + $thumbnailUrl);


#==========================
# HEADER TEXT
#==========================
$headerText = [TextBlock]::new();
$headerText.setText("Daily Nigel and Marmalade");
$headerText.setWeight('default');

$headerWord = [TextBlock]::new();
$headerWord.setText("$title");
$headerWord.setWeight('bolder');
$headerWord.setSize('extraLarge');

#GENERATE AN IMAGE ELEMENT
$image = [Image]::new();
$image.setUrl($thumbnailUrl);
$image.setSize('stretch');


#THE ENTIRE CONTENT IS ONE COLUMN/CONTAINER
$content = @(
	$headerText.out(), 
	$headerWord.out(),
    $image.out()
);

#ADD ACTION.OPENURL
$action = [ActionOpenUrl]::new($videoUrl,"View this video on Youtube");

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

#SEND TO TEAMS (General)
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;
#SEND TO TEAMS (Drinks Orders)
#Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true"" ""Drinks Orders""" > $silent;