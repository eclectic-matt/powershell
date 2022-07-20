#WEBHOOK FOR TEAMS

#THE MESSAGE TO SEND
#param ($Message);
$Message = $args[0];

#ESCAPE SPECIAL CHARACTERS
$bSlashChar = '&#92;';
$aposChar = '&#x27;';
$Message = $Message.replace('\',$bSlashChar);
$Message = $Message.replace("'",$aposChar);

#THE URI FOR THE TEAMS WEBHOOK
$teamsUri = "https://YOUR_WEBHOOK_URL_HERE";

#INVOKE A WEB REQUEST TO POST TO THIS WEBHOOK
Invoke-WebRequest -Method 'POST' -ContentType "application/json" -Body "{`"text`" : `"$Message`"}" $teamsUri
Write-Output "Teams Message Sent";
