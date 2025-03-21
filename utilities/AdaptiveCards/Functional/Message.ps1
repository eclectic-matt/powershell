<# 
	.SYNOPSIS
		Generates a Message container for an AdaptiveCard.
	.DESCRIPTION
		Takes content (mandatory) and wraps this in a message object
		which gets JSON-encoded ready to send via webhook.
	.LINK
		https://adaptivecards.io/explorer/Message.html
#>
function New-Message{

	param(
		# $content is the AdaptiveCard content (required).
		[Parameter(Mandatory=$true)] [PSCustomObject] $content
	)

	#WRAP THE CONTENT IN THE MESSAGE OBJECT
	$message = [PSCustomObject]@{
		type = 'message'
		attachments = @(
			[PSCustomObject]@{
				contentType = 'application/vnd.microsoft.card.adaptive'
				contentUrl = $null
				content = $content
			}
		)
	}

	#FINALLY, JSON ENCODE THIS READY TO SEND
	$message = ConvertTo-Json $message -Depth 100;

	return $message;
}