#INCLUDE CARD GENERATION FUNCTIONS
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\AdaptiveCards.ps1

# IMPORT TABLE CELL 
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Containers\TableCell.ps1

# IMPORT TABLE ROW
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Containers\TableRow.ps1

# IMPORT TABLE
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Containers\Table.ps1


#SOME RANDOM DATA
$time = "20:20:20";
$nextTime = "21:21:21";

#CREATE A NEW ACTION
$actionDes = New-ActionOpenUrl `
    -url "https://www.channel4.com/programmes/dont-hug-me-im-scared" `
    -title "Open 'Something Legit'" `
    -style destructive;

$actionPos = New-ActionOpenUrl `
    -url "https://www.youtube.com/channel/UCZOnoLKzoBItcEk5OsES2TA" `
    -title "Open 'Legit Link'" `
    -style positive;  #NOTE: THE ActionStyle DO NOT WORK ON MS TEAMS


#TEXT BLOCKS

$headerBlock = New-TextBlock `
    -text "Hello I am a stupidly long string which in theory will spread over 1 line but will get cut off by the dots as I've set maxLines to 1 and so this should work I hope - is this long enough?" `
    -color attention `
    -isSubtle $false `
    -horizontalAlignment right `
    -size small `
    -style heading `
    -fontType monospace `
    -weight lighter `
    -wrap $false `
    -maxLines 1;

$text = New-TextBlock -text "Hello" -color warning;

$timeTextBlock = New-TextBlock `
    -text "Interesting Time Alert - $time!" `
    -size "extraLarge" `
    -color accent;

$nextTextBlock = New-TextBlock `
    -text "The next interesting time is at $nextTime" `
    -size large `
    -color attention `
    -fontType monospace `
    -style heading;

$imageBlock = New-Image `
    -url "https://ic.c4assets.com/brands/dont-hug-me-im-scared/0e3d3efa-ed95-482e-9b95-32c2cd32b9bc.jpg" `
    -size large `
    -altText "DHMIS" `
    -height auto `
    -selectAction $actionPos;

#WRAP ANY ACTIONS IN AN ACTIONSET
$actionSet = New-ActionSet -actions @($actionDes, $actionPos);

#TABLES
#$widths = @(1,3,1); #| ForEach-Object -Process ( [PSCustomObject]@{ width = $_ } )
$columns = @(  [PSCustomObject]@{ width = 1}, [PSCustomObject]@{ width = 1}, [PSCustomObject]@{ width = 1} );
<#
$headerCell1 = New-TableCell -items @(New-TextBlock -text "Left Column");
$headerCell2 = New-TableCell -items @(New-TextBlock -text "Middle Column");
$headerCell3 = New-TableCell -items @(New-TextBlock -text "Right Column");
$headerRow = New-TableRow -cells @($headerCell1, $headerCell2, $headerCell3);

$tableCell = New-TableCell -items @(New-TextBlock -text "Top Left Cell") -style accent;
$tableCell2 = New-TableCell -items @(New-TextBlock -text "Top Middle Cell") -style warning;
$tableCell3 = New-TableCell -items @(New-TextBlock -text "Top Right Cell") -style attention;
$tableRow = New-TableRow -cells @($tableCell, $tableCell2, $tableCell3);

$tableCell4 = New-TableCell -items @(New-TextBlock -text "Middle Left Cell") -style good;
$tableCell5 = New-TableCell -items @(New-TextBlock -text "Middle Middle Cell") -style default;
$tableCell6 = New-TableCell -items @(New-TextBlock -text "Middle Right Cell") -style warning;
$tableRow2 = New-TableRow -cells @($tableCell4, $tableCell5, $tableCell6);

$tableCell7 = New-TableCell -items @(New-TextBlock -text "Bottom Left Cell") -style warning;
$tableCell8 = New-TableCell -items @(New-TextBlock -text "Bottom Middle Cell") -style accent;
$tableCell9 = New-TableCell -items @(New-TextBlock -text "Bottom Right Cell") -style good;
$tableRow3 = New-TableRow -cells @($tableCell7, $tableCell8, $tableCell9);
#>

$headerCell1 = New-TableCell -items @(New-TextBlock -text "Lawful Column");
$headerCell2 = New-TableCell -items @(New-TextBlock -text "Neutral Column");
$headerCell3 = New-TableCell -items @(New-TextBlock -text "Chaotic Column");
$headerRow = New-TableRow -cells @($headerCell1, $headerCell2, $headerCell3);

$tableCell1 = New-TableCell -items @(New-TextBlock -text "Lawful Good") -style good;
$tableCell2 = New-TableCell -items @(New-TextBlock -text "Neutral Good") -style accent;
$tableCell3 = New-TableCell -items @(New-TextBlock -text "Chaotic Good") -style warning;
$tableRow1 = New-TableRow -cells @($tableCell1, $tableCell2, $tableCell3);

$tableCell4 = New-TableCell -items @(New-TextBlock -text "Lawful Neutral") -style good;
$tableCell5 = New-TableCell -items @(New-TextBlock -text "True Neutral") -style accent;
$tableCell6 = New-TableCell -items @(New-TextBlock -text "Chaotic Neutral") -style warning;
$tableRow2 = New-TableRow -cells @($tableCell4, $tableCell5, $tableCell6);

$tableCell7 = New-TableCell -items @(New-TextBlock -text "Lawful Evil") -style good;
$tableCell8 = New-TableCell -items @(New-TextBlock -text "Neutral Evil") -style accent;
$tableCell9 = New-TableCell -items @(New-TextBlock -text "Chaotic Evil") -style warning;
$tableRow3 = New-TableRow -cells @($tableCell7, $tableCell8, $tableCell9);

$table = New-Table `
    -columns $columns `
    -rows @($headerRow, $tableRow1, $tableRow2, $tableRow3) `
    -firstRowAsHeader $true `
    -showGridLines $true;

#WRAP IN ARRAY
$items = @($text, $timeTextBlock, $nextTextBlock, $imageBlock, $actionSet, $table);

$containerBlock = New-Container -items $items;
$output = New-Message -content (New-ContentBlock -content $containerBlock);
Write-Host $output;
$output > "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\logs\lastCardOutput.json"
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""" > $silent; 

<#
	#TESTING FACT SET
	$facts = [System.Collections.ArrayList]@();
	$facts.Add( (New-Fact -title "Owner" -value "Matt") );
	$facts.Add( (New-Fact -title "Assigned" -value "Harry") );

	$factSet = New-FactSet -facts $facts;

	$Message = New-Message -content (New-ContentBlock -content $factSet);

	#CONVERT TO JSON TO SEND VIA WEBHOOK 
	#NOTE: DEPTH PARAMETER REQUIRED TO AVOID "body: System.Collections.ArrayList" IN OUTPUT
	$Message = ConvertTo-Json $Message -Depth 100;

	#DEBUG OUTPUT
	Write-Host $Message;

	#SEND VIA TEAMS
	Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$Message` ""true""" > $silent; 

	exit 1;
#>

#Get-Help New-TextBlock -full;
#Get-Help New-Image -full;
#exit 1;

<#
	#GENERATE AN IMAGE BLOCK
	#$imageBlock = Get-Image -url "https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Skeleton_of_Beishanlong_grandis.JPG/1280px-Skeleton_of_Beishanlong_grandis.JPG" -size "ExtraLarge" -altText "Dino Image"
	#$imageBlock = Get-Image -url "https://ic.c4assets.com/brands/dont-hug-me-im-scared/0e3d3efa-ed95-482e-9b95-32c2cd32b9bc.jpg" -size "ExtraLarge" -altText "Dino Image"
	$imageBlock = New-Image `
		-url "https://media.tenor.com/s68izRZawgYAAAAC/clock-time.gif" `
		-horizontalAlignment "center" `
		-size "large" `
		-altText "Clock Image";

	#GENERATE A TEXT BLOCK
	#$textblock = Get-TextBlock -text "Hi Text!"
	$imageContainerBlock = Get-ContainerBlock -items $imageBlock;

	$time = "13:13:13";
	$nextTime = "14:14:14";

	$introTextBlock = New-TextBlock `
		-text "Interesting Time Alert" `
		-weight "lighter" `
		-color "default" `
		-size "default"`
		-fontType "monospace";

	$timeTextBlock = New-TextBlock `
		-text "$time" `
		-weight "bolder" `
		-size "ExtraLarge" `
		-color "attention";

	$nextTextBlock = New-TextBlock `
		-text "The next interesting time is at $nextTime" `
		-weight "default" `
		-size "small" `
		-isSubtle "true" `
		-fontType "monospace";

	$items = @($introTextBlock, $timeTextBlock, $nextTextBlock, $imageContainerBlock);
	#$items = @($introTextBlock, $timeTextBlock, $nextTextBlock);#, $imageContainerBlock);

	#$columnBlock = Get-Column -items $items -actionType "Action.OpenUrl" -actionUrl "https://time.is/" -actionTitle "Time on Google";
	$containerBlock = Get-ContainerBlock -items $items;

	#ONE LINER TO PREPARE MESSAGE OBJECT 
	#(WRAP CONTENT IN CONTENT-BLOCK, THEN WRAP THAT IN A MESSAGE-BLOCK)
	#$Message = Get-Message -content (Get-ContentBlock -content $imageBlock);
	#$Message = Get-Message -content (Get-ContentBlock -content $columnBlock);
	$Message = Get-Message -content (Get-ContentBlock -content $containerBlock);

	#CONVERT TO JSON TO SEND VIA WEBHOOK 
	#NOTE: DEPTH PARAMETER REQUIRED TO AVOID "body: System.Collections.ArrayList" IN OUTPUT
	$Message = ConvertTo-Json $Message -Depth 100;

	#DEBUG OUTPUT
	Write-Host $Message;

	#SEND VIA TEAMS
	Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$Message` ""true""" > $silent; 


	exit 1;
#>

<#
	#==================
	#EXAMPLES
	#==================
	$outPath = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\test\TeamsCards\card.json";

	#GENERATE AN IMAGE
	$image = Get-Image -url "https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Skeleton_of_Beishanlong_grandis.JPG/1280px-Skeleton_of_Beishanlong_grandis.JPG" -size "ExtraLarge" -altText "Dino Image"
	#Write-Host $image;
	#$image | ConvertTo-Json | Set-Content -Path $outPath;
	#$image = Get-Content -Path $outPath | ConvertFrom-Json;

	#GENERATE A TEXT BLOCK
	$textblock = Get-TextBlock -text "Hi Text!"

	#WRAP THIS IN A CONTENT BLOCK
	$contentblock = Get-ContentBlock -content $textblock;
	#$contentblock = StoreAs-Json -object $contentblock -path "C:\Users\matthew.tiernan\Desktop\POWERSHELL\test\TeamsCards\contentCard.json";
	#Write-Host $contentblock;
	#exit 1;

	$Message = Get-Message -content $contentblock;
	$Message = ConvertTo-Json $Message -Depth 100;
	#$Message = StoreAs-Json -object $Message -path "C:\Users\matthew.tiernan\Desktop\POWERSHELL\test\TeamsCards\messageCard.json";
	Write-Host $Message;

	Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$Message` ""true""" > $silent; 

	#$itemsArray = [System.Collections.ArrayList]@()
	#$itemsArray.Add($image) > $silent;
	#$itemsArray.Add($textblock) > $silent;
	#$column = Get-Column -Width "50%" -Items $itemsArray -actionType "Action.OpenUrl" -actionTitle "Open Link" -actionUrl "www.google.com";
#>