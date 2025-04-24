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

#Cls;

#PREPARE A CONTAINER TO STORE DEFINITIONS
$eventsContainer = [Container]::new();

#GET THE RECENT UPDATES TO PREVENT DUPLICATION
$recentName = "$hooksFolder\data\recentF1News.json";
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

        #THE ENTIRE CONTENT IS ONE COLUMN/CONTAINER
        $content = @(
	        $headerText.out(), 
	        $eventsContainer.out()
        );
    }else{
        #NO NEW NEWS
        $headerText = [TextBlock]::new();
        $headerText.setText("NO NEW NEWS ITEMS TODAY - CHECK ON [Race Fans.net](" + $baseUrl + ")");
        $headerText.setSize("extralarge");
        $headerText.setWeight('bolder');

        #THE ENTIRE CONTENT IS ONE COLUMN/CONTAINER
        $content = @(
	        $headerText.out()
        );
    }

}


#=================




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
$output | Set-Content -Path "$hooksFolder\lastCardOutput.json" -Encoding 'UTF8';

#SEND TO TEAMS (General)
Invoke-Expression -Command "$utilitiesFolder\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;

#SEND TO TEAMS (Drinks Orders)
#Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true"" ""Drinks Orders""" > $silent;