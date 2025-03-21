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
function New-ActionSet {

    param(
		# [System.Collections.ArrayList] $actions is array of actions to attach (required).
		[Parameter(Mandatory=$true)] [System.Collections.ArrayList] $actions
	)

    $actionSet = [PSCustomObject]@{
		type = 'ActionSet'
		actions = $actions
	}
    
	return $actionSet;
}