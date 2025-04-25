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
    #CONDUCTS A LOGIN USING THE PRESET AUTH CREDENTIALS
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
            throw "Empty Response - Exiting";
        }
        #HANDLE EMPTY RESPONSE TOKEN
        if($null -eq $response.token){
            throw "Auth Token not found - exiting now!";
        }
        #STORE THE RETURNED TOKEN
        $this.token = $response.token;
        return $true;
    }
    #CHECK LOGGED IN
    [boolean] isLoggedIn()
    {
        if($null -ne $this.token){
            return $true;
        }else{
            return $false;
        }
    }
    #GET HEADER (AUTH: BEARER $token)
    [System.Collections.Hashtable] getHeaders()
    {
        if($this.isLoggedIn() -eq $false){
            throw "Must login first to get auth token!";
        }
        $headers = @{
            Authorization=("Bearer " + $this.token)
        };
        return $headers;
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
        #CHECK LOGGED IN
        if($this.isLoggedIn() -eq $false){
            throw "Must login to get token first!";
        }
        #GET HEADER
        $headers = $this.getHeaders();
        #CALL THE URL TO GET DATA
        $json = Invoke-WebRequest -Uri $classesUrl -Method GET -Headers $headers;
        #CONVERT FROM JSON (RETURNED AS AN ARRAY)
        $response = ConvertFrom-Json $json;
        if($response.Count -eq 0){
            #throw "0 CLASSES RETURNED FROM REMOTE CALL";
            #THIS IS CONSTANTLY FAILING - HARD-CODING THESE NOW
            return @( "Bard", "Cleric", "Druid", "Fighter", "Monk", "Paladin", "Ranger", "Rogue", "Sorcerer", "Warlock", "Wizard" );
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
        #CHECK LOGGED IN
        if($this.isLoggedIn() -eq $false){
            throw "Must login to get token first!";
        }
        #GET HEADER
        $headers = $this.getHeaders();
        #CALL THE URL TO GET DATA
        $json = Invoke-WebRequest -Uri $racesUrl -Method GET -Headers $headers;
        #CONVERT FROM JSON (RETURNED AS AN ARRAY)
        $response = ConvertFrom-Json $json;
        if($response.Count -eq 0){
            throw "0 RACES RETURNED FROM REMOTE CALL";
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
        #CHECK LOGGED IN
        if($this.isLoggedIn() -eq $false){
            throw "Must login to get token first!";
        }
        #GET HEADER
        $headers = $this.getHeaders();
        #CALL THE URL TO GET DATA
        $json = Invoke-WebRequest -Uri $bgsUrl -Method GET -Headers $headers;
        #CONVERT FROM JSON (RETURNED AS AN ARRAY)
        $response = ConvertFrom-Json $json;
        if($response.Count -eq 0){
            throw "0 BACKGROUNDS RETURNED FROM REMOTE CALL";
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
        #CHECK LOGGED IN
        if($this.isLoggedIn() -eq $false){
            throw "Must login to get token first!";
        }
        #GET HEADER
        $headers = $this.getHeaders();
        #CALL THE URL TO GET DATA
        $json = Invoke-WebRequest -Uri $languagesUrl -Method GET -Headers $headers;
        #CONVERT FROM JSON (RETURNED AS AN ARRAY)
        $response = ConvertFrom-Json $json;
        if($response.Count -eq 0){
            throw "0 LANGUAGES RETURNED FROM REMOTE CALL";
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
        #CHECK LOGGED IN
        if($this.isLoggedIn() -eq $false){
            throw "Must login to get token first!";
        }
        #GET HEADER
        $headers = $this.getHeaders();
        #RANDOM NAME OF A CERTAIN TYPE
        $namesUrl = ($this.baseUrl + "names/" + $nameType);
        #CALL THE URL TO GET DATA
        $json = Invoke-WebRequest -Uri $namesUrl -Method GET -Headers $headers;
        #CONVERT FROM JSON (RETURNED AS AN ARRAY)
        $response = ConvertFrom-Json $json;
        if($response.names.Count -eq 0){
            throw "0 NAMES RETURNED FROM REMOTE CALL";
        }
        #RETURN THE NEWLY-OBTAINED DATA
        return $response;
    }
    #GET A LIST OF RANDOM NAMES
    [System.Object[]] getRandomNames()
    {
        #CHECK LOGGED IN
        if($this.isLoggedIn() -eq $false){
            throw "Must login to get token first!";
        }
        #GET HEADER
        $headers = $this.getHeaders();
        #GETTING A GENERIC NAME
        $namesUrl = ($this.baseUrl + "names");
        #CALL THE URL TO GET DATA
        $json = Invoke-WebRequest -Uri $namesUrl -Method GET -Headers $headers;
        #CONVERT FROM JSON (RETURNED AS AN ARRAY)
        $response = ConvertFrom-Json $json;
        if($response.names.Count -eq 0){
            throw "0 NAMES RETURNED FROM REMOTE CALL";
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
        #$creatureTypes = @("aberration", "beast", "celestial", "construct", "demon", "devil", "dragon", "elemental", "fey", "giant", "humanoid", "monstrosity", "ooze", "plant", "undead");
        #RESTRICTED LIST (SOME ARE RETURNING EMPTY ARRAYS AT PRESENT)
        $creatureTypes = @("aberration", "beast", "celestial", "construct", "dragon", "elemental", "fey", "giant", "humanoid", "monstrosity", "ooze", "plant", "undead");
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
        #CHECK LOGGED IN
        if($this.isLoggedIn() -eq $false){
            throw "Must login to get token first!";
        }
        #GET HEADER
        $headers = $this.getHeaders();
        #GETTING A GENERIC NAME
        $creaturesUrl = ($this.baseUrl + "creatures/" + $creatureType);
        #CALL THE URL TO GET DATA
        $json = Invoke-WebRequest -Uri $creaturesUrl -Method GET -Headers $headers;
        #CONVERT FROM JSON (RETURNED AS AN ARRAY)
        $response = ConvertFrom-Json $json;
        if($response.Count -eq 0){
            throw "0 CREATURES RETURNED FROM REMOTE CALL";
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
    # CHARACTERS
    #=============#>
    #CREATES A NEW CHARACTER, PASSING NAME AND URL
    [String] createNewCharacter([String] $name, [int] $level)
    {
        #CHECK LOGGED IN
        if($this.isLoggedIn() -eq $false){
            throw "Must login to get token first!";
        }
        #GET HEADER
        $headers = $this.getHeaders();
        #DEFINE DATA TO POST
        $data = @{
            Name=$name 
            Level=$level 
        } | ConvertTo-SecureString -AsPlainText $true;
        #GETTING A GENERIC NAME
        $charsUrl = ($this.baseUrl + "characters/");
        #CALL THE URL TO GET DATA
        $newGuid = Invoke-WebRequest -Uri $charsUrl -Method POST -Headers $headers -Body $data -ContentType "text/json";
        #CHECK RETURNED
        if($null -eq $newGuid){
            throw "NO NEW GUID RETURNED FROM REMOTE CALL";
        }
        #RETURN THE NEWLY-OBTAINED DATA
        return $newGuid;
    }


    <#=============
    # AI IMAGE GEN
    #=============#>
    #GENERATES AN AI IMAGE FOR THE DESCRIPTION PROVIDED
    [System.Object[]] generateImage([String] $description, [string] $utilitiesFolder)
    {
        #MORE EXPENSIVE BUT WAAAAY MORE ACCURATE OPTION - NOV 2024
        $provider = "openai";
        $model = "openai/dall-e-3";
        $resolution = "1024x1024";

        #GET THE IMAGE DATA
        $imageData = Invoke-Expression -Command ($utilitiesFolder + "\Get-EdenAIImage.ps1 `"" + $description + "`" " + $provider + " " + $model + " " + $resolution);

        #CHECK THAT THE IMAGE GENERATION SUCCEEDED!
        if($null -eq $imageData.image){
            throw "CANNOT GET IMAGE URL FROM EDEN AI - STOPPING NOW...";
        }
        #RETURN THE FULL JSON OBJECT FOR FURTHER PROCESSING
        return $imageData;
    }
}
