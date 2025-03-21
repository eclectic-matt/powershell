param($type, $item);
<#
    Get D&D stats for a 
#>

#VALID RESOURCE TYPES
enum ResourceTypes {
    classes = 1
    features = 2
    monsters = 3
    spells = 4
}

#CLEAR SCREEN FOR TESTING
#Cls

#EXIT EARLY IF NO TYPE
if($null -eq $type){
    Write-Host "Type is required - did you run this file itself?";
    #exit 1;
    #PROVIDE SOME DEFAULT VALUES
    $type = 'classes';
    $item = 'barbarian';#DOESN'T WORK - NO SPELLS?
    $item = 'warlock';
}


#CHECK VALID RESOURCE TYPE
if(![ResourceTypes].GetEnumNames().Contains([string]$type)){
   Write-Host "Type (" + $type + ") is not a valid resource type from the list:";
   foreach($validType in [ResourceTypes].GetEnumNames()){
    Write-Host $validType;
   }
   exit 1;
}


#DEFAULT ITEM
if($null -eq $item){
    #DEFAULT TO empty string
    $item = '';
}

#STORE THE BASE URL AND QUERY PATH
$baseUrl = 'https://www.dnd5eapi.co/api/';
$url = ($baseUrl + $type + "/" + $item);
Write-Host ("CALLING: " + $url);

$response = Invoke-WebRequest -Uri $url;

#CONVERT FROM JSON INTO AN OBJECT
$json = ConvertFrom-Json $response.content;# -AsHashtable; #-Depth 200;# -AsHashtable;
Write-Host $json;

#Write-Host .\Generate-DandDStatBlock.ps1 $json;

$utilFolder = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\";
#Invoke-Expression -Command ($utilFolder + "Generate-DandDStatBlock.ps1 -data " + $json);
& ($utilFolder + "Generate-DandDStatBlock.ps1")  -data $json;

#return ("The $item class uses the hit die D" + $json.hit_die);

#exit 0;