<# 
	.SYNOPSIS
		Generates a FactSet element for an AdaptiveCard.
	.DESCRIPTION
		Takes a series of key/value pairs (facts) and 
		returns an object listing all the child Facts 
		with the required structure for an AdaptiveCard.
	.LINK
		https://adaptivecards.io/explorer/Fact.html
#>
function New-FactSet{

	param(
		# [System.Collections.ArrayList] $facts is the array of Facts (required).
		[Parameter(Mandatory=$true)] [System.Collections.ArrayList]$facts
	)

	$factSet = [PSCustomObject]@{
		type = 'FactSet'
		facts = @(
			$facts
		)
	}

	return $factSet;
}