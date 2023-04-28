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

Write-Host "==============================";
Write-Host "SENDING DINO TOP TRUMPS";
Write-Host "==============================";
#GET DINO OF THE DAY
Invoke-Expression -Command ($hooksFolder + "Get-DinoTopTrumps.ps1");

Write-Host "==============================";
Write-Host "SENDING DAILY GREEK";
Write-Host "==============================";
#GET DAILY GREEK
Invoke-Expression -Command ($hooksFolder + "Get-DailyGreek.ps1");

Write-Host "==============================";
Write-Host "SENDING FAMOUS EVENTS";
Write-Host "==============================";
#GET FAMOUS EVENTS
Invoke-Expression -Command ($hooksFolder + "Get-FamousEvents.ps1");

Write-Host "==============================";
Write-Host "SENDING ANIME QUOTE";
Write-Host "==============================";
#GET ANIME QUOTE
Invoke-Expression -Command ($hooksFolder + "Get-AnimeQuote.ps1");

Write-Host "==============================";
Write-Host "SENDING GUITAR TAB";
Write-Host "==============================";
#GET DAILY GUITAR TAB
Invoke-Expression -Command ($hooksFolder + "Get-RandomGuitarTab.ps1");



Write-Host "==============================";
Write-Host "COMPLETED";
Write-Host "==============================";