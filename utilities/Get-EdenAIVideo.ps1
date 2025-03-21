param($prompt, $provider, $model, $resolution);
<#
    Get a generated video from EdenAI.
    @See: https://app.edenai.run/bricks/video/generation
#>

#CLEAR SCREEN FOR TESTING
#Cls

<#
    STEP ONE 
    PREPARE THE INITIAL API CALL
#>

#EXIT EARLY IF NO PROMPT
if($null -eq $prompt){
    #Write-Output "Prompt is required - did you run this file itself?";
    #exit 1;
    #HARD-CODING THE PROMPT FOR TESTING
    $prompt = "Generate a video of a variety of scientifically-accurate dinosaur species roaming through modern environments, such as a shopping center, a McDonalds restaurant car park, a pub bathroom, a school classroom, a bike shed, and a Cathedral during Sunday Mass. The video should be in the style of a nature documentary, which explains how the dinosaurs live in these environments and how they have adapted to the landscape.";
}

#DEFAULT PROVIDER?
if($null -eq $provider){
    #ONLY AVAILABLE OPTIONS ON LAUNCH (14-01-2025)
    #$provider = 'amazon/amazon.nova-reel-v1:0';
    $provider = 'amazon';
}


#GET API KEY FROM SECRET STORE
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\api\apiKeys.json";
$file = Get-Content -Path $fileName -Raw;
$json = ConvertFrom-Json $file;
$edenAIApiKey = $json.keys.edenai;

#STORE THE BASE URL AND QUERY PATH
$edenAIApiBaseUrl = 'https://api.edenai.run/v2';
$edenAIApiPath = '/video/generation_async';

#GENERATE THE URL TO SEARCH
$url = ($edenAIApiBaseUrl + $edenAIApiPath);

#ADD API KEY TO HEADERS
$headers = @{
    'Content-Type' = 'application/json'
    method = 'POST'
    url = $url
	Authorization = "Bearer $edenAIApiKey" 
};

$data = @{
    providers = $provider
    text = $prompt
} | ConvertTo-Json;

Write-Host $data;

<#
    STEP TWO 
    CALL THE API WITH THE PROMPT AND WAIT FOR VIDEO GENERATION TO COMPLETE
#> 

#CALL THE API TO GET THE JSON
$json = Invoke-WebRequest -Uri $url -Headers $headers  -Method POST -Body $data;

#CONVERT FROM JSON INTO AN OBJECT
$response = ConvertFrom-Json $json.content;# > $silent;

<# EXAMPLE RESPONSE - WE NEED $response.public_id;
{"public_id":"a9cf6508-91d6-4298-b97e-ef4d9e28595f","status":"processing","error":null,"results":{"amazon/amazon.nova
-reel-v1:0":{"error":null,"id":"2452b113-0ed5-49d7-aab7-5cf58754cbc1","final_status":"processing","cost":0.5}}}
#>

#WAIT FOR GENERATION TO COMPLETE
$pauseSeconds = 30;
pause $pauseSeconds;

#$videoId = $response.results.'amazon/amazon.nova-reel-v1:0'.id;
$videoId = $response.public_id;


<#
    STEP THREE
    CALL THE API AGAIN WITH THE JOB ID TO GET THE VIDEO
#> 
#https://api.edenai.run/v2/video/generation_async/{job_id}

#GENERATE THE NEW URL
$url = ("https://api.edenai.run/v2/video/generation_async/" + $videoId);

#CALL THE API TO GET THE JSON
$json = Invoke-WebRequest -Uri $url -Headers $headers  -Method GET;

#CONVERT FROM JSON INTO AN OBJECT
$response = ConvertFrom-Json $json.content;# > $silent;

Write-Host $response.results;
exit; 


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