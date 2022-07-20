
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

#START OUTPUT
#$output = """'<h1>Dino Fight!</h1>";
$output = "'<h1>Dino Fight!</h1>";
$output = -join($output, "<b>Who will win in this match up between:</b>");
$output = -join($output, "<br><br>");
$output = -join($output, "<table>");

#SAME URL
$url = "https://dinosaur-facts-api.shultzlab.com/dinosaurs/random";

#DINO #1
#CALL THE API TO GET THE JSON
$json = Invoke-WebRequest $url;
#PREPARE A HASHTABLE
$hashtable = @{}
#CONVERT THE JSON TO A HASHTABLE
(ConvertFrom-Json $json).psobject.properties | ForEach-Object { $hashtable[$_.Name] = $_.Value }
$nameOne = replaceText($hashtable['Name']);
$descOne = replaceText($hashTable['Description']);
#GET GOOGLE IMAGES
$content = Invoke-RestMethod "https://www.google.com/search?q=$nameOne+dinosaur&sxsrf=ALiCzsZ3iOWI-1dHX8uZnJkdXDfHkRSHtw:1658304343535&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiMnc2KgYf5AhV5QUEAHUp8AAkQ_AUoAXoECAEQAw&cshid=1658304366384794&biw=1368&bih=769&dpr=2";
#FIND THE FIRST <img>
$content -match '<img class="yWs4tf".*src="(?<imgSrc>.*)"/>' > $silent;
#GENERATE A NEW IMAGE TAG
#$imgOne = "<img width=200 height=200 src=";
$imgOne = "<img width=275 height=200 aspect-ratio=auto 275/200; src=";
$imgOne = -join($imgOne, $Matches.imgSrc);
$imgOne = -join($imgOne, " />");

#DINO #2
$json = Invoke-WebRequest $url;
#PREPARE A HASHTABLE
$hashtable = @{}
#CONVERT THE JSON TO A HASHTABLE
(ConvertFrom-Json $json).psobject.properties | ForEach-Object { $hashtable[$_.Name] = $_.Value }
$nameTwo = replaceText($hashtable['Name']);
$descTwo = replaceText($hashTable['Description']);
#GET GOOGLE IMAGES
$content = Invoke-RestMethod "https://www.google.com/search?q=$nameTwo+dinosaur&sxsrf=ALiCzsZ3iOWI-1dHX8uZnJkdXDfHkRSHtw:1658304343535&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiMnc2KgYf5AhV5QUEAHUp8AAkQ_AUoAXoECAEQAw&cshid=1658304366384794&biw=1368&bih=769&dpr=2";
#FIND THE FIRST <img>
$content -match '<img class="yWs4tf".*src="(?<imgSrc>.*)"/>' > $silent;

#GENERATE A NEW IMAGE TAG
#width: 275px;
#aspect-ratio: auto 275 / 184;
#height: 184px;
#$imgOne = "<img width=200 height=200 src=";
$imgTwo = "<img width=275 height=200 aspect-ratio=auto 275/200; src=";
$imgTwo = -join($imgTwo, $Matches.imgSrc);
$imgTwo = -join($imgTwo, " />");


#OUTPUT NAMES ROW
$output = -join($output, "<tr>");
    #NAME ONE
    $output = -join($output, "<td><h1 style=text-align:right;>");
    $output = -join($output, $nameOne);
    $output = -join($output, "</h1></td>");
    #VS
    $output = -join($output, "<td>");
    $output = -join($output, " vs. ");
    $output = -join($output, "</td>");
    #NAME TWO
    $output = -join($output, "<td><h1>");
    $output = -join($output, $nameTwo);
    $output = -join($output, "</h1></td>");
$output = -join($output, "</tr>");

#OUTPUT DESCRIPTION ROW
$output = -join($output, "<tr>");
    #NAME ONE
    $output = -join($output, "<td>");
    $output = -join($output, "<em style=text-align:right;>");
    $output = -join($output, $descOne);
    $output = -join($output, "</em>");
    $output = -join($output, "</td>");
    #VS
    $output = -join($output, "<td>");
    $output = -join($output, "</td>");
    #NAME TWO
    $output = -join($output, "<td>");
    $output = -join($output, "<em>");
    $output = -join($output, $descTwo);
    $output = -join($output, "</em>");
    $output = -join($output, "</td>");
$output = -join($output, "</tr>");

#OUTPUT IMAGE ROW
$output = -join($output, "<tr>");
    #NAME ONE
    $output = -join($output, "<td style=text-align:right;>");
    $output = -join($output, $imgOne);
    $output = -join($output, "</td>");
    #VS
    $output = -join($output, "<td>");
    $output = -join($output, "</td>");
    #NAME TWO
    $output = -join($output, "<td>");
    $output = -join($output, $imgTwo);
    $output = -join($output, "</td>");
$output = -join($output, "</tr>");

$output = -join($output, "</table>'");

Write-Output $output;
#exit 1;

#POST TO TEAMS
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 $output" > $silent; 
