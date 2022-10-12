function New-Column {

	param(
		[Parameter(Mandatory=$false)] [Array]$items,
		
		[Parameter(Mandatory=$false)] [String]$actionType,
		
		[Parameter(Mandatory=$false)] [String]$actionTitle,
		
		[Parameter(Mandatory=$false)] [String]$actionUrl,
		
		[PSDefaultValue(Help = '100%')]
		$width="100%"
	)

	$itemsArray = [System.Collections.ArrayList]@()
	foreach($item in $items){
		$itemsArray.Add($item) > $silent;
	}

	$column = [PSCustomObject]@{
		type = 'Column'
		width = "$width"
		items = $itemsArray
		selectAction = [PSCustomObject]@{
			type = "$actionType"
			title = "$actionTitle"
			url = "$actionUrl"
		}
	}

	return $column;
}