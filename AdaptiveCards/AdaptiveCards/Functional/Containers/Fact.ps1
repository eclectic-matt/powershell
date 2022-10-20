<# 
	.SYNOPSIS
		Generates a Fact element for an AdaptiveCard.
	.DESCRIPTION
		Takes a key/value pair and returns an object 
		with the required structure for an AdaptiveCard.
	.LINK
		https://adaptivecards.io/explorer/Fact.html
#>
function New-Fact{

	param(
		# [String] $title is the title (key) of the Fact (required).
		[Parameter(Mandatory=$true)] [String]$title,

		# [String] $value is the value (value) of the Fact (required).
		[Parameter(Mandatory=$true)] [String]$value
	)

	$fact = [PSCustomObject]@{
		type = 'Fact'
		title = "$title"
		value = "$value"
	}

	return $fact;
}