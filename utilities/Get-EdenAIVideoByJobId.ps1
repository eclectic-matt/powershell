param($jobId);
<#
    Get a previously-generated video using its job ID from EdenAI.
    @See: https://app.edenai.run/bricks/video/generation
#>

#CLEAR SCREEN FOR TESTING
#Cls

<#
    STEP ONE 
    PREPARE THE API CALL
#>

if($null -eq $jobId){
    #USE MY FIRST REQUEST
    $jobId = "a9cf6508-91d6-4298-b97e-ef4d9e28595f";
}

#GET API KEY FROM SECRET STORE
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\api\apiKeys.json";
$file = Get-Content -Path $fileName -Raw;
$json = ConvertFrom-Json $file;
$edenAIApiKey = $json.keys.edenai;

#STORE THE BASE URL AND QUERY PATH
$edenAIApiBaseUrl = 'https://api.edenai.run/v2';
$edenAIApiPath = ('/video/generation_async/' + $jobId);
#https://api.edenai.run/v2/video/generation_async/{job_id}

#GENERATE THE URL TO SEARCH
$url = ($edenAIApiBaseUrl + $edenAIApiPath);

Write-Host ("CALLING: " + $url);

#ADD API KEY TO HEADERS
$headers = @{
    'Content-Type' = 'application/json'
    method = 'GET'
    url = $url
	Authorization = "Bearer $edenAIApiKey" 
};

<#
    STEP TWO 
    CALL THE API WITH THE JOB ID TO GET THE GENERATED VIDEO 
#> 

#CALL THE API TO GET THE JSON
$json = Invoke-WebRequest -Uri $url -Headers $headers  -Method GET;

#CONVERT FROM JSON INTO AN OBJECT
$response = ConvertFrom-Json $json.content;# > $silent;

Write-Host $response.results.'amazon/amazon.nova-reel-v1:0'.video_resource_url;
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