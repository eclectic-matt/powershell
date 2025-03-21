<# 
	.SYNOPSIS
		Generates a TextBlock element for an AdaptiveCard.
	.DESCRIPTION
		Takes text (mandatory) and formatting options and
		returns an object with the required structure
		for an AdaptiveCard. 
	.LINK
		https://adaptivecards.io/explorer/TextBlock.html
#>


# IMPORT THE ENUMS
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Enums.ps1

function New-TextBlock{


	param(

		# $text is the text to output (required).
		[Parameter(Mandatory=$true)] [String]$text,
		
		# $color is the font colour (default: default).
		# Options: default,dark,light,accent,good,warning,attention.
		[Parameter(Mandatory=$false)]
        [PSDefaultValue(Help = 'default')]
        [ValidateNotNullOrEmpty()]
		[Colors]$color=[colors]::default,

		# $fontType is the type of font (default: default).
		# Options: default,monospace.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = 'default')]
		[ValidateNotNullOrEmpty()]
		[FontType]$fontType=[FontType]::default,

		# $horizontalAlignment is the horizontal alignment (default: center).
		# Options: left,center,right.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = 'center')]
        [ValidateNotNullOrEmpty()]
		[HorizontalAlignment]$horizontalAlignment=[HorizontalAlignment]::center,

		# $isSubtle is whether this text should be subtle/faint (default: false).
		# Options: true,false.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = '$false')]
        [ValidateNotNullOrEmpty()]
		[ValidateSet($false,$true)]
		$isSubtle=$false,

		# $maxLines is the maximum number of lines to display (default: "").
		# Options: number,$null.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = '$null')]
        #[ValidateNotNullOrEmpty()]
		#[ValidateSet([Int],$null)]
		$maxLines=$null,

		# $size is the size of the text (default: extraLarge).
		# Options: default,small,medium,large,extraLarge.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = 'extraLarge')]
		[ValidateNotNullOrEmpty()]
		[FontSize]$size=[FontSize]::default,

		# $weight is the font weight (default: bolder).
		# Options: default,lighter,bolder.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = 'bolder')]
        [ValidateNotNullOrEmpty()]
		[FontWeight]$weight=[FontWeight]::default,

		# $wrap is whether to wrap text over lines, otherwise clipped (default: true).
		# Options: true,false.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = '$true')]
		$wrap=$true,

		# $style is the block style to apply (default: default).
		# Options: default,heading.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = 'default')]
        [ValidateNotNullOrEmpty()]
		[TextBlockStyle]$style=[TextBlockStyle]::default
	)

	$textblock = [PSCustomObject]@{
		type = 'TextBlock'
		text = "$text"
		color = "$color"
		fontType = "$fontType"
		horizontalAlignment = "$horizontalAlignment"
		isSubtle = $isSubtle
		maxLines = ""
		size = "$size"
		weight = "$weight"
		wrap = $wrap
		style = "$style"	#Not supported in Teams 1.4?
	}

    #ADD/REMOVE $null OPTIONAL PROPERTIES
	if($null -ne $maxLines){
		$textblock.maxLines = $maxLines
	}else{
		$textblock.PSObject.Properties.Remove('maxLines');
	}

	return $textblock;
}