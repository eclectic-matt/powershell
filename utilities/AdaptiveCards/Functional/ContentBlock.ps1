function New-ContentBlock{

	param(
		[Parameter(Mandatory=$true)] [PSCustomObject] $content,

		[PSDefaultValue(Help = $null)]
		$entities=$null
	)

	$block = [PSCustomObject]@{
		schema = 'https://adaptivecards.io/schemas/adaptive-card.json'
		type = 'AdaptiveCard'
		version = '1.2'
		msTeams = [PSCustomObject]@{
			width = "full"
		}
		#entities = $entities
		body = [System.Collections.ArrayList]@(
			$content
		)
	}

	return $block;
}
