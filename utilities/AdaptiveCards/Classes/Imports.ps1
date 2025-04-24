#===========
# IMPORTS
#===========

# GET THE PATH OF THE CURRENT FOLDER
$importUtilitiesFolder = Split-Path $MyInvocation.MyCommand.Path;
#$rootFolderPath = Split-Path -Path $scriptDir -Parent -Resolve;
# GO ONE LEVEL UP AND FIND THE "utilities" FOLDER
#$utilitiesFolder = Join-Path -Path $scriptDir -ChildPath \AdaptiveCards\Classes
Write-Host ("IMPORT UTILS FOLDER: " + $importUtilitiesFolder);

# MAIN CLASSES
. $importUtilitiesFolder\AdaptiveCard.ps1
. $importUtilitiesFolder\Message.ps1

# ACTION (CLICK ON THE CONTENT TO LOAD A URL)
. $importUtilitiesFolder\Actions\OpenUrl.ps1

# CONTAINERS
. $importUtilitiesFolder\Containers\Container.ps1
. $importUtilitiesFolder\Containers\Table.ps1
. $importUtilitiesFolder\Containers\TableCell.ps1
. $importUtilitiesFolder\Containers\TableRow.ps1
. $importUtilitiesFolder\Containers\FactSet.ps1
. $importUtilitiesFolder\Containers\ImageSet.ps1
. $importUtilitiesFolder\Containers\Fact.ps1
. $importUtilitiesFolder\Containers\Column.ps1
. $importUtilitiesFolder\Containers\ColumnSet.ps1

# BASIC ELEMENTS
. $importUtilitiesFolder\Elements\TextBlock.ps1
. $importUtilitiesFolder\Elements\Image.ps1
