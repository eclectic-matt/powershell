param();
<#
.Description
	Generate a random email message string.
#>

#Clear-Host;

#INIT MESSAGE
$message = @{intro=''; reason=''; outro=''}

#LOAD JSON
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\random\random.json";
$file = Get-Content -Path $fileName -Raw;
$json = ConvertFrom-Json $file;

#GENERATE INTRO
$intros = $json.message.intro;
$introsCount = $intros.length;
$introsIndex = Get-Random -Maximum ($introsCount - 1);
$intro = $intros[$introsIndex];

#GENERATE MAIN BODY
$reasons = $json.message.reason;
$reasonsCount = $reasons.length;
$reasonsIndex = Get-Random -Maximum ($reasonsCount - 1);
$reason = $reasons[$reasonsIndex];

#GENERATE OUTRO
$outros = $json.message.outro;
$outrosCount = $outros.length;
$outrosIndex = Get-Random -Maximum ($outrosCount - 1);
$outro = $outros[$outrosIndex];

#$message = ($intro + "`n" + $reason + "`n" + $outro);
<#
#GET THE RANDOM FOLDER (MAY NOT BE INVOKED FROM HERE)
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
#GET THE Get-RandomName FILE
$randomPath = $dir + "\Get-RandomName.ps1";
#CALL THIS SCRIPT TO GET A RANDOM NAME
$sender = . $randomPath;

#ADD RANDOM NAME TO SIGN OFF
$message = ($message + "`n" + $sender.first);
#>

$message.intro = $intro;
$message.reason = $reason;
$message.outro = $outro;

#Write-Output $name;
return $message;