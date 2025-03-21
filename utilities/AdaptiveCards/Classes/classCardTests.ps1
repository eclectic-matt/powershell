#IMPORT THE CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

Write-Host "================";
Write-Host "START OUTPUT";
Write-Host "================";

#GENERATE A TEXT BLOCK
$text = [TextBlock]::new();
$text.setText('Left Header');
$text.setColor('accent');
$text.setFontType('default');
$text.setSize('extraLarge');
$text.setHorizontalAlignment('left');
#GENERATE ANOTHER TEXT BLOCK
$secondText = [TextBlock]::new();
$secondText.setText("Left body text");
$secondText.setColor([Colors]::dark);

#GENERATE A TABLE CELL
$leftCell = [TableCell]::new();
#ADD THE CONTENT TO THIS CELL AND FORMATTING
$leftCell.addItem($text.object);
$leftCell.addItem($secondText.object);
$leftCell.setStyle('accent');

#GENERATE A TEXT BLOCK
$text = [TextBlock]::new();
$text.setText('Right Header');
$text.setColor('emphasis');
$text.setFontType('monospace');
$text.setSize('extraLarge');
$text.setHorizontalAlignment('right');
#GENERATE ANOTHER TEXT BLOCK
$secondText = [TextBlock]::new();
$secondText.setText("Right body text");
$secondText.setColor([Colors]::light);

#ADD AN IMAGE
$image = [Image]::new();
$image.setUrl('https://www.nhm.ac.uk/resources/nature-online/life/dinosaurs/dinosaur-directory/images/reconstruction/small/Elaphrosaurus.jpg');

#ADD THIS STUFF INTO A CELL
$rightCell = [TableCell]::new();
$rightCell.addItem($text.object);
$rightCell.addItem($secondText.object);
$rightCell.addItem($image.object);
#SET FORMATTING
$rightCell.setStyle('attention');

#ADD THESE CELLS TO A TABLE ROW
$row = [TableRow]::new();
$row.setCells(@($leftCell.object, $rightCell.object));

#ADD THIS ROW TO THE TABLE
$table = [Table]::new();
$table.addRow($row.object);
#DEFINE THE COLUMNS (ARRAY WITH OBJECTS CONTAINING "width=X")
$columns = @{ width = 1 },@{ width = 2};
#SET THE COLUMNS AND FORMATTING
$table.setColumns($columns);
$table.setShowGridLines($true);

#SET THIS AS THE ADAPTIVE CARD CONTENT
[AdaptiveCard]$card = [AdaptiveCard]::new($table.object);

#WRAP THE ADAPTIVE CARD IN A MESSAGE
[Message]$message = [Message]::new($card.object);
#STRINGIFY THE FINAL MESSAGE - THIS *MUST* USE THE out() METHOD
$output = $message.out();

#SAVE TO FILE (lastCardOutput.json)
$output > "C:\Users\matthew.tiernan\Desktop\POWERSHELL\test\TeamsCards\lastCardOutput.json";

#SEND TO TEAMS
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;