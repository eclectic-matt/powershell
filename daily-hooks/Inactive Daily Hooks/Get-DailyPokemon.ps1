<#
	.Synopsis
	Get a Pokemon of the Day.
	
	.Version
	0.1

	.Description
	Get-DailyPokemon gets a random pokemon for the day.

	.Link
	https://pokeapi.co/api/v2/pokemon/?offset=1&limit=1024
#>

#CLEAR SCREEN FOR TESTING 
Cls;

#ENABLES TITLE CASE ETC
$textInfo = (Get-Culture).TextInfo
#$textInfo.ToTitleCase($json.period_name);

#ONE-TIME INSTALL (HTML PARSING)
#Install-Module -Name PowerHTML

#IMPORT THE CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

#BASE URLS
$allPokemonUrl = "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=1025"; 

#APPEND "$id/" TO THE POKEMON DETAILS URL
$pokemonDetailsUrl = "https://pokeapi.co/api/v2/pokemon/";

#CALL THE API TO GET THE JSON
$json = Invoke-WebRequest $allPokemonUrl;

#CHECK THE JSON RETURN (IN CASE API FAILS)
#Write-Output $json.Content;

#CONVERT THE JSON TO AN OBJECT
$content = ConvertFrom-Json $json.Content;

#GET THE COUNT OF RESULTS 
$resultsCount = $content.results.Count;

#GET A RANDOM RESULT
$resultId = Get-Random -Minimum 0 -Maximum $resultsCount;

Write-Host ("Getting the random ID: " + $resultId);

#GET THE DATA FOR THIS RESULT
$resultData = $content.results[$resultId];

Write-Host ("Name: " + $resultData.name.ToUpper() + " => " + $resultData.url);

# TYPE COLOURS - FOR ADAPTIVE CARDS 
# FULL LIST: https://pokeapi.co/api/v2/type/
# SEE: https://adaptivecards.io/explorer/TextBlock.html
$typeColours = @{
    'normal'='default';
    'fighting'='attention';
    'flying'='accent';
    'poison'='accent';
    'ground'='warning';
    'rock'='warning';
    'bug'='good';
    'ghost'='attention';
    'steel'='default';
    'fire'='attention';
    'water'='accent';
    'grass'='good';
    'electric'='warning';
    'psychic'='accent';
    'ice'='accent';
    'dragon'='accent';
    'dark'='dark';
    'fairy'='attention';
    'unknown'='default';
    'shadow'='dark';
}

#URL
$pokeUrl = $resultData.url;

#FORCE BULBASAUR FOR TESTING
#$pokeUrl = "https://pokeapi.co/api/v2/pokemon/1/";

#GET POKEMON DETAILS
$pokeContentJson = Invoke-WebRequest $pokeUrl;

#GET CONTENT
$pokeContent = ConvertFrom-Json $pokeContentJson.Content;

#Write-Host $pokeContent.types; 

#PREPARE A CONTAINER TO STORE TYPES
#$typesContainer = [Container]::new();
#PREPARE COLUMN SET FOR THESE TYPES
$typesColumn = [ColumnSet]::new();

foreach($type in $pokeContent.types){
    
    Write-Host ("TYPE FOUND: " + $type.type.name + " - " + $typeColours[$type.type.name]);
    
    $typeText = [TextBlock]::new();
    $typeText.setText($type.type.name);
    $typeText.setSize('small');
    $typeText.setColor($textInfo.ToTitleCase($typeColours[$type.type.name]));
    $typeText.setWeight('default');

    #ADD TYPE TEXT TO COLUMN
    $column = [Column]::new();
    $column.addItem($typeText.out()); 

    #ADD COLUMN TO COLUMN SET
    $typesColumn.addColumn($column.out());

    #ADD TO THE TYPES CONTAINER
	#$typesContainer.addItem($typeText.out());
}

#ARRAY TO HOLD MOVES
$movesArr = [System.Collections.ArrayList]@();
#MOVE SET - ALL MOVES
$pokeMoves = [FactSet]::new();

#SET LIMIT ON NUMBER OF MOVES TO OUTPUT
$moveLimit = 5;

foreach($move in $pokeContent.moves[0..($moveLimit - 1)]){

    $moveName = $move.move.name -replace("-", " ");
    Write-Host ("FOUND MOVE: " + $moveName);
    #OUTPUT MOVE
    $fact = [Fact]::new();
    $fact.setTitle("Move");
    $fact.setValue($textInfo.ToTitleCase($moveName));
    #ADD FACT TO FACT ARRAY
    $movesArr = $movesArr + $fact.out();
}

$pokeMoves.setFacts($movesArr);

#ARRAY TO HOLD FACTS
$factArr = [System.Collections.ArrayList]@();
#FACT SET - ALL FACTS
$pokeFacts = [FactSet]::new();

#GET POKE ID
$pokeId = $pokeUrl -replace("https://pokeapi.co/api/v2/pokemon/","");
$pokeId = $pokeId -replace("/", "");
# - ID
$fact = [Fact]::new();
$fact.setTitle("ID");
$fact.setValue($pokeId);
$factArr = $factArr + $fact.out();

#OTHER FACTS TO ADD

# - height
$heightM = $pokeContent.height / 10;
$fact = [Fact]::new();
$fact.setTitle("Height");
$fact.setValue($heightM.ToString() + " m");
$factArr = $factArr + $fact.out();

# - weight
$weightKg = $pokeContent.weight / 10;
$fact = [Fact]::new();
$fact.setTitle("Weight");
$fact.setValue($weightKg.ToString() + " kg");
$factArr = $factArr + $fact.out();

# ALL BASE STATS
foreach($stat in $pokeContent.stats){
    
    $statValue = $stat.base_stat -replace("-", " ");
    $statName = $stat.stat.name;
    #OUTPUT STAT AS A FACT 
    $fact = [Fact]::new();
    $fact.setTitle($textInfo.ToTitleCase($statName));
    $fact.setValue($statValue);
    $factArr = $factArr + $fact.out();
}


#OUTPUT ALL FACTS FOR CHECKING 
foreach($fact in $factArr){
    Write-Host ("FACT: " + $fact);
}

#OUTPUT ALL THE STATS IN THE FACT ARRAY
$pokeFacts.setFacts($factArr);
#Write-Host $moveSet.out();

#GET IMAGE SPRITE 
$defaultImageUrl = $pokeContent.sprites.front_default;

$image = [Image]::new();
$image.setUrl($defaultImageUrl);
$image.setAltText($resultData.name + " default sprite");
$image.setSize('large');


#=================
# START ADAPTIVE 
# CARD OUTPUT
#=================

#HEADING
$pokeName = $pokeContent.name -replace("-", " ");
$headerText = [TextBlock]::new();
$headerText.setText("Daily Pokemon - " + $textInfo.ToTitleCase($pokeName));
$headerText.setSize('extralarge');
$headerText.setWeight('default');

#DATA COLUMNS - TYPES, MOVES, STATS
$dataColumns = [ColumnSet]::new();

# - TYPES
$typesText = [TextBlock]::new();
$typesText.setText("TYPES");
$typesText.setSize('medium');
$typesText.setWeight('default');
#COLUMN OF HEADING AND TYPES COLUMN
$column = [Column]::new();
$column.addItem($typesText.out()); 
$column.addItem($typesColumn.out());
#ADD COLUMN TO COLUMN SET
$dataColumns.addColumn($column.out());

# - MOVES 
$movesText = [TextBlock]::new();
$movesText.setText("MOVES");
$movesText.setSize('medium');
$movesText.setWeight('default');
#COLUMN OF HEADING AND MOVES FACTSET
$column = [Column]::new();
$column.addItem($movesText.out()); 
$column.addItem($pokeMoves.out());
#ADD COLUMN TO COLUMN SET
$dataColumns.addColumn($column.out());

# - STATS
$factsText = [TextBlock]::new();
$factsText.setText("STATS");
$factsText.setSize('medium');
$factsText.setWeight('default');
#COLUMN OF HEADING AND MOVES FACTSET
$column = [Column]::new();
$column.addItem($factsText.out()); 
$column.addItem($pokeFacts.out());
#ADD COLUMN TO COLUMN SET
$dataColumns.addColumn($column.out());

#SOURCE LINK
$sourceText = [TextBlock]::new();
$sourceText.setText("SOURCE: [" + $pokeUrl + "](" + $pokeUrl + ")");
$sourceText.setSize('medium');
$sourceText.setWeight('default');

#THE ENTIRE CONTENT IS ONE COLUMN/CONTAINER
$content = @(
	$headerText.out(),
    $image.out(), 
    $dataColumns.out(),
    #$typesText.out(),
	#$typesContainer.out(),
    #$typesColumn.out(),
    #$movesText.out(),
    #$pokeMoves.out(),
    #$factsText.out(),
    #$pokeFacts.out(),
    $sourceText.out()
);

#PUT THE ARRAY OF CONTENT IN A CONTAINER
$fullContainer = [Container]::new();
$fullContainer.setItems($content);
#Write-Output $fullContainer.out();

#WRAP IN AN ADAPTIVE CARD
[AdaptiveCard]$card = [AdaptiveCard]::new($fullContainer.out());

#WRAP THE ADAPTIVE CARD IN A MESSAGE
[Message]$message = [Message]::new($card.object);
#STRINGIFY THE FINAL MESSAGE - THIS *MUST* USE THE out() METHOD
$output = $message.out();

#SAVE TO FILE (lastCardOutput.json)
$output > "C:\Users\matthew.tiernan\Desktop\POWERSHELL\test\TeamsCards\lastCardOutput.json";

#OUTPUT TO SCREEN FOR CHECKING
Write-Output $output;
#pause;
#exit 1;

#SEND TO TEAMS
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;