<# 
	.SYNOPSIS
		Generates a AdaptiveCard wrapper.
	.DESCRIPTION
		Takes content (mandatory) and wraps this in an AdaptiveCard
		object which gets JSON-encoded ready to send via webhook.
	.LINK
		https://adaptivecards.io/explorer/AdaptiveCard.html
#>
function New-AdaptiveCard{

	param(
		# $body is the AdaptiveCard body (required).
		[Parameter(Mandatory=$true)] [PSCustomObject] $body,

		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = '1.4')]
		$version='1.4',

		# $speak is the spoken part of this card (default: "")
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = '')]
		$speak=''
	)

	#WRAP THE CONTENT IN THE MESSAGE OBJECT
	$card = [PSCustomObject]@{
		type = 'AdaptiveCard'
		version = $version
		#summary = 'AdaptiveCard'
		msTeams = [PSCustomObject]@{
			width = 'full'
		}
		speak = $speak
		body = @(
			$body
		)
	}

	#FINALLY, JSON ENCODE THIS READY TO SEND
	#$card = ConvertTo-Json $card -Depth 100;

	return $card;
}