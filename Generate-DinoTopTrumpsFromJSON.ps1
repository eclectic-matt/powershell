
#FUNCTION TO GENERATE A DINO "TOP TRUMP" COLUMN IN ADAPTIVE CARD FORMAT
function generateDinoTopTrump{
	param(
		[Parameter(Mandatory=$true)] [System.Object]$json
	)

	#Get culture (quick convert to title case)
	$textInfo = (Get-Culture).TextInfo

	$dinoName = $json.name.ToUpper();
	$dinoPeriod = $textInfo.ToTitleCase($json.period_name);
	$dinoFrom = $json.period_start_mya;
	$dinoTo = $json.period_end_mya;
	$dinoDiet = $textInfo.ToTitleCase($json.diet);
	$dinoLength = $json.length;
	$dinoLocation = $textInfo.ToTitleCase($json.lived_in);
	$dinoType = $textInfo.ToTitleCase($json.type);
	$dinoSpecies = $textInfo.ToTitleCase($json.species);
	$dinoNamedBy = $textInfo.ToTitleCase($json.named_by);
	$dinoLink = $json.link;

	#GET IMAGE FROM NATURAL HISTORY MUSEUM WEBSITE (DINO LINK)
	$content = Invoke-RestMethod $dinoLink;
	#FIND THE FIRST <img>
	$content -match '<img class="dinosaur--image".*src="(?<imgSrc>.*)" ' > $silent;
	#GENERATE A NEW IMAGE TAG
	$img = $Matches.imgSrc;
	
	#GENERATE THE ADAPTIVE CARD FOR THIS DINO
	$adaptiveCard = @"
		{
			"type": "TextBlock",
			"text": "$dinoName",
			"size": "ExtraLarge",
			"horizontalAlignment": "Center",
			"weight": "bolder",
			"wrap": true
		},
		{
			"type": "Container",
			"items": [
				{
					"type": "FactSet",
					"spacing": "padding",
					"facts": [
						{
							"title": "Period",
							"value": "$dinoPeriod"
						},
						{
							"title": "From",
							"value": "$dinoFrom million years ago"
						},
						{
							"title": "To",
							"value": "$dinoTo million years ago"
						},
						{
							"title": "Diet",
							"value": "$dinoDiet"
						},
						{
							"title": "Length",
							"value": "$dinoLength"
						},
						{
							"title": "Location",
							"value": "$dinoLocation"
						},
						{
							"title": "Type",
							"value": "$dinoType"
						},
						{
							"title": "Species",
							"value": "$dinoSpecies"
						},
						{
							"title": "NamedBy",
							"value": "$dinoNamedBy"
						}
					]
				}
			],
			"selectAction": {
				"type": "Action.OpenUrl",
				"title": "View $dinoName on NHM",
				"url": "$dinoLink"
			},
		},
		{
			"type": "Image",
			"url": "$img",
			"size": "ExtraLarge"
		}
"@

    return $adaptiveCard;
}




#LOAD JSON
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\dinoList.json";
$file = Get-Content -Path $fileName;
#4 LINES (2 AT START, 2 AT END) DO NOT CONTAIN DINO INFO
$dinoCount = $file.length - 4;

#GENERATE TWO RANDOM DINO IDs
$dinoOneId = Get-Random -Minimum -2 -Maximum ($dinoCount - 2)
$dinoTwoId = $dinoOneId;
while($dinoTwoId -eq $dinoOneId){
    $dinoTwoId = Get-Random -Minimum -2 -Maximum ($dinoCount - 2)
}

$index = 0;

#ITERATE THROUGH THE FILE CONTENTS
foreach($line in $file){

	#IF WE ARE AT THE FIRST GENERATED LINE INDEX
	if($index -eq $dinoOneId){

	Write-Host "Hit $index - getting Dino 1"

		#GET THE LAST CHARACTER (CHECK FOR ",")
		$lastChar = $line.Substring($line.Length - 1);
		#IF THE LAST CHARACTER IS A COMMA
		if($lastChar -eq ","){
			#UPDATE LINE TO DROP THE TRAILING COMMA
			$line = $line.Substring(0,$line.Length - 1);
		}
		#CONVERT THIS LINE TO JSON
		$json = ConvertFrom-Json $line;
		
		#OUTPUT TO SCREEN
		#Write-Host $json.name;

		#PASS TO FUNCTION TO GENERATE CONTENT
		$dinoCardOne = generateDinoTopTrump -json $json;
	}


	#IF WE ARE AT THE FIRST GENERATED LINE INDEX
	if($index -eq $dinoTwoId){

		Write-Host "Hit $index - getting Dino 2"
		#GET THE LAST CHARACTER (CHECK FOR ",")
		$lastChar = $line.Substring($line.Length - 1);
		#IF THE LAST CHARACTER IS A COMMA
		if($lastChar -eq ","){
			#UPDATE LINE TO DROP THE TRAILING COMMA
			$line = $line.Substring(0,$line.Length - 1);
		}
		#CONVERT THIS LINE TO JSON
		$json = ConvertFrom-Json $line;
		
		#OUTPUT TO SCREEN
		#Write-Host $json.name;
		
		#PASS TO FUNCTION TO GENERATE CONTENT
		$dinoCardTwo = generateDinoTopTrump -json $json;
	}

	#INCREMENT LINE INDEX
	$index += 1;
}

#NOW GENERATE "WRAPPER" ADAPTIVE CARD
$adaptiveCard = @"
"$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
"type": "AdaptiveCard",
"version": "1.2",
"msTeams": { "width": "full" },
"speak": "Welcome to today's Dino Top Trumps!",
"body": [
	{
		"type": "Container",
		"items": [
			{
				"type": "TextBlock",
				"text": "DINO TOP TRUMPS",
				"size": "ExtraLarge",
				"horizontalAlignment": "Center",
				"weight": "bolder",
				"wrap": true
			},
			{ 
				"type": "ColumnSet",
				"columns": [
					{
						"type": "Column",
						"width": "50%",
						"items": [
							$dinoCardOne
						]
					},
					{
						"type": "Column",
						"width": "50%",
						"items": [
							$dinoCardTwo
						]
					}
				]
			}
		]
	}
]
"@

#AND FINALLY, WRAP IN THE JSON WRAPPER TO POST
$Message = @"
{
	"type":"message",
	"attachments":[
		{
			"contentType":"application/vnd.microsoft.card.adaptive",
			"contentUrl":null,
			"content": {
				$adaptiveCard
			}
		}
	]
}
"@

#DEBUG OUTPUT
#Write-Host $Message;

Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$Message` ""true""" > $silent; 
