param($prompt);
<#
    Get a random environment image from EdenAI.
#>

#CLEAR SCREEN FOR TESTING
#Cls

#EXIT EARLY IF NO PROMPT
if($null -eq $prompt){
    Write-Output "Prompt is required - did you run this file itself?";
    exit 1;
}


#GET API KEY FROM SECRET STORE
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\api\apiKeys.json";
$file = Get-Content -Path $fileName -Raw;
$json = ConvertFrom-Json $file;
$edenAIApiKey = $json.keys.edenai;

#STORE THE BASE URL AND QUERY PATH
$edenAIApiBaseUrl = 'https://api.edenai.run/v2';
$edenAIApiPath = '/image/generation';

#GENERATE THE URL TO SEARCH
$url = ($edenAIApiBaseUrl + $edenAIApiPath);

#ADD API KEY TO HEADERS
$headers = @{
    'Content-Type' = 'application/json'
    method = 'POST'
    url = $url
	Authorization = "Bearer $edenAIApiKey" 
};

#$provider = "openai";
$provider = "stabilityai";

$data = @{
    providers = $provider
    text = $prompt
    resolution = '512x512'
} | ConvertTo-Json;

#CALL THE API TO GET THE JSON
$json = Invoke-WebRequest -Uri $url -Headers $headers  -Method POST -Body $data;

#CONVERT FROM JSON INTO AN OBJECT
$response = ConvertFrom-Json $json.content;# > $silent;

#RETURN THE FIRST ITEM IN THE OBJECT (STORED BY PROVIDER NAME)
return $response.$provider.items[0];
#return {
#    image_resource_url: "https://
#    image: "base64encoded"
#}
