<#
	.Synopsis
	Get a random D&D Character and send via webhook
	
	.Version
	1.0

	.Description
	Get-RandomDandDCharacter gets a random D&D Character via API and posts to Teams.

	.Link
	https://dndapi.ashleysheridan.co.uk/
#>

# IMPORT ADAPTIVE CARD CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1
# IMPORT THE DnD API CLASS
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\DnD\DnD-API.ps1

#TESTING - CLEAR BETWEEN RUNS
Cls

#THE KEY FILE LOCATIONS
$utilitiesFolder = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\";
$fileArchiveFolder = "C:\Users\matthew.tiernan\Pictures\DnDAI";

#SETUP AUTH FOR THE API
$keyFileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\api\apiKeys.json";
$keyFile = Get-Content -Path $keyFileName -Raw;
$keysJSON = ConvertFrom-Json $keyFile;
$apiEmail = $keysJSON.auth.dndapi.email;
$apiPassword = $keysJSON.auth.dndapi.password;

#SETUP API GATEWAY
$gateway = [DndAPI]::new();

#LOGIN TO API
$loginSuccess = $gateway.login($apiEmail, $apiPassword);
if(!$loginSuccess){
    throw new Exception("Failed to login!");
}

#GENERATE A RANDOM CHARACTER
$rndCharClass = $gateway.getRandomClass();
$rndCharRace = $gateway.getRandomRace();
$rndCharBg = $gateway.getRandomBackground();
$rndCharLang = $gateway.getRandomLanguage();
$rndCharName = $gateway.getRandomName();
#GENERATE THE CHARACTER DESCRIPTION
$rndCharDescription = "A " + $rndCharClass.name + " " + $rndCharRace.name + " called " + $rndCharName + " whose background is " + $rndCharBg.name + " and knows the language " + $rndCharLang.name;

#GET A RANDOM CREATURE
$rndCreatureType = $gateway.getRandomCreatureType();
$rndCreature = $gateway.getRandomCreature($rndCreatureType);
#STORE THE RELEVANT PARTS FROM THE JSON RETURN
$rndCreatureName = $rndCreature.name;
$rndCreatureSize = $rndCreature.size; 
$rndCreatureAlign = $rndCreature.alignment;
#APPEND "FIGHTING A LARGE LAWFUL-EVIL ABOLETH" TO THE CHAR DESCRIPTION
$rndCharDescription = ($rndCharDescription + " and is fighting a " + $rndCreatureSize + "-sized " + $rndCreatureAlign + " " + $rndCreatureName);

#OUTPUT THE FULL PROMPT
Write-Host $rndCharDescription;

#===================
# IMAGE GEN / BACKUP
#===================
#GENERATE AN IMAGE FOR THE CREATED CHARACTER
$imageData = $gateway.generateImage("Generate an image of a Dungeons and Dragons character who is " + $rndCharDescription);

#BACKUP THE IMAGE TO THE DnDAI FOLDER
$archiveImageFileName = $rndCharDescription.replace(" ","_");
$archiveImageFullPath = "$fileArchiveFolder\$archiveImageFileName.jpeg";
$imageBytes = [Convert]::FromBase64String($imageData.image);
[IO.File]::WriteAllBytes($archiveImageFullPath, $imageBytes);

#OUTPUT THE IMAGE URL FOR TESTING
$imageUrl = $imageData.image_resource_url;
Write-Host ("IMAGE URL: " + $imageUrl);

#==============================
# GENERATE ADAPTIVE CARD
#==============================
#MAKE THE NAME UPPERCASE
$descriptionName = $rndCharDescription.ToUpper();

$image = [Image]::new();
$image.setUrl($imageUrl);
$image.setAltText($descriptionName);
$image.setSize('stretch');
$imageContent = @($image.out());

#GO TO IMAGE LINK
$action = [ActionOpenUrl]::new($imageUrl,"View this image on EdenAI");

#STORE IN A CONTAINER
$imageContainer = [Container]::new();
$imageContainer.setItems($imageContent);
$imageContainer.setSelectAction($action.out());

#THE MAIN HEADING
$headerText = [TextBlock]::new();
$headerText.setText('DnD AI');
$headerText.setSize('extraLarge');
$headerText.setWeight('bolder');

#SUBHEADING - THE AI PROMPT
$subHeading = [TextBlock]::new();
$subHeading.setText($rndCharDescription);
$subHeading.setSize('large');
$subHeading.setWeight('bolder');

#COMBINE CARD PARTS TO FORM MAIN CARD CONTENT
$content = @($headerText.out(), $subHeading.out(), $imageContainer.out());

#SET THIS AS THE ADAPTIVE CARD CONTENT
$card = [AdaptiveCard]::new($content);

#WRAP THE ADAPTIVE CARD IN A MESSAGE (.out NOT SUITABLE HERE?)
[Message]$message = [Message]::new($card.object);

#STRINGIFY THE FINAL MESSAGE - THIS *MUST* USE THE out() METHOD
$output = $message.out();
$output = $output.Replace("\u0026", "&");

#SAVE TO FILE (lastCardOutput.json)
$output | Set-Content -Path "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\lastCardOutput.json" -Encoding 'UTF8';

#SEND TO TEAMS
$response = Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""";# > $silent;

<#
#CLASSES
$classesArray = $gateway.getClasses();
#ITERATE CLASSES
for($i = 0; $i -lt $classesArray.Count; $i++){
    Write-Host (" " + $i + " -> " + $classesArray[$i].name);
}
#GET A SINGLE CLASS
$className = "Barbarian";
$singleClass = $gateway.getClassByName($className);
Write-Host $singleClass;

#RACES
$racesArray = $gateway.getRaces();
#ITERATE RACES
for($i = 0; $i -lt $racesArray.Count; $i++){
    Write-Host (" " + $i + " -> " + $racesArray[$i].name);
}
#GET A SINGLE RACE
$raceName = "Elf";
$singleRace = $gateway.getRaceByName($raceName);
Write-Host $singleRace;


#BACKGROUNDS
$bgArray = $gateway.getBackgrounds();
#ITERATE BACKGROUNDS
for($i = 0; $i -lt $bgArray.Count; $i++){
    Write-Host (" " + $i + " -> " + $bgArray[$i].name);
}
#GET A SINGLE BG
$bgName = "Noble";
$singleBg = $gateway.getBackgroundByName($bgName);
Write-Host $singleBg;

#LANGUAGES
$langArray = $gateway.getLanguages();
#ITERATE LANGUAGES
for($i = 0; $i -lt $langArray.Count; $i++){
    Write-Host (" " + $i + " -> " + $langArray[$i].name);
}
#>
