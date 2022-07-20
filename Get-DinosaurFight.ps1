
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
$output = -join($output, "<table><tr>");

#DINO #1
$url = "https://dinosaur-facts-api.shultzlab.com/dinosaurs/random";
#CALL THE API TO GET THE JSON
$json = Invoke-WebRequest $url;
#PREPARE A HASHTABLE
$hashtable = @{}
#CONVERT THE JSON TO A HASHTABLE
(ConvertFrom-Json $json).psobject.properties | ForEach-Object { $hashtable[$_.Name] = $_.Value }
$nameOne = replaceText($hashtable['Name']);
$output = -join($output, "<td><b>$nameOne</b></td>");
#GET GOOGLE IMAGES
$content = Invoke-RestMethod "https://www.google.com/search?q=$nameOne+dinosaur&sxsrf=ALiCzsZ3iOWI-1dHX8uZnJkdXDfHkRSHtw:1658304343535&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiMnc2KgYf5AhV5QUEAHUp8AAkQ_AUoAXoECAEQAw&cshid=1658304366384794&biw=1368&bih=769&dpr=2";
#FIND THE FIRST <img>
$content -match '<img class="yWs4tf".*src="(?<imgSrc>.*)"/>' > $silent;
#GENERATE A NEW IMAGE TAG
$img = "<img width=200 height=200 src=";
$img = -join($img, $Matches.imgSrc);
$img = -join($img, " />");
#APPEND TO DINO FIGHT TABLE
$output = -join($output, "<td>");
$output = -join($output, $img);
$output = -join($output, "</td>");
$output = -join($output, "</tr>");

#ADD A ROW SHOWING "AND"
$output = -join($output, "<tr><td>AND</td></td></tr>");

#DINO #2
$output = -join($output, "<tr>");
#$output = -join($output, "<td>");
#CALL JSON
$json = Invoke-WebRequest $url;
#PREPARE A HASHTABLE
$hashtable = @{}
#CONVERT THE JSON TO A HASHTABLE
(ConvertFrom-Json $json).psobject.properties | ForEach-Object { $hashtable[$_.Name] = $_.Value }
$nameTwo = replaceText($hashtable['Name']);
$output = -join($output, "<td><b>$nameTwo</b></td>");
#GET GOOGLE IMAGES
$content = Invoke-RestMethod "https://www.google.com/search?q=$nameTwo+dinosaur&sxsrf=ALiCzsZ3iOWI-1dHX8uZnJkdXDfHkRSHtw:1658304343535&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiMnc2KgYf5AhV5QUEAHUp8AAkQ_AUoAXoECAEQAw&cshid=1658304366384794&biw=1368&bih=769&dpr=2";
#FIND THE FIRST <img>
$content -match '<img class="yWs4tf".*src="(?<imgSrc>.*)"/>' > $silent;
#GENERATE A NEW IMAGE TAG
$img = "<img width=200 height=200 src=";
$img = -join($img, $Matches.imgSrc);
$img = -join($img, " />");
#APPEND TO DINO FIGHT TABLE
$output = -join($output, "<td>");
$output = -join($output, $img);
$output = -join($output, "</td>");
$output = -join($output, "</tr>");
$output = -join($output, "</table>'");
#$output = -join($output, "</table>'""");

Write-Output $output;
#exit 1;

#$output = '"<table><tr><td><img width=200 height=200 src=https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRdvG9xMqyPjJ6p1TZTqES-WBTflQ0HzTQPKtQhBtbI59eFbr07WJkzopxlOqM&s /></td></tr></table>"';

#POST TO TEAMS
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 $output" > $silent; 