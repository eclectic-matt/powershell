
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

#https://blog.snap.hr/24/09/2018/25-crazy-apis-next-project/

#GETTING ALL DINOS JUST TO COUNT HOW MANY IN TOTAL
#$url = 'https://dinosaur-facts-api.shultzlab.com/dinosaurs';
#$json = Invoke-WebRequest $url;
#$hashtable = @{}
#CONVERT THE JSON TO A HASHTABLE
#(ConvertFrom-Json $json).psobject.properties | ForEach-Object { $hashtable[$_.Name] = $_.Value }
#$count = $hashtable.Count;
#Write-output "Dino Count: $count";
#exit 1

#RANDOM DINO API
$url = "https://dinosaur-facts-api.shultzlab.com/dinosaurs/random";

#CALL THE API TO GET THE JSON
$json = Invoke-WebRequest $url;

#CHECK THE JSON RETURN (IN CASE API FAILS)
#Write-Output $json.Content;
#exit 1;

#PREPARE A HASHTABLE
$hashtable = @{}

#CONVERT THE JSON TO A HASHTABLE
(ConvertFrom-Json $json).psobject.properties | ForEach-Object { $hashtable[$_.Name] = $_.Value }


$name = replaceText($hashtable['Name']);
$output = "'<h1>The Dino of the Day is $name</h1>";
$description = replaceText($hashTable['Description']);
$output = -join($output, "<em>$description</em>");

#OUTPUT TO SCREEN FOR CHECKING
Write-Output $output;
#Pause;


#TESTING - GET GOOGLE IMAGES
$content = Invoke-RestMethod "https://www.google.com/search?q=$name+dinosaur&sxsrf=ALiCzsZ3iOWI-1dHX8uZnJkdXDfHkRSHtw:1658304343535&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiMnc2KgYf5AhV5QUEAHUp8AAkQ_AUoAXoECAEQAw&cshid=1658304366384794&biw=1368&bih=769&dpr=2";

#Write-Output $content;

$content -match '<img class="yWs4tf".*src="(?<imgSrc>.*)"/>';
#<img class="yWs4tf" alt="" src="

#Write-Output 'MATCHES: ';
#Write-Output $Matches.imgSrc;

$img = "<img width=200 height=200 src=";
$img = -join($img, $Matches.imgSrc);
$img = -join($img, " />'");

$output = -join($output, $img);
Write-Output $output;

#POST TO TEAMS
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 $output" > $silent; 