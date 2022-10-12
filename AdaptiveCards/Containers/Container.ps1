function New-Container {

	param(
		[Parameter(Mandatory=$true)] [PSCustomObject] $items,

		[PSDefaultValue(Help = $null)]
		$entities=$null
	)

	$block = [PSCustomObject]@{
		type = 'Container'
		items = [System.Collections.ArrayList]@(
			$items
		)
	}

	return $block;
}