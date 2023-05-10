param($enviro);
<#
    Get a random environment image from Pexels.
#>

#CLEAR SCREEN FOR TESTING
#Cls

#GET API KEY FROM SECRET STORE
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\api\apiKeys.json";
$file = Get-Content -Path $fileName -Raw;
$json = ConvertFrom-Json $file;
$pexelsApiKey = $json.keys.pexels;
#Write-Output $pexelsApiKey;
#exit 1;

$pexelsApiBaseUrl = 'https://api.pexels.com/v1/';

#SEARCH FOR AN IMAGE
#@docs https://www.pexels.com/api/documentation/#photos-search
#@example "https://api.pexels.com/v1/search?query=nature&per_page=1"

#WE WANT TO PASS A SEARCH TERM
$pexelsQuerySearch = 'search?query=';

#AND LIMIT IT TO 1 (WE WILL ONLY EVER USE 1, SAVES TIME)
$pexelsQuerySuffix = '&per_page=1';

#===========

<#

#LOAD JSON TO GET RANDOM ENVIRO
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\enviroList.json";
$file = Get-Content -Path $fileName -Raw;
$json = ConvertFrom-Json $file;
$enviroList = $json.enviroList;

#GET A RANDOM ENVIRO
$enviroCount = $enviroList.length;
$enviroId = Get-Random -Minimum 0 -Maximum ($enviroCount)
$enviro = $enviroList[$enviroId];
#>

#Write-Output ("Getting a random photo of a '" + $enviro + "'");

#GENERATE THE URL TO SEARCH
$url = ($pexelsApiBaseUrl + $pexelsQuerySearch + $enviro + $pexelsQuerySuffix);

#Write-Output $url;

#ADD API KEY TO HEADERS
$headers = @{
	'Authorization' = $pexelsApiKey
};


#CALL THE API TO GET THE JSON
$json = Invoke-WebRequest $url -Headers $headers;

#Write-Output $json.content;
#Write-Output "==========";

$data = ConvertFrom-Json $json;

$photoUrl = $data.photos[0].src.landscape;
#$photoUrl = $data.photos[0].src.large2x;

#Write-Output $photoUrl

return $photoUrl;