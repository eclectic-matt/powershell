param();
<#
.Description
	Generate a random human name string.
#>

Cls

#INIT NAME ARRAY
$name = @{first=''; last=''; title=''}

#LOAD JSON
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\random\random.json";
$file = Get-Content -Path $fileName -Raw;
$json = ConvertFrom-Json $file;

#GENERATE TITLE
$titles = $json.name.title;
$titleCount = $titles.length;
$titleIndex = Get-Random -Maximum ($titleCount - 1);
#$title = $titles[$titleIndex];
#PREPEND TO NAME
#$name = ($title + " " + $name);
$name.title = $titles[$titleIndex];

#GENERATE FIRST NAME
$firstNames = $json.name.first;
$firstNameCount = $firstNames.length;
$firstNameIndex = Get-Random -Maximum ($firstNameCount - 1);
#$name = $firstNames[$firstNameIndex];
$name.first = $firstNames[$firstNameIndex];

#GENERATE SURNAME
$lastNames = $json.name.last;
$lastNamesCount = $lastNames.length;
$lastNameIndex = Get-Random -Maximum ($lastNamesCount - 1);
#$lastName = $lastNames[$lastNameIndex];
#APPEND TO NAME
#$name = ($name + " " + $lastName);
$name.last = $lastNames[$lastNameIndex];

#Write-Output $name;
return $name;