param($prompt, $provider, $model, $resolution);
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

#DEFAULT PROVIDER?
if($null -eq $provider){
    #DEFAULT TO stabilityai
    #$provider = 'stabilityai';

    #CHANGED 2024-11-25
    $provider = 'openai'
}

if($null -eq $model){
    #DEFAULT TO '' (OPTIONAL PARAM)
    #$model = '';

    #DEFAULT TO OPEN AI MODEL 
    $model = 'openai/dall-e-3';
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


#NOTE: 2023-12-18 error being returned, change to OpenAi in the meantime
#NOTE: 2024-01-22 nonsensical error ($31.00 in credit) returned by stabilityai, changed back to openai - "message": "Stabilityai has returned an error: Your organization does not have enough balance to request this action (need $0.0021285714285905538, have $0.00196122 in active grants, $0.00035359 in balance)."
#NOTE: 2024-04-09 "open ai 512x512" is now returning "The size is not supported by this model"

#SET PROVIDER AND SIZE HERE FOR TESTING - ERRORS DUE TO CHANGES IN AVAILABLE FORMATS
#$provider = "stabilityai";
#$model = "stable-diffusion-xl-1024-v1-0";
#$resolution = "1024x1024";

#DEFINE THE MODEL AS WELL, AS "stabilityai" BY DEFAULT IS RETURNING:
#{ 
#  "message": "Stabilityai has returned an error: 
#    for stable-diffusion-xl-1024-v0-9 and stable-diffusion-xl-1024-v1-0 
#    the allowed dimensions are 
#      1024x1024, 1152x896, 1216x832, 1344x768, 1536x640, 
#      640x1536, 768x1344, 832x1216, 896x1152, 
#    but we received 512x512", "type": "ProviderException" }


#$provider = "replicate";
#$model = "replicate-classic";
#$resolution = "1024x1024";
$data = @{
    providers = $provider
    $provider = $model
    text = $prompt
    resolution = $resolution
} | ConvertTo-Json;

Write-Host $data;

#$provider = "openai";
#$provider = "stabilityai";
<#
$data = @{
    providers = $provider
    text = $prompt
    resolution = '512x512'
} | ConvertTo-Json;
#>

#CALL THE API TO GET THE JSON
$json = Invoke-WebRequest -Uri $url -Headers $headers  -Method POST -Body $data;

#Write-Host $json; 

#CONVERT FROM JSON INTO AN OBJECT
$response = ConvertFrom-Json $json.content;# > $silent;

if($null -ne $response){
    if($null -ne $response.$provider){
        if($null -ne $response.$provider.items){
            return $response.$provider.items[0];
        }
    }
}

if($null -ne $response.$provider.$items[0]){
    #Write-Host $response.$provider.$items[0];
    #RETURN THE FIRST ITEM IN THE OBJECT (STORED BY PROVIDER NAME)
    return $response.$provider.items[0];
}else{
    #TRY RUNNING AGAIN
    Invoke-Expression -Command ("C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Get-EdenAIImage.ps1 `"" + $prompt + "`" " + $provider);
    #Invoke-Expression -Command $PSCommandPath
    #return 1;
}

#return {
#    image_resource_url: "https://
#    image: "base64encoded"
#}