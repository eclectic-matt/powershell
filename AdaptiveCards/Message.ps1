function New-Message{

	param(
		[Parameter(Mandatory=$true)] [PSCustomObject] $content
	)

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

	return $message;
}