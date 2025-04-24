<#
	.Synopsis
	Get the word of the day and send via webhook
	
	.Version
	1.4

	.Description
	Get-WordOfTheDay gets a word of the day from the Wordnik API and posts to Teams.

	.Link
	https://developer.wordnik.com/docs#!/words/getWordOfTheDay
#>

#IMPORT THE CLASSES
#. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

<#
#GET THE INVOCATION PATH 
$splitPath = Split-Path $MyInvocation.MyCommand.Path;
#GET THE DIRECTORY FOR THIS FILE
$hooksFolder = Join-Path -Path $splitPath -ChildPath "";
#GET THE ROOT (POWERSHELL) FOLDER
$rootFolderPath = Split-Path -Path $splitPath -Parent -Resolve;
#THEN GET THE CHILD utilities DIRECTORY
$utilitiesFolder = Join-Path -Path $rootFolderPath -ChildPath "utilities";
#Write-Host ("UTILITIES PATH: " + $utilitiesFolder);
#IMPORT THE ADAPTIVE CARDS CLASSES
. "$utilitiesFolder\AdaptiveCards\Classes\Imports.ps1"
#>

#GET THE API FOLDER IN THE ROOT DIR
#$apiKeysFolder = Join-Path -Path $rootFolderPath -ChildPath "api";

#GET API KEY FROM SECRET STORE
$keyFileName = "$apiKeysFolder\apiKeys.json";
$keyFile = Get-Content -Path $keyFileName -Raw;
$keysJSON = ConvertFrom-Json $keyFile;
$apiKey = $keysJSON.keys.wordnik;

#BASE URLS
#$randomWordUrl = "http://api.wordnik.com/v4/words.json/randomWord?api_key=";
$wordOfTheDayUrl = "https://api.wordnik.com/v4/words.json/wordOfTheDay?date="; 

#GET THE CURRENT DATE IN YYYY-MM-DD FORMAT
$date = (Get-Date).ToString("yyyy-MM-dd");

#A JOIN WITHIN THE CONCATENATED URL
$joiner = "&api_key=";

#THE FULL URL TO CALL
$url = $wordOfTheDayUrl + $date + $joiner + $apiKey;

#CALL THE API TO GET THE JSON
$json = Invoke-WebRequest $url;

#CHECK THE JSON RETURN (IN CASE API FAILS)
Write-Output $json.Content;
#exit 1;

#PREPARE A HASHTABLE
$hashtable = @{}

#CONVERT THE JSON TO A HASHTABLE
(ConvertFrom-Json $json).psobject.properties | ForEach-Object { $hashtable[$_.Name] = $_.Value }

#THE WORD ITSELF IS THE TOP "word" - NOW CALLING THE REPLACE FUNCTION JUST IN BLOODY CASE
$wordOfTheDay = $hashtable["word"];
$wordOfTheDay = $wordOfTheDay.ToUpper();


#==========================
# HEADING (WORD OF THE DAY)
#==========================
$headerText = [TextBlock]::new();
$headerText.setText("The Word of the Day is:");
$headerText.setWeight('default');

$headerWord = [TextBlock]::new();
$headerWord.setText("$wordOfTheDay");
$headerWord.setWeight('bolder');
$headerWord.setSize('extraLarge');



	#==============================
	#EXTRA - GET THE LAST DAY OF THE MONTH
	#$firstDate = [DateTime]::new($(get-date).Year, (get-date).Month, 1);
	#$lastDate=$firstDate.AddMonths(1).AddDays(-1);
	#Write-Output $lastdate;

	#$checkDate = (get-date).ToString("yyyy-MM-dd"); 
	#$ts = New-TimeSpan -Start $checkDate  -End $lastDate;
	#$daysUntilBdx = $ts.Days;
    #=========

    #EXTRA - GET THE FIRST DAY OF NEXT MONTH
    $firstDate = [DateTime]::new($(get-date).Year, (get-date).Month + 1, 1);
    $checkDate = (get-date).ToString("yyyy-MM-dd"); 
	$ts = New-TimeSpan -Start $checkDate  -End $firstDate;
	$daysUntilBdx = $ts.Days;
    #=========

    <#
    #EXTRA - GET FIRST WEEKDAY OF THE MONTH (NOT WORKING YET)
    $firstDate = [DateTime]::new($(get-date).Year, (get-date).Month, 1);
    #ITERATE FOR 7 DAYS UNTIL WEEKDAY REACHED
    for($i = 1..7){
        $testDate = [DateTime]::new($(get-date).Year, (get-date).Month, $i);
        $dayOfWeek = $testDate -UFormat %u;
        if($dayOfWeek -ge 0 -And $dayOfWeek -le 5){
            break;
        }
    }
    #>


	$daysLeftInMonth = [TextBlock]::new();
	$daysLeftInMonth.setSize('small');
	$daysLeftInMonth.setStyle('heading');
	$daysLeftInMonth.setText("Days left until BDX: $daysUntilBdx days");
	$daysLeftInMonth.setWeight('bolder');
	#END EXTRA
	#==============================

#==========================
# NOTE
#==========================
if($hashtable.ContainsKey('note')){

	#GET NOTE TEXT
	$note = $hashtable['note'];

	#OUTPUT NOTE HEADER
	$noteText = [TextBlock]::new();
	$noteText.setText('Note:');
	$noteText.setWeight('bolder');
	$noteText.setHorizontalAlignment('left');
	#OUTPUT NOTE TEXT
	$noteDesc = [TextBlock]::new();
	$noteDesc.setText('_' + $note + '_');
	$noteDesc.setWeight('default');
	$noteDesc.setHorizontalAlignment('left');
}


#==========================
# DEFINITIONS (ALWAYS INCLUDED)
#==========================
$defineText = [TextBlock]::new();
$defineText.setText('Definition(s):');
$defineText.setWeight('bolder');
$defineText.setHorizontalAlignment('left');

#PREPARE A CONTAINER TO STORE DEFINITIONS
$defineContainer = [Container]::new();

#ITERATE THROUGH EACH OF THE DEFINITIONS
Foreach($definition in $hashtable['definitions']){
	
	#CALL REPLACE FUNCTION ON DEFINITION PART OF SPEECH (SURELY NOT, BUT SCREW IT)
	$definitionPartOfSpeech = $definition."partOfSpeech";

	#CALL REPLACE FUNCTION ON DEFINITION TEXT
	$definitionText = $definition."text";

	#PART OF SPEECH
	$thisDefPart = [TextBlock]::new();
	$thisDefPart.setText('- _(' + $definitionPartOfSpeech + ')_ ' + $definitionText);
	$thisDefPart.setSize('small');
	$thisDefPart.setHorizontalAlignment('left');
	
	#ADD TO THE DEFINITION CONTAINER
	$defineContainer.addItem($thisDefPart.out());
}


#==========================
# EXAMPLES
#==========================


#IF THE RESULTS CONTAIN EXAMPLES
if($hashtable.ContainsKey('examples')){


    #PREPARE A CONTAINER TO STORE EXAMPLES
    $exampleContainer = [Container]::new();

	#OUTPUT EXAMPLE HEADER
	$exampleHeader = [TextBlock]::new();
	$exampleHeader.setText('Example(s):');
	$exampleHeader.setWeight('bolder');
	$exampleHeader.setHorizontalAlignment('left');
	$exampleContainer.addItem($exampleHeader.out());

	#ITERATE THROUGH THE EXAMPLES
	foreach($example in $hashtable['examples']){

		#GET THE EXAMPLE TITLE
		$exampleTitle = $example."title";
		$exampleTitle = $exampleTitle.Trim();

		#IS THERE A LINK TO THIS EXAMPLE
		if($example."url" -ne ""){

			#GET THE URL
			$exampleUrl = $example."url";
		}else{

			#ADD NO URL
			$exampleUrl = "N/A";
		}

		#GET THE EXAMPLE TEXT
		$exampleText = $example."text";

		#ADD A TEXT BLOCK FOR THIS EXAMPLE
		$exampleTitleText = [TextBlock]::new();
		$exampleTitleText.setText("- From [$exampleTitle]($exampleUrl) _''" + $exampleText + "''_");
		$exampleTitleText.setSize('small');
		$exampleTitleText.setHorizontalAlignment('left');
		
		#ADD THIS EXAMPLE TO THE CONTAINER
		$exampleContainer.addItem($exampleTitleText.out());
	}


    #THE ENTIRE CONTENT IS ONE COLUMN/CONTAINER
    $content = @(
        $daysLeftInMonth.out(),
	    $headerText.out(), 
	    $headerWord.out(), 
	    $noteText.out(), 
	    $noteDesc.out(), 
	    $defineText.out(), 
	    $defineContainer.out(),
	    $exampleContainer.out()
    );
}else{

    #THE ENTIRE CONTENT IS ONE COLUMN/CONTAINER
    $content = @(
        $daysLeftInMonth.out(),
	    $headerText.out(), 
	    $headerWord.out(),	
	    $noteText.out(), 
	    $noteDesc.out(), 
	    $defineText.out(), 
	    $defineContainer.out()
    );

}


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

#SEND TO TEAMS
Invoke-Expression -Command "$utilitiesFolder\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;