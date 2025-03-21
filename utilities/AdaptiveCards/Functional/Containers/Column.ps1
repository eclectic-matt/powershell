<# 
	.SYNOPSIS
		Generates an Column container for an AdaptiveCard.
	.DESCRIPTION
		Takes an array of items and formatting options and
		returns a column container with the required structure
		for an AdaptiveCard.
	.LINK
		https://adaptivecards.io/explorer/Column.html
#>
function New-Column {

	param(
		# [Array] $items are the elements to display within the column (required). 
		# Options: ActionSet,ColumnSet,Container,FactSet,Image,ImageSet,Input.ChoiceSet,Input.Date,Input.Number,Input.Text,Input.Time,Input.Toggle,Media,RichTextBlock,Table,TextBlock.
		[Parameter(Mandatory=$false)] [Array]$items,
		
		# $backgroundImage is the background image to display (default: $null).
		# Options: $null,BackgroundImage,uri.
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
		$backgroundImage=$null,

		# $bleed indicates whether the column should bleed through its parent (default: $false). 
		# Options: true,false.
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$false')]
		$bleed=$false,

		# $fallback describes what to do when an unknown item is encountered (default: $null).
		# Options: Column,"drop".
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
		$fallback=$null,

		# $minHeight specifies the minimum height of the column in pixels (default: $null).
		# Options: $null,"0px".
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
		$minHeight=$null,

		# $rtl indicates if the content should display right-to-left (default: $false).
		# Options: true,false.
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$false')]
		$rtl=$false,
		
		# $separator indicates a separating line should be drawn between this and the previous column (default: false).
		# Options: true,false.
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$false')]
		$separator=$false,
		
		# $spacing indicates the spaing betwen this and the previous column (default: $null).
		# Options: 'default','none','small','medium','large','extraLarge','padding'.
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
		$spacing=$null,

		#==============================
		# $selectAction is a SelectAction passed to handle interactivity (default: $null).
		# Options: Action.Execute,Action.OpenUrl,Action.Submit,Action.ToggleVisibility. 
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
		$selectAction=$null,
		#NOTE: THE 3 PARAMS BELOW SHOULD BE REPLACED WITH THE SELECT ACTION ABOVE

		# $actionType is the selectAction added to this 
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
		$actionType=$null,

		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
		$actionTitle=$null,

		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
		$actionUrl=$null,
		#==============================

		# $style is the container style to apply to this column (default: $null).
		#Options: $null,'default','emphasis','good','attention','warning','accent'.
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
		$style=$null,

		# $verticalContentAlignment is how the content should be aligned vertically (default: auto).
		#Options: 'top','bottom','center'.
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = 'center')]
		$verticalContentAlignment="center",

		# $width is the width of the column within its parent (default: auto).
		#Options: [number],'auto','stretch'.
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = 'auto')]
		$width="auto"
	)

	$itemsArray = [System.Collections.ArrayList]@()
	foreach($item in $items){
		#ADDING INTEGERS?
		if($item -is [Int]){
			#DON'T ADD?
		}else{
			if($null -ne $item){
				$itemsArray.Add($item) > $silent;
			}
		}
	}

	$column = [PSCustomObject]@{
		type = 'Column'
		items = $itemsArray
		backgroundImage = $backgroundImage
		bleed = $bleed
		fallback = $fallback
		minHeight = "$minHeight"
		rtl = $rtl
		separator = $separator
		spacing = "$spacing"
		selectAction = [PSCustomObject]@{}
		style = "$style"
		verticalContentAlignment = "$verticalContentAlignment"
		width = "$width"
	}

	#ADD/REMOVE $null OPTIONAL PROPERTIES
	if($null -ne $actionType){
		$column.selectAction = [PSCustomObject]@{
			type = "$actionType"
			title = "$actionTitle"
			url = "$actionUrl"
		}
	}else{
		$column.PSObject.Properties.Remove('selectAction');
	}

	return $column;
}