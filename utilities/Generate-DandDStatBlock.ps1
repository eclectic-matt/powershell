param($data);
# IMPORT ADAPTIVE CARD CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

#Cls;

#STORE BASE URL
$baseUrl = 'https://www.dnd5eapi.co';

Write-Host "DATA RECEIVED:";
#Write-Host $data.length;
#$json = new-object psobject -Property $data;
$json = $data;# | ConvertFrom-Json;

#EXTRACT DATA
$name = $json.name;
$hitDie = $json.hit_die;
$subclasses = $json.subclasses;
$proficiencies = $json.proficiencies;

#OUTPUT DATA
Write-Host ("json.name: " + $name);

#GENERATE THE CARD USING FUNCTIONS 
$subclassHeadingText = [TextBlock]::new();
$subclassHeadingText.setText("SUBCLASSES");
$subclassHeadingText.setSize('medium');
$subclassHeadingText.setFontType('monospace');
$subclassHeadingText.setWeight('bolder');

# - subclasses
#PREPARE SUBCLASS FACTS ARRAY
$subclassFacts = [FactSet]::new();
$subclassFactArr = @();
Foreach($subclass in $subclasses){
    $subclassLink = ("[" + $subclass.name + "](" + "https://www.dnd5eapi.co" + $subclass.url + ")");
    #Write-Host ("NEW SUBCLASS: " + $subclass.name);
    Write-Host ("NEW SUBCLASS: " + $subclassLink);
    #ADD FACT
	$fact = [Fact]::new();
	$fact.setTitle($subclassLink);
	$fact.setValue($subclass.name);
	$subclassFactArr = $subclassFactArr + $fact.out();
}
#INSERT SUBCLASS FACTS ARRAY INTO SUBCLASS FACTS OBJECT
$subclassFacts.setFacts($subclassFactArr);


#GENERATE THE CARD USING FUNCTIONS 
$proficiencyHeadingText = [TextBlock]::new();
$proficiencyHeadingText.setText("PROFICIENCIES");
$proficiencyHeadingText.setSize('medium');
$proficiencyHeadingText.setFontType('monospace');
$proficiencyHeadingText.setWeight('bolder');

# - proficiencies
Foreach($proficiency in $proficiencies){
    Write-Host ("NEW PROFICIENCY: " + $proficiency.name);
}

#LIMIT LEVEL OF RETURNED SPELLS
$maxSpellLevel = 5;
#GENERATE THE CARD USING FUNCTIONS 
$spellsHeadingText = [TextBlock]::new();
$spellsHeadingText.setText("SPELLS (Levels 0-" + $maxSpellLevel + ")");
$spellsHeadingText.setSize('medium');
$spellsHeadingText.setFontType('monospace');
$spellsHeadingText.setWeight('bolder');

# GET SUBSEQUENT DATA
$spellsUrl = ($baseUrl + ($json.spells));
Write-Host ("CALLING: " + $spellsUrl);
$response = Invoke-WebRequest -Uri $spellsUrl;
#CONVERT FROM JSON INTO AN OBJECT
$spells = (ConvertFrom-Json $response.content).results;
Write-Host ("ALL SPELLS: " + $spells);
# - spells

#PREPARE SPELL FACTS ARRAY
$spellFacts = [FactSet]::new();
$spellsFactArr = @();
#ITERATE THROUGH SPELLS
Foreach($spell in $spells){
    if($spell.level -le $maxSpellLevel){
        $spellLink = ("[" + $spell.name + "](" + "https://www.dnd5eapi.co" + $spell.url + ")");
        #ADD FACT
	    $fact = [Fact]::new();
	    $fact.setTitle($spellLink);
	    $fact.setValue("LEVEL " + $spell.level);
	    $spellsFactArr = $spellsFactArr + $fact.out();
    }
}
#INSERT SPELL FACTS ARRAY INTO SPELL FACTS OBJECT
$spellFacts.setFacts($spellsFactArr);
#Write-Host $spellFacts;

$content = @(
    $subclassHeadingText.out(), 
    $subclassFacts.out(), 
    $spellsHeadingText.out(), 
    $spellFacts.out()
);

#ADD ACTION.OPENURL
$action = [ActionOpenUrl]::new($json.url,"View $name on 5e API");

#STORE IN A CONTAINER
$mainContainer = [Container]::new();
$mainContainer.setItems($content);
$mainContainer.setSelectAction($action.out());

#Write-Host $mainContainer.out();

#MAKE MAIN HEADING
$headerText = [TextBlock]::new();
$headerText.setText('D&D 5e - ' + $name);
$headerText.setSize('extraLarge');
$headerText.setWeight('bolder');

$content = @($headerText.out(), $mainContainer.out());

#SET THIS AS THE ADAPTIVE CARD CONTENT
$card = [AdaptiveCard]::new($content);

#WRAP THE ADAPTIVE CARD IN A MESSAGE (.out NOT SUITABLE HERE?)
[Message]$message = [Message]::new($card.object);

#STRINGIFY THE FINAL MESSAGE - THIS *MUST* USE THE out() METHOD
$output = $message.out();
$output = $output.Replace("\u0026", "&");

#SAVE TO FILE (lastCardOutput.json)
$output | Set-Content -Path "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\lastCardOutput.json" -Encoding 'UTF8';

#SEND TO TEAMS
$response = Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true"" ""Drinks Orders""";# > $silent;

Write-Host $response.Content;
Write-Host $response.RawContent;

exit 1;

#Write-Host ("NAME IS : " + $data.psobject.properties.name[0]);

#$name = $data.psobject.properties.name[0];
#$name = $data._name;
#$name = $data.objects.name;
#$name = $data.name;
#$name = $data["name"];
#$name = $data | where { $_.Name -eq "name" };
#$name = $data.psobject.properties | Where-Object({$_ -eq 'name'});
#$name = $data.psobject.properties.Where({$_.name -eq 'name'}).value
#Write-Host "NAME: $name";

if($null -eq $name){
    Write-Host "No name found in data - check again!";
    exit 1;
}

<#
    Generate a D&D stat block with Adaptive Cards
    @params:
        name
        size
        type
        subtype (optional)
        alignment
        armourClass
        hitPoints
        hitDice
        speed:
            walk
            swim
            fly
        stats:
            strength
            dexterity
            constitution
            intelligence
            wisdom
            charisma
        senses
        languages
        challenge:
            rating
            xp
        features
        actions
#>



<#
#EXAMPLE HERE
$name = 'Bulette';
$size = 'Large';
$type = 'Monstrosity';
$subtype = $null;
$alignment = 'unaligned';
$armour = @{
    class = 17;
    type = 'natural';
}
$health = @{
    points = 94;
    dice = '9d10';
    roll = '9d10+45';
}
$speed = @{
    walk = '40 ft.';
    burrow = '40 ft.';
    fly = $null;
    swim = $null;
}
$abilities = @{
    strength = 19;
    dexterity = 11;
    constitution = 21;
    intelligence = 2;
    wisdom = 10;
    charisma = 5;
}
#>

#NAME - TITLE/HEAD
$nameHead = [TextBlock]::new();
$nameHead.setText($data.psobject.properties.name);
$nameHead.setSize('large');
$nameHead.setFontType('serif');
$nameHead.setWeight('bolder');
$nameHead.setHorizontalAlignment('left');

#DESCRIPTION
$description = ($data.psobject.properties.size + ' ' + $data.psobject.properties.type);
if($null -ne $data.psobject.properties.subtype){
    $description = ($description + ' (' + $data.psobject.properties.subtype + ')');
}
$description = ($description + ', ' + $data.psobject.properties.alignment);
$descText = [TextBlock]::new();
$descText.setText($description);
$descText.setSize('small');
$descText.setFontType('sans serif');
$descText.setWeight('italic');
$descText.setHorizontalAlignment('left');

#PREPARE FACTS ARRAY
$facts = [FactSet]::new();
$factArr = @();

#ARMOUR
$fact = [Fact]::new();
$fact.setTitle("Armour Class:");
$fact.setValue($data.psobject.properties.armor_class.value);
$factArr = $factArr + $fact.out();

#HEALTH
$fact = [Fact]::new();
$fact.setTitle("Hit Points:");
$healthString = $data.psobject.properties.hit_points;
$healthString = -join($healthString, ' (');
$healthString = -join($healthString,$data.psobject.properties.hit_dice);
$healthString = -join($healthString, ')');
Write-Host $healthString;

$fact.setValue($healthString);
$factArr = $factArr + $fact.out();
#SPEED
$fact = [Fact]::new();
$fact.setTitle("Speed");
$fact.setValue($data.psobject.properties.speed.walk);
$factArr = $factArr + $fact.out();

#SET FACTS ARRAY
$facts.setFacts($factArr);

#===

<#
#TABLE FOR ABILITY SCORES
$table = [Table]::new();
$strHead = [TextBlock]::new();
$strHead.setText('STR');
$dexHead = [TextBlock]::new();
$dexHead.setText('DEX');
$conHead = [TextBlock]::new();
$conHead.setText('CON');
$intHead = [TextBlock]::new();
$intHead.setText('INT');
$wisHead = [TextBlock]::new();
$wisHead.setText('WIS');
$chaHead = [TextBlock]::new();
$chaHead.setText('CHA');
$headerRow = @($strHead, $dexHead, $conHead, $intHead, $wisHead, $chaHead);
$tableRow = [TableRow]::new();
$tableRow.setCells($headerRow);
$table.setRows($tableRow);

$columns = [
        {
          "width": 1
        },
        {
          "width": 1
        },
        {
          "width": 1
        },
        {
          "width": 1
        },
        {
          "width": 1
        },
        {
          "width": 1
        }
      ];
Write-Output $table.out();

exit 1;
#>

$content = @($nameHead.out(), $descText.out(), $facts.out());

#SET THIS AS THE ADAPTIVE CARD CONTENT
$card = [AdaptiveCard]::new($content);

#WRAP THE ADAPTIVE CARD IN A MESSAGE (.out NOT SUITABLE HERE?)
[Message]$message = [Message]::new($card.object);

#STRINGIFY THE FINAL MESSAGE - THIS *MUST* USE THE out() METHOD
$output = $message.out();

#Write-Host $output;

return $output;
exit 1;


#DEBUGGING
#pause;

#SAVE TO FILE (lastCardOutput.json)
$output | Set-Content -Path "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\lastCardOutput.json" -Encoding 'UTF8';

#SEND TO TEAMS
Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""";# > $silent;