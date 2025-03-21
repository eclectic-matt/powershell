


#LOAD JSON TO GET RANDOM STYLES
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\data\stylesList.json";
$file = Get-Content -Path $fileName -Raw;
$json = ConvertFrom-Json $file;
$stylesList = $json.stylesList;
$stylesCount = $stylesList.length;

#GET A NEW RANDOM ENVIRO
$styleId = Get-Random -Minimum 0 -Maximum ($stylesCount)
$styleName = $stylesList[$styleId];

#Write-Output "STYLE: " + $styleName;
return $styleName;