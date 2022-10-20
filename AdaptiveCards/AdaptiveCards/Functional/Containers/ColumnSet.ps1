function New-ColumnSet {

	param(
		[Parameter(Mandatory=$false)] [Array]$columns
	)

	$columnSet = [PSCustomObject]@{
		type = 'ColumnSet'
		columns = @(
			$columns
		)
	}

	return $columnSet;
}