<# 
	.SYNOPSIS
		Generates an ActionSet for an AdaptiveCard.
	.DESCRIPTION
		Takes the actions for a card and returns
		an ActionSet object with the required structure
		for an AdaptiveCard.
	.LINK
		https://adaptivecards.io/explorer/SelectAction.html
#>
function New-Table {

    param(

        [Parameter(Mandatory=$true)] [System.Collections.ArrayList] $columns,

		# [System.Collections.ArrayList] $actions is array of actions to attach (required).
		[Parameter(Mandatory=$true)] [System.Collections.ArrayList] $rows,

        # [Boolean] $firstRowAsHeader specifies if the first row should be a header row (default: $true).
        [Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$true')]
        [ValidateNotNullOrEmpty()]
		[Boolean]$firstRowAsHeader=$true,

        # [Boolean] $showGridLines specifies if grid lines should be displayed (default: $true).
        [Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$true')]
        [ValidateNotNullOrEmpty()]
		[Boolean]$showGridLines=$true
        
        #TO DO

        #gridStyle

        #horizontalCellContentAlignment

        #verticalCellContentAlignment
	)

    $table = [PSCustomObject]@{
		type = 'Table'
		columns = $columns
        rows = $rows
        firstRowAsHeader = $firstRowAsHeader
        #showGridLines = $showGridLines
	}
    
	return $table;
}