#==================
# IMPORTS
#==================

#------------
# CONTAINERS
#------------

# IMPORT COLUMN BLOCK
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Containers\Column.ps1

# IMPORT CONTAINER BLOCK
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Containers\Container.ps1

# IMPORT FACT BLOCK
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Containers\Fact.ps1

# IMPORT FACTSET BLOCK
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Containers\FactSet.ps1

#------------
# CARD ELEMENTS
#------------

# IMPORT TEXT BLOCK
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\CardElements\TextBlock.ps1

# IMPORT IMAGE BLOCK
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\CardElements\Image.ps1

# IMPORT ITEM BLOCK
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Item.ps1

# IMPORT CONTENT BLOCK
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Content.ps1

# IMPORT MESSAGE BLOCK
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Message.ps1


function StoreAs-Json{

	param(
		[Parameter(Mandatory=$true)] [System.Object] $object,

		[Parameter(Mandatory=$true)] [String] $path
	)

	$object | ConvertTo-Json -depth 100 | Set-Content -Path $path;
	$object = Get-Content -Path $path | ConvertFrom-Json -Depth 100;
	return $object;
}