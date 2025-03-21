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

#===========================


#DND API CLASS
class DndAPI 
{
    [String] $token
    [String] $baseUrl
    [System.Object[]] $classes
    [System.Object[]] $races
    [System.Object[]] $backgrounds
    [System.Object[]] $languages

	#DEFAULT DEFINITION (NO INPUT)
	DnDAPI()
    {
		$this.token = $null;
        $this.baseUrl = "https://dndapi.ashleysheridan.co.uk/api/";
        #STORED DATA (REDUCE REQUESTS)
        $this.classes = $null;
        $this.races = $null;
        $this.backgrounds = $null;
        $this.languages = $null;
	}

    #==========
    #SETTERS
    #==========
    # BASE URL
    [void] setBaseUrl([String] $baseUrl)
    {
        $this.baseUrl = $baseUrl;
    }
    # AUTH TOKEN
	[void] setToken([String] $token)
    {
		$this.token = $token;
	}
    # AUTH CREDENTIALS
    [void] setAuth([String] $username, [String] $password)
    {
        $this.login($username, $password);
    }

    #=#=#=#=#=#=#=#=#
    # ACTIONS
    #=#=#=#=#=#=#=#=#

    #=============
    # LOGIN
    #=============
    [boolean] login([String] $username, [String] $password)
    {
        $loginUrl = ($this.baseUrl + "user/login");
        $data = @{
            email = $username
            password = $password
        };
        $json = Invoke-WebRequest -Uri $loginUrl -Method POST -Body $data;
        $response = ConvertFrom-Json $json.Content;
        #HANDLE EMPTY RESPONSE
        if($null -eq $response){
            throw new Exception("Empty Response - Exiting");
        }
        #HANDLE EMPTY RESPONSE TOKEN
        if($null -eq $response.token){
            throw new Exception("Auth Token not found - exiting now!");
        }
        #STORE THE RETURNED TOKEN
        $this.token = $response.token;
        return $true;
    }

    <#=============
    # CHAR CLASSES
     0 -> Barbarian
     1 -> Bard
     2 -> Cleric
     3 -> Druid
     4 -> Fighter
     5 -> Monk
     6 -> Paladin
     7 -> Ranger
     8 -> Rogue
     9 -> Sorcerer
     10 -> Warlock
     11 -> Wizard
    #=============#>
    [System.Object[]] getClasses()
    {
        #CHECK IF WE ALREADY HAVE THIS DATA STORED
        if($null -ne $this.classes){
            return $this.classes;
        }
        #DEFINE THE API URL TO CALL
        $classesUrl = ($this.baseUrl + "characters/classes");
        if($null -eq $this.token){
            throw new Exception("Must login to get token first!");
        }
        $headers = @{
            Authorization=("Bearer " + $this.token)
        };
        #CALL THE URL TO GET DATA
        $json = Invoke-WebRequest -Uri $classesUrl -Method GET -Headers $headers;
        #CONVERT FROM JSON (RETURNED AS AN ARRAY)
        $response = ConvertFrom-Json $json;
        if($response.Count -eq 0){
            throw new Exception("0 CLASSES RETURNED FROM REMOTE CALL");
        }
        #STORE THIS DATA BETWEEN ACTIONS
        $this.classes = $response;
        #RETURN THE CLASSES
        return $response;
    }
    #GET A RANDOM CLASS (DATA OBJECT)
    [System.Object[]] getRandomClass()
    {
        $classesData = $this.getClasses();
        $randClassIndex = Get-Random -Minimum 0 -Maximum $classesData.Count;
        return $classesData[$randClassIndex];
    }
    #GET A CLASS BY NAME (DATA OBJECT)
    [System.Object[]] getClassByName([String] $name)
    {
        $classesData = $this.getClasses();
        $class = $classesData | where { $_.name -eq $name }
        return $class;
    }

    <#=============
    # CHAR RACES
     0 -> Dwarf
     1 -> Elf
     2 -> Halfling
     3 -> Human
     4 -> Dragonborn
     5 -> Gnome
     6 -> Half-Elf
     7 -> Half-Orc
     8 -> Tiefling
    #=============#>
    #GET /api/characters/races
    [System.Object[]] getRaces()
    {
        #CHECK IF WE ALREADY HAVE THIS DATA STORED
        if($null -ne $this.races){
            return $this.races;
        }
        #DEFINE THE API URL TO CALL
        $racesUrl = ($this.baseUrl + "characters/races");
        if($null -eq $this.token){
            throw new Exception("Must login to get token first!");
        }
        $headers = @{
            Authorization=("Bearer " + $this.token)
        };
        #CALL THE URL TO GET DATA
        $json = Invoke-WebRequest -Uri $racesUrl -Method GET -Headers $headers;
        #CONVERT FROM JSON (RETURNED AS AN ARRAY)
        $response = ConvertFrom-Json $json;
        if($response.Count -eq 0){
            throw new Exception("0 RACES RETURNED FROM REMOTE CALL");
        }
        #STORE THIS DATA BETWEEN ACTIONS
        $this.races = $response;
        #RETURN THE NEWLY-OBTAINED DATA
        return $response;
    }
    #GET A RANDOM RACE (DATA OBJECT)
    [System.Object[]] getRandomRace()
    {
        $data = $this.getRaces();
        $randIndex = Get-Random -Minimum 0 -Maximum $data.Count;
        return $data[$randIndex];
    }
    #GET A RACE BY NAME (DATA OBJECT)
    [System.Object[]] getRaceByName([String] $name)
    {
        $data = $this.getRaces();
        $race = $data | where { $_.name -eq $name }
        return $race;
    }
    
    <#=============
    # CHAR BGs
     0 -> Acolyte
     1 -> Charlatan
     2 -> Criminal
     3 -> Entertainer
     4 -> Folk Hero
     5 -> Guild Artisan
     6 -> Hermit
     7 -> Noble
     8 -> Outlander
     9 -> Sage
     10 -> Sailor
     11 -> Soldier
     12 -> Urchin
    #=============#>
    #GET api/characters/backgrounds
    [System.Object[]] getBackgrounds()
    {
        #CHECK IF WE ALREADY HAVE THIS DATA STORED
        if($null -ne $this.backgrounds){
            return $this.backgrounds;
        }
        #DEFINE THE API URL TO CALL
        $bgsUrl = ($this.baseUrl + "characters/backgrounds");
        if($null -eq $this.token){
            throw new Exception("Must login to get token first!");
        }
        $headers = @{
            Authorization=("Bearer " + $this.token)
        };
        #CALL THE URL TO GET DATA
        $json = Invoke-WebRequest -Uri $bgsUrl -Method GET -Headers $headers;
        #CONVERT FROM JSON (RETURNED AS AN ARRAY)
        $response = ConvertFrom-Json $json;
        if($response.Count -eq 0){
            throw new Exception("0 BACKGROUNDS RETURNED FROM REMOTE CALL");
        }
        #STORE THIS DATA BETWEEN ACTIONS
        $this.backgrounds = $response;
        #RETURN THE NEWLY-OBTAINED DATA
        return $response;
    }
    #GET A RANDOM BACKGROUND (DATA OBJECT)
    [System.Object[]] getRandomBackground()
    {
        $data = $this.getBackgrounds();
        $randIndex = Get-Random -Minimum 0 -Maximum $data.Count;
        return $data[$randIndex];
    }
    #GET A BACKGROUND BY NAME (DATA OBJECT)
    [System.Object[]] getBackgroundByName([String] $name)
    {
        $data = $this.getBackgrounds();
        $bg = $data | where { $_.name -eq $name }
        return $bg;
    }

    <#=============
    # LANGUAGES
     0 -> Abyssal
     1 -> Celestial
     2 -> Common
     3 -> Deep Speech
     4 -> Draconic
     5 -> Dwarvish
     6 -> Elvish
     7 -> Giant
     8 -> Gnomish
     9 -> Goblin
     10 -> Halfling
     11 -> Infernal
     12 -> Orcish
     13 -> Primordial
     14 -> Slyvan
     15 -> Undercommon
    #=============#>
    #/api/game/languages
    [System.Object[]] getLanguages()
    {
        #CHECK IF WE ALREADY HAVE THIS DATA STORED
        if($null -ne $this.languages){
            return $this.languages;
        }
        #DEFINE THE API URL TO CALL
        $languagesUrl = ($this.baseUrl + "game/languages");
        if($null -eq $this.token){
            throw new Exception("Must login to get token first!");
        }
        $headers = @{
            Authorization=("Bearer " + $this.token)
        };
        #CALL THE URL TO GET DATA
        $json = Invoke-WebRequest -Uri $languagesUrl -Method GET -Headers $headers;
        #CONVERT FROM JSON (RETURNED AS AN ARRAY)
        $response = ConvertFrom-Json $json;
        if($response.Count -eq 0){
            throw new Exception("0 LANGUAGES RETURNED FROM REMOTE CALL");
        }
        #STORE THIS DATA BETWEEN ACTIONS
        $this.languages = $response;
        #RETURN THE NEWLY-OBTAINED DATA
        return $response;
    }
    #GET A RANDOM LANGUAGE (DATA OBJECT)
    [System.Object[]] getRandomLanguage()
    {
        $data = $this.getLanguages();
        $randIndex = Get-Random -Minimum 0 -Maximum $data.Count;
        return $data[$randIndex];
    }
    #GET A LANGUAGE BY NAME (DATA OBJECT)
    [System.Object[]] getLanguageByName([String] $name)
    {
        $data = $this.getLanguages();
        $lang = $data | where { $_.name -eq $name }
        return $lang;
    }

    <#=============
    # NAMES
    #=============#>
    #GET THE VALID NAME TYPES
    [String[]] getNameTypes()
    {
        #THIS LIST IS AVAILABLE ON THE API HELP PAGE: GET /api/names/{nameType}
        $nameTypes = @("goblin", "orc", "ogre", "dwarf", "halfling", "gnome", "elf", "fey", "demon", "angel", "human", "tiefling");
        return $nameTypes;
    }
    #GET A LIST OF RANDOM NAMES (BY TYPE)
    [System.Object[]] getRandomNames([String] $nameType)
    {
        if($null -eq $this.token){
            throw new Exception("Must login to get token first!");
        }
        $headers = @{
            Authorization=("Bearer " + $this.token)
        };
        #RANDOM NAME OF A CERTAIN TYPE
        $namesUrl = ($this.baseUrl + "names/" + $nameType);
        #CALL THE URL TO GET DATA
        $json = Invoke-WebRequest -Uri $namesUrl -Method GET -Headers $headers;
        #CONVERT FROM JSON (RETURNED AS AN ARRAY)
        $response = ConvertFrom-Json $json;
        if($response.names.Count -eq 0){
            throw new Exception("0 NAMES RETURNED FROM REMOTE CALL");
        }
        #RETURN THE NEWLY-OBTAINED DATA
        return $response;
    }
    #GET A LIST OF RANDOM NAMES
    [System.Object[]] getRandomNames()
    {
        if($null -eq $this.token){
            throw new Exception("Must login to get token first!");
        }
        $headers = @{
            Authorization=("Bearer " + $this.token)
        };
        #GETTING A GENERIC NAME
        $namesUrl = ($this.baseUrl + "names");
        #CALL THE URL TO GET DATA
        $json = Invoke-WebRequest -Uri $namesUrl -Method GET -Headers $headers;
        #CONVERT FROM JSON (RETURNED AS AN ARRAY)
        $response = ConvertFrom-Json $json;
        if($response.names.Count -eq 0){
            throw new Exception("0 NAMES RETURNED FROM REMOTE CALL");
        }
        #RETURN THE NEWLY-OBTAINED DATA
        return $response;
    }
    #GET A RANDOM NAME (GENERIC)
    [String] getRandomName()
    {
        $namesData = $this.getRandomNames();
        $data = $namesData.names;
        $randIndex = Get-Random -Minimum 0 -Maximum $data.Count;
        return $data[$randIndex];
    }

    <#=============
    # CREATURES
    #=============#>
    #GET THE VALID CREATURE TYPES
    [String[]] getCreatureTypes()
    {
        #THIS LIST IS AVAILABLE ON THE API HELP PAGE: GET /api/creatures/{creatureType}
        $creatureTypes = @("aberration", "beast", "celestial", "construct", "demon", "devil", "dragon", "elemental", "fey", "giant", "humanoid", "monstrosity", "ooze", "plant", "undead");
        return $creatureTypes;
    }
    #GET A RANDOM CREATURE TYPE
    [String] getRandomCreatureType()
    {
        $data = $this.getCreatureTypes();
        $randIndex = Get-Random -Minimum 0 -Maximum $data.Count;
        return $data[$randIndex];
    }
    #GET CREATURES OF THE SPECIFIED TYPE (MUST BE A VALID TYPE FROM getCreatureTypes)
    [System.Object[]] getCreatures([String] $creatureType)
    {
        if($null -eq $this.token){
            throw new Exception("Must login to get token first!");
        }
        $headers = @{
            Authorization=("Bearer " + $this.token)
        };
        #GETTING A GENERIC NAME
        $creaturesUrl = ($this.baseUrl + "creatures/" + $creatureType);
        #CALL THE URL TO GET DATA
        $json = Invoke-WebRequest -Uri $creaturesUrl -Method GET -Headers $headers;
        #CONVERT FROM JSON (RETURNED AS AN ARRAY)
        $response = ConvertFrom-Json $json;
        if($response.Count -eq 0){
            throw new Exception("0 CREATURES RETURNED FROM REMOTE CALL");
        }
        #RETURN THE NEWLY-OBTAINED DATA
        return $response;
    }
    #GET A RANDOM CREATURE OF THE SPECIFIED $type
    [System.Object[]] getRandomCreature([String] $creatureType)
    {
        $data = $this.getCreatures($creatureType);
        $randIndex = Get-Random -Minimum 0 -Maximum $data.Count;
        return $data[$randIndex];
    }
    #GET A RANDOM CREATURE (OF A RANDOM TYPE)
    [System.Object[]] getRandomCreature()
    {
        $type = $this.getRandomCreatureType();
        $creature = $this.getRandomCreature($type);
        return $creature;
    }

    <#=============
    # AI IMAGE GEN
    #=============#>
    #GENERATES AN AI IMAGE FOR THE DESCRIPTION PROVIDED
    [System.Object[]] generateImage([String] $description)
    {
        #THE KEY FILE LOCATIONS
        $utilitiesFolder = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\";
        #MORE EXPENSIVE BUT WAAAAY MORE ACCURATE OPTION - NOV 2024
        $provider = "openai";
        $model = "openai/dall-e-3";
        $resolution = "1024x1024";

        #GET THE IMAGE DATA
        $imageData = Invoke-Expression -Command ($utilitiesFolder + "Get-EdenAIImage.ps1 `"" + $description + "`" " + $provider + " " + $model + " " + $resolution);

        #CHECK THAT THE IMAGE GENERATION SUCCEEDED!
        if($null -eq $imageData.image){
            throw new Exception("CANNOT GET IMAGE URL FROM EDEN AI - STOPPING NOW...");
        }
        #RETURN THE FULL JSON OBJECT FOR FURTHER PROCESSING
        return $imageData;
    }
}

# IMPORT ADAPTIVE CARD CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

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