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
function New-TextBlock{

	param(

		# $text is the text to output (required).
		[Parameter(Mandatory=$true)] [String]$text,
		
		# $color is the font colour (default: default).
		# Options: default,dark,light,accent,good,warning,attention.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = 'default')]
		$color="default",

		# $fontType is the type of font (default: default).
		# Options: default,monospace.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = 'default')]
		$fontType="default",

		# $horizontalAlignment is the horizontal alignment (default: center).
		# Options: left,center,right.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = 'center')]
		$horizontalAlignment="center",

		# $isSubtle is whether this text should be subtle/faint (default: false).
		# Options: true,false.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = 'false')]
		$isSubtle="false",

		# $maxLines is the maximum number of lines to display (default: false).
		# Options: number,$null.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = '$null')]
		$maxLines=$null,

		# $size is the size of the text (default: ExtraLarge).
		# Options: default,small,medium,large,extraLarge.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = 'ExtraLarge')]
		$size="ExtraLarge",

		# $weight is the font weight (default: bolder).
		# Options: default,lighter,bolder.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = 'bolder')]
		$weight="bolder",

		# $wrap is whether to wrap text over lines, otherwise clipped (default: true).
		# Options: true,false.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = 'true')]
		$wrap="true",

		# $style is the block style to apply (default: default).
		# Options: default,heading.
		[Parameter(Mandatory=$false)]
		[PSDefaultValue(Help = 'default')]
		$style="default"
	)

	$textblock = [PSCustomObject]@{
		type = 'TextBlock'
		text = "$text"
		color = "$color"
		fontType = "$fontType"
		horizontalAlignment = "$horizontalAlignment"
		isSubtle = "$isSubtle"
		#maxLines = "$maxLines"
		size = "$size"
		weight = "$weight"
		wrap = "$wrap"
		style = "$style"
	}

	#ADD OPTIONAL PROPERTIES THAT CAN CAUSE ISSUES IF SUPPLIED AS ""
	If($maxLines -ne "") {
		$textblock.maxLines = "$maxLines"
	}

	return $textblock;
}