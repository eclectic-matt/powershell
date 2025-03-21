<#
	.Synopsis
	Get famous historical events and send via webhook
	
	.Version
	1.0

	.Description
	Get-FamousEvents gets famous events via API and posts to Teams.

	.Link
	https://api-ninjas.com/api/historicalevents

    #NOTE: Email on 19th October - API responses being limited for free users from November 2023.
#>

#ONE-TIME INSTALL (HTML PARSING)
#Install-Module -Name PowerHTML

#==================

function Get-NumberOne{
    param(
        [Parameter(Mandatory=$true)] [String]$dateString,
        [Parameter(Mandatory=$false)] [String]$position,
        [Parameter(Mandatory=$false)] [Boolean]$fullChart
	)
    #DEFAULT ENTRY TO 0 (NUMBER ONE) IF NOT PROVIDED
    if( ($null -eq $position) -Or ($position -lt 1) ){
        $position = 1;
    }

    #GET THE WEB PAGE DATA FOR THIS DATE
    $web_page = Invoke-WebRequest ('https://www.officialcharts.com/charts/singles-chart/' + $dateString + '/7501/');
    
    #CONVERT FROM HTML (USES PowerHTML MODULE)
    $html = ConvertFrom-Html $web_page;
    
    #GET THE CHART ENTRIES ON THIS PAGE
    $chartEntries =$html.SelectNodes('//div') | Where-Object { $_.HasClass('chart-item-content') };
    
    #NO FULL CHART REQUESTED?
    if( ($null -eq $fullChart) -Or ($false -eq $fullChart) ){

        #SPECIFY ENTRY
        $thisEntry = $chartEntries[$position - 1];

        #GET THE TITLE
        $numberOneTitle = $thisEntry.ChildNodes[1].ChildNodes[0].ChildNodes[0].ChildNodes[2].InnerText;
        #GET THE ARTIST
        $numberOneArtist = $thisEntry.ChildNodes[1].ChildNodes[0].ChildNodes[2].ChildNodes[0].InnerText;

        #INIT RETURN OBJECT
        $return = @{};
        $return.position = $position;
        $return.title = $numberOneTitle;
        $return.artist = $numberOneArtist;

        return $return;
    }else{
        
        #START CURRENT COUNTER
        $current = 0;
        $returnArray = @();

        #ITERATE THROUGH ALL ENTRIES
        foreach($entry in $chartEntries){

            #IF WE HAVE REACHED THE MAX POSITION
            if($current -ge $position){ 
                #BREAK OUT OF THIS LOOP
                break 
            };

            #INCREMENT COUNTER (SO ENTRY 0 = CURRENT 1)
            $current++;
            #GET THE TITLE
            $numberOneTitle = $entry.ChildNodes[1].ChildNodes[0].ChildNodes[0].ChildNodes[2].InnerText;
            #GET THE ARTIST
            $numberOneArtist = $entry.ChildNodes[1].ChildNodes[0].ChildNodes[2].ChildNodes[0].InnerText;

            #INIT RETURN OBJECT
            $return = @{};
            $return.position = $current;
            $return.title = $numberOneTitle;
            $return.artist = $numberOneArtist;

            $returnArray = $returnArray + $return;
        }

        return $returnArray;
    }
}

#==================

#IMPORT THE CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1


#CHANGE THIS FLAG TO GET AI-GENERATED WIKI LINKS
$includeAIlinks = $false;


#GET API KEY FROM SECRET STORE
$keyFileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\api\apiKeys.json";
$keyFile = Get-Content -Path $keyFileName -Raw;
$keysJSON = ConvertFrom-Json $keyFile;
$apiKey = $keysJSON.keys.apiNinjas;

#BASE URLS
$eventsUrl = "https://api.api-ninjas.com/v1/historicalevents?"; 

#GET THE CURRENT DATE IN YYYY-MM-DD FORMAT
#$date = (Get-Date).ToString("yyyy-MM-dd");
$year = (Get-Date).ToString("yyyy");
$month = (Get-Date).ToString("MM");
#MONTH IN TEXT FOR HEADER OUTPUT
$monthName = (Get-Culture).DateTimeFormat.GetMonthName($month);
$day = (Get-Date).ToString("dd");

#THE FULL URL TO CALL
$url = $eventsUrl + "month=" + $month + "&day=" + $day;

#ADD API KEY TO HEADERS
$headers = @{
	'X-Api-Key' = $apiKey
};


#CALL THE API TO GET THE JSON
$json = Invoke-WebRequest $url -Headers $headers;

#CHECK THE JSON RETURN (IN CASE API FAILS)
Write-Output $json.Content;

#CONVERT THE JSON TO AN OBJECT
$content = ConvertFrom-Json $json.Content;

#GET DAY OF WEEK
$dayOfWeek = (get-date).DayOfWeek;

#GET TEST FOLDER
$testFolder = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\test\";
#GET WHO IS WORKING FROM HOME TODAY
$wfhStaff = Invoke-Expression -Command ($testFolder + "Get-WorkingFromHome.ps1");

#OUTPUT WHO IS WORKING FROM HOME TODAY
#$wfhStaff = ..\test\Get-WorkingFromHome.ps1;
$wfhText = [TextBlock]::new();
$wfhText.setText("Happy WFH day - " + $wfhStaff);
$wfhText.setWeight('bolder');
$wfhText.setSize('medium');

#==========================
# HEADING (FAMOUS EVENTS)
#==========================
$headerText = [TextBlock]::new();
$headerText.setText("Famous Events");
$headerText.setWeight('default');

$headerWord = [TextBlock]::new();
$headerWord.setText("$day $monthName");
$headerWord.setWeight('bolder');
$headerWord.setSize('extraLarge');

#PREPARE A CONTAINER TO STORE DEFINITIONS
$eventsContainer = [Container]::new();

#==========================
# ITERATE EVENTS
#==========================
Foreach($example in $content){

	$year = $example.year;
	$event = $example.event;
    $year = [int]$year;
	
	if($year -lt 0){
        $year = $year.toString();
        $year = $year.replace("-","");
		$year = $year + " BC";
	}
    
    #PART OF SPEECH
	$thisEvent = [TextBlock]::new();
    
    #FLAG SET AT TOP - INCLUDE A.I. LINKS?
    if($true -eq $includeAIlinks){

        #GET EDEN AI LINK
        Start-Sleep -Seconds 1; #PREVENT RATE LIMITING
        $question = 'what is the most appropriate wikipedia link for the following historical event?';
        $wikiLink = ..\utilities\Get-EdenAIAnswer.ps1 -question $question -text $event;
        #FORMAT LINK IN MARKDOWN [title](url)
        $wikiAnchor = '[' + $wikiLink + '](' + $wikiLink + ')';

        if($wikiLink.Length -gt 0){
	        $thisEvent.setText('In _' + $year + '_ - ' + $event + ' (see: ' + $wikiAnchor + ')');
	    }else{
            $thisEvent.setText('In _' + $year + '_ - ' + $event + ' (link not found)');
        }
    }else{
        $thisEvent.setText('In _' + $year + '_ - ' + $event);
    }

    $thisEvent.setSize('small');
	$thisEvent.setHorizontalAlignment('left');
	
	#ADD TO THE DEFINITION CONTAINER
	$eventsContainer.addItem($thisEvent.out());
}


#==========================
# NUMBER ONES SINGLES
#==========================

#IF TODAY IS FRIDAY
if($dayOfWeek -eq "Friday"){

    #NEW MUSIC FRIDAY
    $musicheaderText = [TextBlock]::new();
    $musicheaderText.setText("Top 10 Chart Friday!");
    $musicheaderText.setSize('extraLarge');
    $musicheaderText.setWeight('default');

    #PREPARE A CONTAINER TO STORE DEFINITIONS
    $numberOnesContainer = [Container]::new();

    $date = Get-Date;
    $positionsToGet = 10;
    $yearString = ($date).ToString("yyyyMMdd");

    $entries = Get-NumberOne -dateString $yearString -position $positionsToGet -fullChart $true;

    foreach($entry in $entries){
        $title = $entry.title;
        $artist = $entry.artist;
        $position = $entry.position;
        $thisNumberOne = [TextBlock]::new();
        $thisNumberOne.setText("At number _" + $position + "_ - '$title' by _" + $artist + "_");
        $thisNumberOne.setSize('small');
        $thisNumberOne.setHorizontalAlignment('left');
        #ADD TO THE DEFINITION CONTAINER
	    $numberOnesContainer.addItem($thisNumberOne.out());
    }

}else{

    #NUMBER ONES THROUGH THE YEARS
    $musicheaderText = [TextBlock]::new();
    $musicheaderText.setText("Number One Singles on this day");
    $musicheaderText.setSize('extraLarge');
    $musicheaderText.setWeight('default');

    #PREPARE A CONTAINER TO STORE DEFINITIONS
    $numberOnesContainer = [Container]::new();

    $date = Get-Date;

    $yearsArray = 0, 1, 5, 10, 25, 50; 

    foreach($yearBack in $yearsArray){
    
        $backDate = $date.AddYears('-' + $yearBack);
        $backDateShort = $backDate.ToString("yyyy");
        $yearString = ($backDate).ToString("yyyyMMdd");
        #Write-Host ("$yearBack years ago was: $yearString");
        $entry = Get-NumberOne -dateString $yearString;
        #$entry.yearsBack = $yearBack;
        $title = $entry.title;
        $artist = $entry.artist;
        #THIS NUMBER ONE
        #Write-Host ("The number one single $yearBack years ago ($backDateShort) was: $title by $artist");
        $thisNumberOne = [TextBlock]::new();
        $thisNumberOne.setText("In _" + $backDateShort + "_ - '$title' by _" + $artist + "_");
        $thisNumberOne.setSize('small');
        $thisNumberOne.setHorizontalAlignment('left');
        #ADD TO THE DEFINITION CONTAINER
	    $numberOnesContainer.addItem($thisNumberOne.out());
    }

}
#THE ENTIRE CONTENT IS ONE COLUMN/CONTAINER
$content = @(
    $wfhText.out(), 
	$headerText.out(), 
	$headerWord.out(), 
	$eventsContainer.out(),
    $musicheaderText.out(),
    $numberOnesContainer.out()
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

#SEND TO TEAMS
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;