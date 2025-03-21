param($longUrl);
<#
    Get a short URL.
    See: https://is.gd/apishorteningreference.php
#>

#CLEAR SCREEN FOR TESTING
#Cls

#EXIT EARLY IF NO PROMPT
if($null -eq $longUrl){
    Write-Output "Input URL is required - did you run this file itself?";
    exit 1;
}

$shortenerUrlBase = 'https://is.gd/create.php?format=simple&url=';
$shortenerUrl = ($shortenerUrlBase + $longUrl);
$shortUrl = Invoke-WebRequest $shortenerUrl;
return $shortUrl;