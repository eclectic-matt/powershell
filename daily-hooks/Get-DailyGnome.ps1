<#
	.Synopsis
	Get a random AI Gnome and send via webhook
	
	.Version
	1.0

	.Description
	Get-DailyGnome generates an AI image of a gnome via API and posts to Teams.
#>

#THE KEY FILE LOCATIONS
$fileArchiveFolder = "$picturesFolder\DailyGnome";

#GENERATE THE GNOME DESCRIPTION
#$prompt = "Make me an image of a happy, dummy thicc gnome from behind wearing a pointy red hat. the image is from behind but he is smiling at the camera. his trousers have fallen down. the gnome is covered from head to toe in water and flour. create in animated ghibli style";
$prompt = "Make me an image of a happy, dummy thicc gnome from behind wearing a pointy red hat. the image is from behind but he is smiling at the camera. the gnome is covered from head to toe in water and flour. create in animated ghibli style";

#DEFINE THE AI MODEL
#$aiModelType = "leonardo";
#$aiModelType = "openai";
#$aiModelType = "replicate";
$aiModelType = "openai";

#GET THE SETTINGS TO USE FOR THE SELECTED MODEL
switch($aiModelType){
    "openai" {
        $provider = "openai";
        $model = "openai/dall-e-3";
        $resolution = "1024x1024";
    }
    "leonardo" {
        $provider = "leonardo";
        $model = "leonardo";
        $resolution = "1024x1024";
    }
    "replicate" {
        $provider = "replicate";
        $model = "replicate/anime-style";
        $resolution = "512x512";
    }
    "amazon" {
        $provider = "amazon";
        $model = "amazon/titan-image-generator-v1_standard";
        $resolution = "1024x1024";
    }
}



#GET THE IMAGE DATA
$imageData = Invoke-Expression -Command ($utilitiesFolder + "\Get-EdenAIImage.ps1 `"" + $prompt + "`" " + $provider + " " + $model + " " + $resolution);
#$imageData = Invoke-Expression -Command ($utilsDir + "\Get-EdenAIImage.ps1 `"" + $prompt + "`" " + $provider + " " + $model + " " + $resolution);


#CHECK THAT THE IMAGE GENERATION SUCCEEDED!
if($null -eq $imageData.image){
    Write-Host "CANNOT GET IMAGE URL FROM EDEN AI - STOPPING NOW...";
    Write-Host $imageData;
    exit 1;
}else{
    $imageUrl = $imageData.image_resource_url;
    Write-Host ("IMAGE URL: " + $imageUrl);
}

#BACKUP THE IMAGE TO THE DailyGnome FOLDER
if($prompt.Length -gt 250){
    #MAKE TIMESTAMPED FILE NAME IF PROMPT TOO LONG
    $archiveImageFileName = ('gnome_image_' + (Get-Date -Format "yyyy-MM-dd HH_mm_ss"));
}else{
    $archiveImageFileName = $prompt.replace(" ","_");
}
$archiveImageFullPath = "$fileArchiveFolder\$archiveImageFileName.jpeg";
$imageBytes = [Convert]::FromBase64String($imageData.image);
[IO.File]::WriteAllBytes($archiveImageFullPath, $imageBytes);

#OUTPUT THE IMAGE URL FOR TESTING
$imageUrl = $imageData.image_resource_url;
Write-Host ("IMAGE URL: " + $imageUrl);

#==============================
# GENERATE ADAPTIVE CARD
#==============================
#MAKE THE NAME UPPERCASE
$descriptionName = $prompt.ToUpper();

$image = [Image]::new();
$image.setUrl($imageUrl);
$image.setAltText($descriptionName);
$image.setSize('stretch');
$imageContent = @($image.out());

#GO TO IMAGE LINK
$action = [ActionOpenUrl]::new($imageUrl,"View this image on EdenAI");

#STORE IN A CONTAINER
$imageContainer = [Container]::new();
$imageContainer.setItems($imageContent);
$imageContainer.setSelectAction($action.out());

#THE MAIN HEADING
$headerText = [TextBlock]::new();
$headerText.setText('Daily Gnome');
$headerText.setSize('extraLarge');
$headerText.setWeight('bolder');

#SUBHEADING - THE AI PROMPT
$subHeading = [TextBlock]::new();
$subHeading.setText($prompt + " [by " + $model + "]");
$subHeading.setSize('large');
$subHeading.setWeight('bolder');

#COMBINE CARD PARTS TO FORM MAIN CARD CONTENT
$content = @($headerText.out(), $subHeading.out(), $imageContainer.out());

#SET THIS AS THE ADAPTIVE CARD CONTENT
$card = [AdaptiveCard]::new($content);

#WRAP THE ADAPTIVE CARD IN A MESSAGE (.out NOT SUITABLE HERE?)
[Message]$message = [Message]::new($card.object);

#STRINGIFY THE FINAL MESSAGE - THIS *MUST* USE THE out() METHOD
$output = $message.out();
$output = $output.Replace("\u0026", "&");

#SAVE TO FILE (lastCardOutput.json)
$output | Set-Content -Path "$hooksFolder\lastCardOutput.json" -Encoding 'UTF8';

#SEND TO TEAMS (General)
Invoke-Expression -Command "$utilitiesFolder\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;