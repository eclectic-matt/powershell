<#
	.Synopsis
	Get famous historical events and send via webhook
	
	.Version
	1.0

	.Description
	Get-FamousEvents gets famous events via API and posts to Teams.

	.Link
	https://api-ninjas.com/api/historicalevents
#>

#IMPORT THE CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

#THE SECRET API KEY
$apiKey = "ddamSQu7TAik0QiR/gF2dA==i9xkNltpKnzhO5PD";

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
	$year = $year.replace("-","");
	
	if($year -lt 0){
		$year = $year + " BC";
	}

	#PART OF SPEECH
	$thisEvent = [TextBlock]::new();
	$thisEvent.setText('In _' + $year + '_ - ' + $event);
	$thisEvent.setSize('small');
	$thisEvent.setHorizontalAlignment('left');
	
	#ADD TO THE DEFINITION CONTAINER
	$eventsContainer.addItem($thisEvent.out());
}

#THE ENTIRE CONTENT IS ONE COLUMN/CONTAINER
$content = @(
	$headerText.out(), 
	$headerWord.out(), 
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
Write-Output $output;
#pause;
#exit 1;

#SEND TO TEAMS
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;