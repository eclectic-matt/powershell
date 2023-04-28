# IMPORT ADAPTIVE CARD CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1


function New-DailyGreek{
    param(
        [Parameter(Mandatory=$true)] [System.Object]$json
    )

    Write-Host $json.name;

	#Get culture (quick convert to title case)
	$textInfo = (Get-Culture).TextInfo

	$greekName = $json.greekName;#.ToUpper();
	$romanName = $json.romanName;#.ToUpper();
    $greekRole = $json.role;

	#$greekLink = "https://en.wikipedia.org/wiki/" 
    #$greekLink = -concat($greekLink,$greekName);

    $greekLink = "https://en.wikipedia.org/wiki/" + $greekName;

    Write-Host $greekLink;

	Write-Host "Loading $greekName image from JSON link";
	$img = $json.img;

	#GENERATE AN IMAGE ELEMENT
	$image = [Image]::new();
	$image.setUrl($img);
	$image.setSize('extralarge');

	#GENERATE THE CARD USING FUNCTIONS 
	$nameText = [TextBlock]::new();
	$nameText.setText($greekName);
	$nameText.setSize('large');
	$nameText.setFontType('monospace');
	$nameText.setWeight('bolder');
	
	#PREPARE FACTS ARRAY
	$facts = [FactSet]::new();
	$factArr = @();

	#ADD FACTS
	$fact = [Fact]::new();
	$fact.setTitle("Alternative Name");
	$fact.setValue("$romanName");
	$factArr = $factArr + $fact.out();
    
    #ADD FACTS
	$fact = [Fact]::new();
	$fact.setTitle("Role");
	$fact.setValue("$greekRole");
	$factArr = $factArr + $fact.out();

    #SET FACTS ARRAY TO FACTBLOCK
	$facts.setFacts($factArr);

	if($null -ne $image){
		$content = @($nameText.out(), $facts.out(), $image.out());
	}else{
		$content = @($nameText.out(), $facts.out());
	}

    #Write-Host $content;

    #RESET GREEK LINK
	$greekLink = "https://en.wikipedia.org/wiki/" + $greekName;
	
    #ADD ACTION.OPENURL
    $action = [ActionOpenUrl]::new($greekLink,"View $greekName on Wikipedia");

	#STORE IN A CONTAINER
	$greekContainer = [Container]::new();
	$greekContainer.setItems($content);
	$greekContainer.setSelectAction($action.out());

    Write-Host $greekContainer.out();
	#return $content;
	return $greekContainer;
}




#LOAD JSON
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\greekList.json";
$file = Get-Content -Path $fileName;
#4 LINES (2 AT START, 2 AT END) DO NOT CONTAIN DINO INFO
$greekCount = $file.length - 4;

#GENERATE A RANDOM GREEK ID
$greekId = Get-Random -Minimum 3 -Maximum ($greekCount - 2)
#SET INDEX TO 0
$index = 0;

#ITERATE THROUGH THE FILE CONTENTS
foreach($line in $file){

	#IF WE ARE AT THE FIRST GENERATED LINE INDEX
	if($index -eq $greekId){

	Write-Host "Hit $index - getting the Greek"

		#GET THE LAST CHARACTER (CHECK FOR ",")
		$lastChar = $line.Substring($line.Length - 1);
		#IF THE LAST CHARACTER IS A COMMA
		if($lastChar -eq ","){
			#UPDATE LINE TO DROP THE TRAILING COMMA
			$line = $line.Substring(0,$line.Length - 1);
		}
		#CONVERT THIS LINE TO JSON
		$json = ConvertFrom-Json $line;

		#PASS TO FUNCTION TO GENERATE CONTENT
		$greekCardOne = New-DailyGreek -json $json;
	}

	#INCREMENT LINE INDEX
	$index += 1;
}

$columnLeft = [Column]::new();
$columnLeft.setItems($greekCardOne.out());

$columns = [ColumnSet]::new();
$columns.addColumn($columnLeft.out());

$headerText = [TextBlock]::new();
$headerText.setText('DEITY OF THE DAY(ITY)');
$headerText.setSize('extraLarge');
$headerText.setWeight('bolder');

$content = @($headerText.out(), $columns.out());
#Write-Host $content;

#SET THIS AS THE ADAPTIVE CARD CONTENT
$card = [AdaptiveCard]::new($content);

#WRAP THE ADAPTIVE CARD IN A MESSAGE (.out NOT SUITABLE HERE?)
[Message]$message = [Message]::new($card.object);

#FOR SOME REASON card.out() IS NOT WORKING
#$message = [Message]::new($card.out());

#STRINGIFY THE FINAL MESSAGE - THIS *MUST* USE THE out() METHOD
$output = $message.out();

#SAVE TO FILE (lastCardOutput.json)
#$content | Set-Content -Path $textFile -Encoding $encoding
$output | Set-Content -Path "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\lastCardOutput.json" -Encoding 'UTF8';
#$output > "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\lastCardOutput.json";
#exit 1;
#Write-Host $output;
#SEND TO TEAMS
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;