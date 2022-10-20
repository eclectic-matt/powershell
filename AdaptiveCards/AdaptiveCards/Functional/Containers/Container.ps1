function New-Container {

	param(
		[Parameter(Mandatory=$true)] [PSCustomObject] $items,

		[PSDefaultValue(Help = $null)]
		$entities=$null,

		[PSDefaultValue(Help = $null)]
		$actionType=$null,

		[PSDefaultValue(Help = $null)]
		$actionTitle=$null,

		[PSDefaultValue(Help = $null)]
		$actionUrl=$null
	)

	$block = [PSCustomObject]@{
		type = 'Container'
		items = [System.Collections.ArrayList]@(
			$items
		)
		selectAction = [PSCustomObject]@{}
	}

	if($null -ne $actionType){
		$block.selectAction = [PSCustomObject]@{
			type = $actionType
			title = $actionTitle
			url = $actionUrl
		}
	}else{
		$block.PSObject.Properties.Remove('selectAction');
	}

	return $block;
}