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

#GET THE RECENT UPDATES TO PREVENT DUPLICATION
$recentName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\data\recentF1News.json";
$recentFile = Get-Content -Path $recentName -Raw;
$recentJSON = ConvertFrom-Json $recentFile;
$recentArray = $recentJSON.recent;
$recentList = New-Object System.Collections.ArrayList($null)
$recentList.AddRange($recentArray);

$recentCount = $recentJSON.recentCount;
$updatesToSend = 0;

#SPECIAL CHARS TO ESCAPE
$bSlashChar = '&#92;';
$aposChar = '&#x27;';
$lQuoteChar = '&#8220;';#“
$rQuoteChar = '&#8221;';#”
$lAposChar = '&#8216;';#‘
$rAposChar = '&#8217;';#’

#GET DAY OF WEEK
$dayOfWeek = (get-date).DayOfWeek;
$resultsAndScheduleDay = "Wednesday";#SETTING THIS TO A NON-WORK DAY AS NO FUTURE COMPETITIONS 
#CHECKED THE ABOVE JAN 2025 - NO next RACES SHOWING

#IF TODAY IS THE SPECIAL RESULTS AND SCHEDULE DAY
if($dayOfWeek -eq $resultsAndScheduleDay){
    
    .\FormulaOne\Get-F1UpcomingEventsFromLocalJson.ps1;

    # NOW PREVENT IT FROM TRYING TO SEND A MESSAGE VIA THE CURRENT SCRIPT
    exit 0;
    
    
    
    <#
    
    #OUTPUT THE PREVIOUS RESULTS + UPCOMING SCHEDULE
    
    #SEND THE LAST RACE RESULTS BY CALLING THE SEPARATE SCRIPT!
    .\FormulaOne\Get-LastRaceResults.ps1;

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

    #>
}else{
    #OUTPUT NEWS   
    #STORE THE BASE URL
    $baseUrl = "https://www.racefans.net/feed/";

    #GET THE WEB PAGE DATA
    $rssFeed = Invoke-RestMethod -Uri $baseUrl;

    foreach($item in $rssFeed){

        #ESCAPE SPECIAL CHARACTERS
        $headline = $item.title;
        $headline = $headline.replace("\",$bSlashChar);
        $headline = $headline.replace("""",$aposChar);
        $headline = $headline.replace(""“",$lQuoteChar);
        $headline = $headline.replace(""”",$rQuoteChar);
        $headline = $headline.replace("‘",$lAposChar);
        $headline = $headline.replace("’",$rAposChar);

        if($recentList.Contains($item.guid.InnerText.ToString())){
            Write-Host "OLD NEWS - " + $headline;
            Write-Host "SKIPPING THIS NEWS - ALREADY SENT!";
        }else{
            #INCREMENT UPDATES TO SEND
            $updatesToSend++;
            #ADD TO THE RECENT LIST
            $recentList.Add($item.guid.InnerText.ToString()) > $silent;
            #NEW ENVIRO GENERATED - CHECK IF CAPACITY REACHED
            if( ($recentList.length + 1) -gt $recentCount){

                #REMOVE THE FIRST ELEMENT FROM THE RECENT LIST
                $recentList.Remove($recentList[0]) > $silent;
            }

            if($item.guid){
                #GENERATE A URL (guid)
                #$thisUrl = ($item.guid).ToString();
                $thisUrl = $item.guid.InnerText;
                #TURN INTO A MARKDOWN LINK [display](url)
                $thisUrlLink = ("[" + $thisUrl + "](" + $thisUrl + ")");
            }else{
                $thisUrlLink = "NO LINK AVAILABLE";
            }

            #STORE THIS NEWS UPDATE
            $thisHeadline = [TextBlock]::new();
            $thisHeadline.setText($headline);
            $thisHeadline.setSize('medium');
	        $thisHeadline.setHorizontalAlignment('left');
            
            #ADD TO THE DEFINITION CONTAINER
	        $eventsContainer.addItem($thisHeadline.out());

            #STORE THIS NEWS ITEM URL
	        $thisUrlText = [TextBlock]::new();
            $thisUrlText.setText($thisUrlLink);
            $thisUrlText.setSize('small');
	        $thisUrlText.setHorizontalAlignment('left');
	
	        #ADD TO THE DEFINITION CONTAINER
	        $eventsContainer.addItem($thisUrlText.out());
        }

    }

    #IF THERE IS AT LEAST 1 NEW NEWS HEADLINE - STORE TO RECENT AND OUTPUT
    if($updatesToSend -gt 0){
        #SENDING UPDATES - MODIFY RECENT LIST
        $recentHash = @{
            'recent' = @($recentList)
            'recentCount' = ($recentCount)
        }
        #STORE TO JSON FILE
        $newRecentJSON = $recentHash | ConvertTo-Json -Depth 3 | Out-File $recentName;
        #==========================
        # HEADING (LIVE F1 NEWS BLOG)
        #==========================
        $headerText = [TextBlock]::new();
        $headerText.setText("F1 Live Blog News - see [Race Fans.net](" + $baseUrl + ")");
        $headerText.setSize("extralarge");
        $headerText.setWeight('bolder');
    }else{
        #NO NEW NEWS
        $headerText = [TextBlock]::new();
        $headerText.setText("NO NEW NEWS ITEMS TODAY - CHECK ON [Race Fans.net](" + $baseUrl + ")");
        $headerText.setSize("extralarge");
        $headerText.setWeight('bolder');
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
#Write-Output $output;
#pause;
#exit 1;

#SEND TO TEAMS (Drinks Orders)
#Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true"" ""Drinks Orders""" > $silent;

#SEND TO TEAMS (General)
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;