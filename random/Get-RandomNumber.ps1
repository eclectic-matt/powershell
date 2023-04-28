﻿param($intro, $length);
<#
.Description
	Generate a random human name string.
.Parameter $intro
    Any intro numbers (e.g. area code) to use.
.Parameter $length
    The resulting length of the number.
#>

#LOAD JSON
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\random\random.json";
$file = Get-Content -Path $fileName -Raw;
$json = ConvertFrom-Json $file;

$randomNumber = $intro;
$startLength = $randomNumber.length;

for($i = $startLength; $i -lt $length; $i++){
    $randomNumber = ($randomNumber + (Get-Random -Maximum 10));
}

return $randomNumber;