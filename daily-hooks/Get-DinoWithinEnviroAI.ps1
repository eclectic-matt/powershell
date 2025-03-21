# IMPORT ADAPTIVE CARD CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

#TESTING - CLEAR BETWEEN RUNS
Cls

#THE KEY FILE LOCATIONS
$utilitiesFolder = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\";
$fileArchiveFolder = "C:\Users\matthew.tiernan\Pictures\DinoAI";
#FORCE CLEAR THE IMAGE VAR? EXTRA IMAGES APPEARING WITHIN CONTENT?
$image = $null;

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

	$fact = [Fact]::new();
	$fact.setTitle("From");
	$fact.setValue("$dinoFrom million years ago");
	$factArr = $factArr + $fact.out();

	$fact = [Fact]::new();
	$fact.setTitle("To");
	$fact.setValue("$dinoTo million years ago");
	$factArr = $factArr + $fact.out();

	$fact = [Fact]::new();
	$fact.setTitle("Diet");
	$fact.setValue("$dinoDiet");
	$factArr = $factArr + $fact.out();
	
	$fact = [Fact]::new();
	$fact.setTitle("Length");
	$fact.setValue("$dinoLength");
	$factArr = $factArr + $fact.out();

	$fact = [Fact]::new();
	$fact.setTitle("Location");
	$fact.setValue("$dinoLocation");
	$factArr = $factArr + $fact.out();
	
	$fact = [Fact]::new();
	$fact.setTitle("Type");
	$fact.setValue("$dinoType");
	$factArr = $factArr + $fact.out();
	
	$fact = [Fact]::new();
	$fact.setTitle("Species");
	$fact.setValue("$dinoSpecies");
	$factArr = $factArr + $fact.out();

	$fact = [Fact]::new();
	$fact.setTitle("Namer(s)");
	$fact.setValue("$dinoNamedBy");
	$factArr = $factArr + $fact.out();
	
	$fact = [Fact]::new();
	$fact.setTitle("Named");
	$fact.setValue("$dinoNamedByDate");
	$factArr = $factArr + $fact.out();

	$facts.setFacts($factArr);

	if($null -ne $image){
		$content = @($nameText.out(), $facts.out(), $image.out());
	}else{
		$content = @($nameText.out(), $facts.out());
	}

	#ADD ACTION.OPENURL
	$action = [ActionOpenUrl]::new($dinoLink,"View $dinoName on NHM");

	#STORE IN A CONTAINER
	$dinoContainer = [Container]::new();
	$dinoContainer.setItems($content);
	$dinoContainer.setSelectAction($action.out());

    Write-Host $dinoContainer.out();
	return $dinoContainer;
}


#===================
# DINO
#===================
#LOAD JSON
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\data\dinoList_LIMITED.json";
#LOAD FILE CONTENTS
$file = Get-Content -Path $fileName;
#CONVERT TO JSON
$dinoJSON = ConvertFrom-Json $file; 
#GET THE COUNT OF DINOS
$dinoCount = $dinoJSON.dinoList.length;

#FORCE A PARTICULAR DINOSAUR
#$forceDino = 'diplodocus';

#IF WE ARE NOT FORCING ($null THE VAR ABOVE)
if($null -eq $forceDino){
    #GENERATE A RANDOM DINO IDs
    $dinoOneId = Get-Random -Minimum 3 -Maximum ($dinoCount - 2);
    #GET THE DINO AT THIS INDEX
    $dinoOne = $dinoJSON.dinoList[$dinoOneId];
    #STORE THE DINO NAME
    $dinoName = $dinoOne.name;
    #PASS TO FUNCTION TO GENERATE CONTENT
    $dinoCardOne = New-DinoTopTrump -json $dinoOne;
}else{
    foreach($dino in $dinoJSON.dinoList){
        #Write-Output ("SEARCHING FOR $forceDino AND FOUND " + $dino.name);
        if($dino.name -eq $forceDino){
            $dinoName = $dino.name;
            #PASS TO FUNCTION TO GENERATE CONTENT
            $dinoCardOne = New-DinoTopTrump -json $dino;
            break;
        }
    }
}


#===================
# ENVIRO
#===================
#GET RECENT ENVIROS LIST
$recentName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\data\recentEnviros.json";
$recentFile = Get-Content -Path $recentName -Raw;
$recentJSON = ConvertFrom-Json $recentFile;
$recentArray = $recentJSON.recent;
$recentList = New-Object System.Collections.ArrayList($null)
$recentList.AddRange($recentArray);

$recentCount = $recentJSON.recentCount;

#LOAD JSON TO GET RANDOM ENVIRO
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\data\enviroList.json";
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
    #$enviroName = ('A scientifically-accurate ' + $dinoName + ' ' + $enviroList[$enviroId]);
    #$enviroName = ('The subject of the image is realistic dinosaur of species ' + $dinoName + ' who is standing on the ground. The background of the scene should be ' + $enviroList[$enviroId] + '. ');
    $enviroName = ('Create an image of a realistic species ' + $dinoName + ' dinosaur. The scene takes place in ' + $enviroList[$enviroId] + '. ');
    Write-Output ("Trying " + $enviroName);
}


#======================
# STORE ENVIRO NAME TO
# PREVENT DUPLICATES 
# ON CONSECUTIVE DAYS
#======================

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
$recentHash | ConvertTo-Json -Depth 3 | Out-File $recentName;

#GET URL SUITABLE ENVIRO NAME
$enviro = $enviroName.replace(" ", "\%20");

#GET A RANDOM STYLE (FOR AI GENERATOR)
$styleName = Invoke-Expression -Command ($utilitiesFolder + "Get-RandomStyle.ps1");

#ADD THIS STYLE NAME TO THE PROMPT
#$enviro = ($enviro + ", " + $styleName);
#$enviroName = ($enviroName + ", " + $styleName);
$enviro = ($enviro + 'Create the image in the style of ' + $styleName + '.');
$enviroName = ($enviroName + 'Create the image in the style of ' + $styleName + '.');

#FORCE A DIFFERENT ENVIRONMENT?
$forceEnviro = $null;#"in a Roman baths with cold menly men, ALBUM COVER"
if($null -ne $forceEnviro){
    #FORCE AN ENVIRONMENT (USING $forceDino SET ABOVE)
    $enviroName = ($forceDino + $forceEnviro);
    $enviro = $enviroName.replace(" ", "%20");
}

Write-Output "FULL PROMPT: $enviroName";

#THIS IS THE NEW CHEAP OPTION FROM APRIL 2024
#$provider = "replicate";
#$model = "replicate-classic";
#$resolution = "1024x1024";

#MORE EXPENSIVE BUT WAAAAY MORE ACCURATE OPTION - NOV 2024
$provider = "openai";
$model = "openai/dall-e-3";
$resolution = "1024x1024";

#GET THE IMAGE DATA
$imageData = Invoke-Expression -Command ($utilitiesFolder + "Get-EdenAIImage.ps1 `"" + $enviroName + "`" " + $provider + " " + $model + " " + $resolution);

#CHECK THAT THE IMAGE GENERATION SUCCEEDED!
if($null -eq $imageData.image){
    Write-Host "CANNOT GET IMAGE URL FROM EDEN AI - STOPPING NOW..."
    exit 1;
}else{
    $imageUrl = $imageData.image_resource_url;
    Write-Host ("IMAGE URL: " + $imageUrl);
}

#STORE IMAGE WITH DATA PREFIX
#$imageEncode = ("data&colon;image/jpeg;base64," + $imageData.image);
#data&colon;image/jpeg;base64,/xxxxxxxx

#==============================
# NEW STEP - STORE IMAGE FILE?
#==============================
$archiveImageFileName = $enviroName.replace(" ","_");
$archiveImageFullPath = "$fileArchiveFolder\$archiveImageFileName.jpeg";
Write-Host $archiveImageFullPath;
$imageBytes = [Convert]::FromBase64String($imageData.image);
[IO.File]::WriteAllBytes($archiveImageFullPath, $imageBytes);
Write-Host "Dino Image file backed up!";


#==============================
# GENERATE ADAPTIVE CARD
#==============================
#MAKE THE NAME UPPERCASE
$enviroName = $enviroName.ToUpper();

$image = [Image]::new();
$image.setUrl($imageUrl);
$image.setAltText($enviroName);
$image.setSize('stretch');
$enviroContent = @($image.out());

#GO TO IMAGE LINK
$action = [ActionOpenUrl]::new($imageUrl,"View this image on EdenAI");

#STORE IN A CONTAINER
$enviroContainer = [Container]::new();
$enviroContainer.setItems($enviroContent);
$enviroContainer.setSelectAction($action.out());

#THE MAIN HEADING
$headerText = [TextBlock]::new();
$headerText.setText('DINO AI');
$headerText.setSize('extraLarge');
$headerText.setWeight('bolder');

#SUBHEADING - THE AI PROMPT
$subHeading = [TextBlock]::new();
$subHeading.setText($enviroName);
$subHeading.setSize('large');
$subHeading.setWeight('bolder');

#COMBINE CARD PARTS TO FORM MAIN CARD CONTENT
$content = @($headerText.out(), $subHeading.out(), $enviroContainer.out(), $dinoCardOne.out());

#SET THIS AS THE ADAPTIVE CARD CONTENT
$card = [AdaptiveCard]::new($content);

#WRAP THE ADAPTIVE CARD IN A MESSAGE (.out NOT SUITABLE HERE?)
[Message]$message = [Message]::new($card.object);

#STRINGIFY THE FINAL MESSAGE - THIS *MUST* USE THE out() METHOD
$output = $message.out();
$output = $output.Replace("\u0026", "&");

Write-Output $output;

#DEBUGGING
#pause;
#exit 1;

#SAVE TO FILE (lastCardOutput.json)
$output | Set-Content -Path "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\lastCardOutput.json" -Encoding 'UTF8';

#SEND TO TEAMS
$response = Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""";# > $silent;

Write-Host $response.Content;
Write-Host $response.RawContent;