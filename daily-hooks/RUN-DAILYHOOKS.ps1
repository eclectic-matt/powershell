<#
	.Synopsis
	Send all daily hooks at once.
	
	.Version
	1.0

	.Description
	Runs all defined Daily Hooks and sends via Teams.
#>

#THIS WORKFLOW ASSUMES YOU HAVE THE FOLLOWING FOLDER STRUCTURE:

# root folder
# |
# ├─── daily-hooks
# |    └─── RUN-DAILYHOOKS.ps1
# |
# ├─── utilities
# |    └─── AdaptiveCards
# |         └─── Classes
# |              └─── Imports.ps1

#CLEAR SCREEN BETWEEN RUNS
Cls;

#REWRITING TO DOT SOURCE ALL THE OTHER SCRIPTS
#GET THE INVOCATION PATH (e.g. C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\RUN-DAILYHOOKS.ps1)
$splitPath = Split-Path $MyInvocation.MyCommand.Path;
#GET THE DIRECTORY FOR THIS FILE (e.g. C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\)
$hooksFolder = Join-Path -Path $splitPath -ChildPath "";
#GET THE ROOT (POWERSHELL) FOLDER (e.g. C:\Users\matthew.tiernan\Desktop\POWERSHELL\)
$rootFolder = Split-Path -Path $splitPath -Parent -Resolve;
#THEN GET THE CHILD utilities DIRECTORY (e.g. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities)
$utilitiesFolder = Join-Path -Path $rootFolder -ChildPath "utilities";
#GET THE API FOLDER IN THE ROOT DIR (e.g. C:\Users\matthew.tiernan\Desktop\POWERSHELL\api)
$apiKeysFolder = Join-Path -Path $rootFolder -ChildPath "api";
#GET THE "MY PICTURES" FOLDER (e.g. C:\Users\matthew.tiernan\Pictures)
$picturesFolder = [Environment]::GetFolderPath("MyPictures");
#IMPORT THE ADAPTIVE CARDS (ONCE FOR ALL SCRIPTS)
. "$utilitiesFolder\AdaptiveCards\Classes\Imports.ps1";



Write-Host "==============================";
Write-Host "SENDING WORD OF THE DAY";
Write-Host "==============================";
#GET WORD OF THE DAY
. "$hooksFolder\Get-WordOfTheDay.ps1";


Write-Host "==============================";
Write-Host "SENDING DINO AI";
Write-Host "==============================";
#NEW DINO WITHIN ENVIRO AI GENERATION
. "$hooksFolder\Get-DinoWithinEnviroAI.ps1";


Write-Host "==============================";
Write-Host "SENDING FAMOUS EVENTS";
Write-Host "==============================";
#GET FAMOUS EVENTS
. "$hooksFolder\Get-FamousEvents.ps1";


Write-Host "==============================";
Write-Host "SENDING GUITAR TAB";
Write-Host "==============================";
#GET DAILY GUITAR TAB (SPECIFIED SEARCH TERMS)
. "$hooksFolder\Get-DecentGuitarTab.ps1";


Write-Host "==============================";
Write-Host "SENDING HACKER NEWS";
Write-Host "==============================";
#GET THE TOP STORIES ON HACKER NEWS
. "$hooksFolder\Get-HackerNews.ps1"


Write-Host "==============================";
Write-Host "SENDING F1 LIVE NEWS FEED / UPCOMING EVENTS";
Write-Host "==============================";
#GET THE LATEST NEWS FROM THE F1 RACEFANS BLOG
. "$hooksFolder\Get-F1NewsAndUpdates.ps1"


Write-Host "==============================";
Write-Host "SENDING DAILY NIGEL AND MARMALADE";
Write-Host "==============================";
#GET A RANDOM NIGEL AND MARMALADE VIDEO
. "$hooksFolder\Get-DailyNigelAndMarmalade.ps1";


Write-Host "==============================";
Write-Host "SENDING RANDOM DnD CHARACTER";
Write-Host "==============================";
#GET A RANDOM D&D CHARACTER AND AN AI IMAGE OF THEM
. "$hooksFolder\Get-RandomDandDCharacter.ps1";


Write-Host "==============================";
Write-Host "SENDING DAILY GNOME";
Write-Host "==============================";
#GET A DAILY GNOME IMAGE
. "$hooksFolder\Get-DailyGnome.ps1";


Write-Host "==============================";
Write-Host "COMPLETED";
Write-Host "==============================";