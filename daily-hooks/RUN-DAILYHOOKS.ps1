<#
	.Synopsis
	Send all daily hooks at once.
	
	.Version
	1.0

	.Description
	Runs all defined Daily Hooks and sends via Teams.
#>

#DEFINE SOURCE FOLDER
$hooksFolder = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\";


Write-Host "==============================";
Write-Host "SENDING WORD OF THE DAY";
Write-Host "==============================";
#GET WORD OF THE DAY
Invoke-Expression -Command ($hooksFolder + "Get-WordOfTheDay.ps1");

<#
#DROPPED IN FAVOUR OF "DINO ENVIRO" 2023-05-10
Write-Host "==============================";
Write-Host "SENDING DINO TOP TRUMPS";
Write-Host "==============================";
#GET DINO OF THE DAY
Invoke-Expression -Command ($hooksFolder + "Get-DinoTopTrumps.ps1");
#>
<#
#DROPPED IN FAVOUR OF "DINO AI" 2023-07-05
Write-Host "==============================";
Write-Host "SENDING DINO ENVIRO";
Write-Host "==============================";
#GET DINO ENVIRO
Invoke-Expression -Command ($hooksFolder + "Get-DinoEnviro.ps1");
#>
Write-Host "==============================";
Write-Host "SENDING DINO AI";
Write-Host "==============================";
#GET DINO AI (OLD TWO-COLUMN LAYOUT)
#Invoke-Expression -Command ($hooksFolder + "Get-DinoAI.ps1");
#NEW DINO WITHIN ENVIRO AI GENERATION
Invoke-Expression -Command ($hooksFolder + "Get-DinoWithinEnviroAI.ps1");

#Write-Host "==============================";
#Write-Host "SENDING DAILY GREEK";
#Write-Host "==============================";
##GET DAILY GREEK
#Invoke-Expression -Command ($hooksFolder + "Get-DailyGreek.ps1");

Write-Host "==============================";
Write-Host "SENDING FAMOUS EVENTS";
Write-Host "==============================";
#GET FAMOUS EVENTS
Invoke-Expression -Command ($hooksFolder + "Get-FamousEvents.ps1");

#Write-Host "==============================";
#Write-Host "SENDING ANIME QUOTE";
#Write-Host "==============================";
##GET ANIME QUOTE
#Invoke-Expression -Command ($hooksFolder + "Get-AnimeQuote.ps1");

Write-Host "==============================";
Write-Host "SENDING GUITAR TAB";
Write-Host "==============================";
#GET DAILY GUITAR TAB (RANDOM)
#Invoke-Expression -Command ($hooksFolder + "Get-RandomGuitarTab.ps1");
#GET DAILY GUITAR TAB (SPECIFIED SEARCH TERMS)
Invoke-Expression -Command ($hooksFolder + "Get-DecentGuitarTab.ps1");

#=====================
## NEW DAILY SCRIPTS
#=====================

Write-Host "==============================";
Write-Host "SENDING HACKER NEWS";
Write-Host "==============================";
Invoke-Expression -Command ($hooksFolder + "Get-HackerNews.ps1");

Write-Host "==============================";
Write-Host "SENDING F1 LIVE NEWS FEED / UPCOMING EVENTS";
Write-Host "==============================";
Invoke-Expression -Command ($hooksFolder + "Get-F1NewsAndUpdates.ps1");

#Write-Host "==============================";
#Write-Host "SENDING DAILY POKEMON";
#Write-Host "==============================";
#I DON'T MUCH LIKE IT - STOPPING FOR NOW...
#Invoke-Expression -Command ($hooksFolder + "Get-DailyPokemon.ps1");

#Write-Host "==============================";
#Write-Host "SENDING EUROS UPCOMING";
#Write-Host "==============================";
#Invoke-Expression -Command ($hooksFolder + "/Football/Get-UpcomingFixtures.ps1");

Write-Host "==============================";
Write-Host "SENDING DAILY NIGEL AND MARMALADE";
Write-Host "==============================";
Invoke-Expression -Command ($hooksFolder + "Get-DailyNigelAndMarmalade.ps1");



Write-Host "==============================";
Write-Host "COMPLETED";
Write-Host "==============================";