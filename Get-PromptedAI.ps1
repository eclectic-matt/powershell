# IMPORT ADAPTIVE CARD CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

#SPECIFY THE PROMPT HERE
#$prompt = 'chicken gin, watercolour';
#$prompt = 'two archaeologists fighting each other with bones, neon';
#$prompt = 'a programmer trying to debug a toaster, pop art';
#$prompt = 'an attractive kraken using its tentacles to grab the anatomically accurate groin parts of a sailor';
#$prompt = 'a turtle sitting in an armchair next to the fire who is knitting a woolen scarf, impressionist style';
#$prompt = 'a kitten who is robbing a bank, film noir style';
#$prompt = 'a guinea pig reading a newspaper, in the style of a patchwork quilt';

$prompt = 'a group of Furbys playing poker in an opium den, gritty style';



#GET EDEN AI DATA
$imageData = C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Get-EdenAIImage.ps1 $prompt;

#STORE AS URL AND ENCODED DATA
$imageUrl = $imageData.image_resource_url;
$imageEncode = ("data:image/jpeg;base64," + $imageData.image);

#GENERATE ADAPTIVE CARD
$image = [Image]::new();
$image.setUrl($imageEncode);
$enviroContent = @($image.out());

#GO TO IMAGE LINK
$action = [ActionOpenUrl]::new($imageUrl,"View this image on EdenAI");

#STORE IN A CONTAINER
$enviroContainer = [Container]::new();
$enviroContainer.setItems($enviroContent);
$enviroContainer.setSelectAction($action.out());

$headerText = [TextBlock]::new();
$headerText.setText('GUESS THE PROMPT');
$headerText.setSize('extraLarge');
$headerText.setWeight('bolder');

$content = @($headerText.out(), $enviroContainer.out());
#Write-Host $content;

#SET THIS AS THE ADAPTIVE CARD CONTENT
$card = [AdaptiveCard]::new($content);

#WRAP THE ADAPTIVE CARD IN A MESSAGE (.out NOT SUITABLE HERE?)
[Message]$message = [Message]::new($card.object);

#STRINGIFY THE FINAL MESSAGE - THIS *MUST* USE THE out() METHOD
$output = $message.out();

Write-Output $output;

#DEBUGGING
#pause;

#SAVE TO FILE (lastCardOutput.json)
$output | Set-Content -Path "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\lastCardOutput.json" -Encoding 'UTF8';

#SEND TO TEAMS
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""";# > $silent;