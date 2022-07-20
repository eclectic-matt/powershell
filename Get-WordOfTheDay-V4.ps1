<#
WORD OF THE DAY - VERSION 4
.Description
	Get-WordOfTheDay gets a word of the day from the Wordnik API and posts to Teams.
	SEE: https://developer.wordnik.com/docs#!/words/getWordOfTheDay
#>

function replaceText{
	param (
		$text,
		$replaceChar = '~'
	);
	#REPLACE '
	$text = $text.replace("'",$replaceChar);
	#REPLACE "
	$text = $text.replace('"',$replaceChar);
	#REPLACE \ WITH -
	$text = $text.replace("\","-");
	#REPLACE / WITH -
	$text = $text.replace("/","-");
	return $text;
}

#THE SECRET API KEY
$apiKey  = "n9xlxzuxfh49f70x4qh3s31d5cse9s11f7yvt9zd7jczt1hn3";

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
#Write-Output $json.Content;
#exit 1;

#PREPARE A HASHTABLE
$hashtable = @{}

#CONVERT THE JSON TO A HASHTABLE
(ConvertFrom-Json $json).psobject.properties | ForEach-Object { $hashtable[$_.Name] = $_.Value }

#THE WORD ITSELF IS THE TOP "word" - NOW CALLING THE REPLACE FUNCTION JUST IN BLOODY CASE
$wordOfTheDay = replaceText($hashtable["word"]);


#==========================
# HEADING (WORD OF THE DAY)
#==========================
$output = "'<h1>The Word of the Day is: <b>";
$output = -join($output,$wordOfTheDay);
$output = -join($output,"</b></h1><br>");


#==========================
# NOTE
#==========================
if($hashtable.ContainsKey('note')){

	#GET NOTE TEXT
	$note = $hashtable['note'];
	#CALL REPLACE FUNCTION ON NOTE
	$note = replaceText($note);
	#OUTPUT NOTE
	$output = -join($output,"<h2>Note:</h2>");
	$output = -join($output,"<em>");
	$output = -join($output,$note);
	$output = -join($output,"</em>");
	$output = -join($output,"<br><br>");
}


#==========================
# DEFINITIONS (ALWAYS INCLUDED)
#==========================
$output = -join($output,"<h2>Definition(s):</h2><ul>");

Foreach($definition in $hashtable['definitions']){
	
	#OUTPUT THIS DEFINITION
	$output = -join($output, "<li><em>");
	$output = -join($output, "<b>");
	#CALL REPLACE FUNCTION ON DEFINITION PART OF SPEECH (SURELY NOT, BUT SCREW IT)
	$definitionPartOfSpeech = replaceText($definition."partOfSpeech");
	$output = -join($output,$definitionPartOfSpeech);
	$output = -join($output, "</b>, ");

	#CALL REPLACE FUNCTION ON DEFINITION TEXT
	$definitionText = replaceText($definition."text");
	$output = -join($output, $definitionText);
	$output = -join($output, "</em></li>");
}
#CLOSE DEFINITION LIST
$output = -join($output,"</ul>");
$output = -join($output,"<br>");


#==========================
# EXAMPLES
#==========================
if($hashtable.ContainsKey('examples')){

	$output = -join($output,"<h2>Example(s):</h2><ul>");

	foreach($example in $hashtable['examples']){

		$output = -join($output,"<li><b>From: ~");
		#CALL REPLACE FUNCTION ON EXAMPLE TITLE
		$exampleTitle = replaceText($example."title");
		$output = -join($output,$exampleTitle);
		$output = -join($output,"~</b><br>");
		#TRYING TO GET LINK TO EXAMPLE, BUT NEED TO SOMEHOW ESCAPE THE "" AROUND HREF
		if($example."url" -ne ""){

			$output = -join($output, "[Link](");

			#Invoke-WebRequest : Bad payload received by generic incoming webhook.
			#$output = -join($output, "Link: <a href=\""");

			$output = -join($output, $example."url");
			
			#Invoke-WebRequest : Bad payload received by generic incoming webhook.
			#$output = -join($output, "\"">View Online</a><br>");

			$output = -join($output, ")<br>");
		}
		$output = -join($output,"<em>");
		#CALL REPLACE FUNCTION ON EXAMPLE TEXT
		$exampleText = replaceText($example."text");
		$output = -join($output,$exampleText);
		$output = -join($output,"</em></li>");
	}

	$output = -join($output,"</ul>'");
}

#OUTPUT TO SCREEN FOR CHECKING
Write-Output $output;
#exit 1;

#POST TO TEAMS
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 $output" > $silent; 