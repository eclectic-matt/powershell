<#
    THIS SCRIPT MUST BE RUN AS ADMIN (ENABLING CHANGES TO THE ProgramFiles\ FOLDER)
    THIS IS DANGEROUS - REMOVES ALL FILES FROM THE FOLDER AND EXTRACTING A ZIP FOLDER
    USE THIS WITH CAUTION IF MAKING CHANGES!
#>

#DEFINE WHERE THE UPDATE ZIP FILE IS STORED
$updateZipLocation = "C:\Users\matthew.tiernan\Downloads";

#GET LATEST VS CODE ZIP FILE NAME
$vscodeUpdateZipFileName = (Get-ChildItem $updateZipLocation | Where Name -like "VSCode-win32-x64-*.zip" | Sort-Object -Property Name -Descending | Select-Object -First 1).FullName;

#WAS NO ZIP FILE FOUND?
if($null -eq $vscodeUpdateZipFileName){
    Write-Host "ERROR GETTING UPDATE ZIP FILE - EXITING NOW!";
    exit 1;
}

Write-Host ("UPDATING VS CODE PORTABLE FROM " + $vscodeUpdateZipFileName);

#DEFINE THE INSTALL FOLDER
$installFolder = "C:\Program Files\Microsoft VS Code (Portable)";

#Remove-Item -Path $installFolder -Exclude *data\*
Get-ChildItem $installFolder -Exclude data | Get-ChildItem -Recurse | Remove-Item -Force -Recurse -Confirm:$false;

#EXTRACT THE ZIP FILES INTO THE CURRENT FOLDER
Expand-Archive -Path $vscodeUpdateZipFileName -DestinationPath $installFolder;

#FINALLY, DELETE THE ORIGINAL ZIP FILE
Remove-Item $vscodeUpdateZipFileName;