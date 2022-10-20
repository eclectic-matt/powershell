#==================
# IMPORTS
#==================

# IMPORT THE MAIN ADAPTIVE CARD
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\AdaptiveCard.ps1

# IMPORT ENUMS
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Enums.ps1

#------------
# CONTAINERS
#------------

# IMPORT COLUMN
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\Containers\Column.ps1

# IMPORT COLUMN SET
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\Containers\ColumnSet.ps1

# IMPORT CONTAINER 
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\Containers\Container.ps1

# IMPORT FACT 
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\Containers\Fact.ps1

# IMPORT FACTSET 
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\Containers\FactSet.ps1

# IMPORT TABLE CELL 
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\Containers\TableCell.ps1

# IMPORT TABLE ROW
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\Containers\TableRow.ps1

# IMPORT TABLE
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\Containers\Table.ps1

#------------
# CARD ELEMENTS
#------------

# IMPORT TEXT BLOCK
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\CardElements\TextBlock.ps1

# IMPORT IMAGE BLOCK
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\CardElements\Image.ps1

# IMPORT ITEM BLOCK
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\Item.ps1

# IMPORT CONTENT BLOCK
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\ContentBlock.ps1

# IMPORT MESSAGE BLOCK
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\Message.ps1

#------------
# ACTIONS
#------------

# IMPORT ACTION OPEN URL
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\Containers\ActionSet.ps1

# IMPORT ACTION OPEN URL
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Functional\Actions\Action.OpenUrl.ps1

function StoreAs-Json{

	param(
		[Parameter(Mandatory=$true)] [System.Object] $object,

		[Parameter(Mandatory=$true)] [String] $path
	)

	$object | ConvertTo-Json -depth 100 | Set-Content -Path $path;
	$object = Get-Content -Path $path | ConvertFrom-Json -Depth 100;
	return $object;
}