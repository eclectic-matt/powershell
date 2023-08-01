# IMPORT ADAPTIVE CARD CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1



#TESTING - CLEAR BETWEEN RUNS
#Cls
#TESTING

#FUNCTION TO GENERATE A DINO "TOP TRUMP" COLUMN IN ADAPTIVE CARD FORMAT
function New-DinoTopTrump{
	param(
		[Parameter(Mandatory=$true)] [System.Object]$json
	)

    Write-Host $json.name;

	#Get culture (quick convert to title case)
	$textInfo = (Get-Culture).TextInfo

	$dinoName = $json.name.ToUpper();
	$dinoNameLower = $json.name.ToLower();
	$dinoPeriod = $textInfo.ToTitleCase($json.period_name);
	$dinoFrom = $json.period_start_mya;
	$dinoTo = $json.period_end_mya;
	$dinoDiet = $textInfo.ToTitleCase($json.diet);
	if($json.length -eq ""){
		$dinoLength = "Unknown";
	}else{
		$dinoLength = $json.length;
	}
	$dinoLocation = $textInfo.ToTitleCase($json.lived_in);
	$dinoType = $textInfo.ToTitleCase($json.type);
	$dinoSpecies = $textInfo.ToTitleCase($json.species);
	$dinoNamedBy = $textInfo.ToTitleCase($json.named_by);
	$dinoNamedByDate = $textInfo.ToTitleCase($json.named_date);
	$dinoLink = $json.link;

	Write-Host "Loading $dinoName image from web scrape";
	#GET IMAGE FROM NATURAL HISTORY MUSEUM WEBSITE (DINO LINK)
	$content = Invoke-RestMethod $dinoLink;
	#FIND THE FIRST <img>
	$content -match '<img class="dinosaur--image".*src="(?<imgSrc>.*)" ' > $silent;
	#GENERATE A NEW IMAGE TAG
	$img = $Matches.imgSrc;

	#GENERATE AN IMAGE ELEMENT
	$image = [Image]::new();
	$image.setUrl($img);
	$image.setSize('extralarge');

	#GENERATE THE CARD USING FUNCTIONS 
	$nameText = [TextBlock]::new();
	$nameText.setText($dinoName);
	$nameText.setSize('large');
	$nameText.setFontType('monospace');
	$nameText.setWeight('bolder');
	
	#PREPARE FACTS ARRAY
	$facts = [FactSet]::new();
	$factArr = @();

	#ADD FACTS
	$fact = [Fact]::new();
	$fact.setTitle("Period");
	$fact.setValue("$dinoPeriod");
	$factArr = $factArr + $fact.out();
	#$facts.addFact($fact.object);

	$fact = [Fact]::new();
	$fact.setTitle("From");
	$fact.setValue("$dinoFrom million years ago");
	$factArr = $factArr + $fact.out();
	#$facts.addFact($fact.object);

	$fact = [Fact]::new();
	$fact.setTitle("To");
	$fact.setValue("$dinoTo million years ago");
	$factArr = $factArr + $fact.out();
	#$facts.addFact($fact.object);

	$fact = [Fact]::new();
	$fact.setTitle("Diet");
	$fact.setValue("$dinoDiet");
	$factArr = $factArr + $fact.out();
	#$facts.addFact($fact.object);
	
	$fact = [Fact]::new();
	$fact.setTitle("Length");
	$fact.setValue("$dinoLength");
	$factArr = $factArr + $fact.out();
	#$facts.addFact($fact.object);

	$fact = [Fact]::new();
	$fact.setTitle("Location");
	$fact.setValue("$dinoLocation");
	$factArr = $factArr + $fact.out();
	#$facts.addFact($fact.object);
	
	$fact = [Fact]::new();
	$fact.setTitle("Type");
	$fact.setValue("$dinoType");
	$factArr = $factArr + $fact.out();
	#$facts.addFact($fact.object);
	
	$fact = [Fact]::new();
	$fact.setTitle("Species");
	$fact.setValue("$dinoSpecies");
	$factArr = $factArr + $fact.out();
	#$facts.addFact($fact.object);

	$fact = [Fact]::new();
	$fact.setTitle("Namer(s)");
	$fact.setValue("$dinoNamedBy");
	$factArr = $factArr + $fact.out();
	#$facts.addFact($fact.object);
	
	$fact = [Fact]::new();
	$fact.setTitle("Named");
	$fact.setValue("$dinoNamedByDate");
	$factArr = $factArr + $fact.out();
	#$facts.addFact($fact.object);

	$facts.setFacts($factArr);

	if($null -ne $image){
		$content = @($nameText.out(), $facts.out(), $image.out());
	}else{
		$content = @($nameText.out(), $facts.out());
	}
    #Shows &
    #Write-Host $content;

	#ADD ACTION.OPENURL
	$action = [ActionOpenUrl]::new($dinoLink,"View $dinoName on NHM");
	#$action = [ActionOpenUrl]::new($imgUrl,"View $dinoName image?");

	#STORE IN A CONTAINER
	$dinoContainer = [Container]::new();
	$dinoContainer.setItems($content);
	$dinoContainer.setSelectAction($action.out());

    Write-Host $dinoContainer.out();
	#return $content;
	return $dinoContainer;
}


#===================
# DINO
#===================
#LOAD JSON
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\dinoList.json";
#LOAD JSON (LIMITED, TESTING ADDING DINOS)
#$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\dinoList_LIMITED.json";
$file = Get-Content -Path $fileName;
#4 LINES (2 AT START, 2 AT END) DO NOT CONTAIN DINO INFO
$dinoCount = $file.length - 4;

#GENERATE TWO RANDOM DINO IDs
$dinoOneId = Get-Random -Minimum 3 -Maximum ($dinoCount - 2)
$index = 0;

#ITERATE THROUGH THE FILE CONTENTS
foreach($line in $file){

	#IF WE ARE AT THE FIRST GENERATED LINE INDEX
	if($index -eq $dinoOneId){

	Write-Host "Hit $index - getting Dino 1"

		#GET THE LAST CHARACTER (CHECK FOR ",")
		$lastChar = $line.Substring($line.Length - 1);
		#IF THE LAST CHARACTER IS A COMMA
		if($lastChar -eq ","){
			#UPDATE LINE TO DROP THE TRAILING COMMA
			$line = $line.Substring(0,$line.Length - 1);
		}
		#CONVERT THIS LINE TO JSON
		$json = ConvertFrom-Json $line;
        #$dinoName = $json.name;
        #$json = $line | ConvertTo-Json -Depth 50 | % { [System.Text.RegularExpressions.Regex]::Unescape($_) }
        #$json = $line | ConvertTo-Json | % { [System.Text.RegularExpressions.Regex]::Unescape($_) }
        
		#OUTPUT TO SCREEN
		#Write-Host $json.name;

		#PASS TO FUNCTION TO GENERATE CONTENT
		$dinoCardOne = New-DinoTopTrump -json $json;
	}

	#INCREMENT LINE INDEX
	$index += 1;
}

#LEFT COLUMN - THE DINO IMAGE
$columnLeft = [Column]::new();
$columnLeft.setItems($dinoCardOne.out());



#===================
# ENVIRO
#===================
#GET RECENT ENVIROS LIST
$recentName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\recentEnviros.json";
$recentFile = Get-Content -Path $recentName -Raw;
$recentJSON = ConvertFrom-Json $recentFile;
$recentArray = $recentJSON.recent;
$recentList = New-Object System.Collections.ArrayList($null)
$recentList.AddRange($recentArray);

$recentCount = $recentJSON.recentCount;

#LOAD JSON TO GET RANDOM ENVIRO
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\enviroList.json";
$file = Get-Content -Path $fileName -Raw;
$json = ConvertFrom-Json $file;
$enviroList = $json.enviroList;
$enviroCount = $enviroList.length;

#SET THE ENVIRONAME TO THE FIRST NAME ON THE LIST
$enviroName = $recentList[0];

#WHILE THE CURRENTLY GENERATED ENVIRO IS IN THE RECENT LIST
while ($recentList.Contains($enviroName)){

    #GET A NEW RANDOM ENVIRO
    $enviroId = Get-Random -Minimum 0 -Maximum ($enviroCount)
    $enviroName = $enviroList[$enviroId];
    #Write-Output ("Trying " + $enviroName);
}

#NEW ENVIRO GENERATED - CHECK IF CAPACITY REACHED
if( ($recentList.length + 1) -gt $recentCount){

    #REMOVE THE FIRST ELEMENT FROM THE RECENT LIST
    $recentList.Remove($recentList[0]) > $silent;
}

#THEN STORE THE NEW ENVIRO ON THE LIST
$recentList.Add($enviroName) > $silent;

$recentHash = @{
    'recent' = @($recentList)
    'recentCount' = ($recentCount)
}

#STORE TO JSON FILE
$newRecentJSON = $recentHash | ConvertTo-Json -Depth 3 | Out-File $recentName;


#GET URL SUITABLE ENVIRO NAME
$enviro = $enviroName.replace(" ", "\%20");

#GET A RANDOM STYLE (FOR AI GENERATOR)
$styleName = ..\utilities\Get-RandomStyle.ps1;

#ADD THIS STYLE NAME TO THE PROMPT
$enviro = ($enviro + ", " + $styleName);
$enviroName = ($enviroName + ", " + $styleName);
Write-Output "FULL PROMPT: $enviroName";

#exit 1;
<#
#FORCE AN ENVIRONMENT
$enviroName = "in front of that massive bean in america";
$enviro = $enviroName.replace(" ", "%20");
#>

#RIGHT COLUMN - THE ENVIRONMENT
#$imageUrl = ..\utilities\Get-EdenAIImage.ps1 $enviro;
#Write-Output $imageUrl;
$imageData = ..\utilities\Get-EdenAIImage.ps1 $enviroName;
$imageUrl = $imageData.image_resource_url;
$imageEncode = ("data:image/jpeg;base64," + $imageData.image);


#MAKE THE NAME UPPERCASE
$enviroName = $enviroName.ToUpper();

$enviroText = [TextBlock]::new();
$enviroText.setText($enviroName);
$enviroText.setSize('large');
$enviroText.setFontType('monospace');
$enviroText.setWeight('bolder');

$image = [Image]::new();
$image.setUrl($imageEncode);
$enviroContent = @($enviroText.out(), $image.out());

#GO TO IMAGE LINK
$action = [ActionOpenUrl]::new($imageUrl,"View this image on EdenAI");

#STORE IN A CONTAINER
$enviroContainer = [Container]::new();
$enviroContainer.setItems($enviroContent);
$enviroContainer.setSelectAction($action.out());

$columnRight = [Column]::new();
$columnRight.setSeparator($true);
$columnRight.setItems($enviroContainer.out());

$columns = [ColumnSet]::new();
$columns.addColumn($columnLeft.out());
$columns.addColumn($columnRight.out());

$headerText = [TextBlock]::new();
$headerText.setText('DINO AI');
$headerText.setSize('extraLarge');
$headerText.setWeight('bolder');

$content = @($headerText.out(), $columns.out());
#Write-Host $content;

#SET THIS AS THE ADAPTIVE CARD CONTENT
$card = [AdaptiveCard]::new($content);

#WRAP THE ADAPTIVE CARD IN A MESSAGE (.out NOT SUITABLE HERE?)
[Message]$message = [Message]::new($card.object);

#STRINGIFY THE FINAL MESSAGE - THIS *MUST* USE THE out() METHOD
$output = $message.out();

Write-Output $output;

#DEBUGGING
#pause;

#SAVE TO FILE (lastCardOutput.json)
$output | Set-Content -Path "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\lastCardOutput.json" -Encoding 'UTF8';

#SEND TO TEAMS
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""";# > $silent;