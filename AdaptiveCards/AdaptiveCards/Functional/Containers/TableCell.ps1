<# 
	.SYNOPSIS
		Generates an TableCell for an AdaptiveCard.
	.DESCRIPTION
		Takes the actions for a card and returns
		an ActionSet object with the required structure
		for an AdaptiveCard.
	.LINK
		https://adaptivecards.io/explorer/SelectAction.html
#>

# IMPORT ENUMS?
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Enums.ps1
#Write-Host ([ContainerStyle]::default)


function New-TableCell {

    param(
		# [System.Collections.ArrayList] $actions is array of actions to attach (required).
		[Parameter(Mandatory=$true)] [System.Collections.ArrayList] $items,

		# [ContainerStyle] $style is style to apply (default: default).
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = 'default')]
		[ValidateNotNullOrEmpty()]
        $style="default"
	)
        #[ContainerStyle]$style=([ContainerStyle]::default).ToString()
        #[ContainerStyle]$style=[ContainerStyle][ContainerStyle]::default

        
    #Write-Host "STYLE: $style";
   # Write-Host "----------------";
    #Write-Host "ContainerStyle: "
   # #Write-Host [ContainerStyle]::(Get-Variable "[ContainerStyle]::$style" -ValueOnly);
    #Write-Host (Get-Variable "[ContainerStyle]::$style" -ValueOnly);
    #Write-Host "----------------";
    #Write-Host "----------------";
    #Write-Host "----------------";

    $tableCell = [PSCustomObject]@{
		type = 'TableCell'
		items = $items
        style = $style
	}
    
	return $tableCell;
}