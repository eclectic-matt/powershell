Cls;
#GET CONTENT FROM FILE (lastCardOutput.json)
$output = Get-Content -Path "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\lastCardOutput.json" -Encoding 'UTF8';

Write-Output $output;

#SEND TO TEAMS
$reponse = Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""";# > $silent;


if($response.StatusCode -ne 200){
    Write-Host $response.Content;
    Write-Host $response.RawContent;
}
