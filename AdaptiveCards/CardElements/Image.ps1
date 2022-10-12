<# 
	.SYNOPSIS
		Generates an ImageBlock element for an AdaptiveCard.
	.DESCRIPTION
		Takes a url (mandatory) and formatting options and
		returns an object with the required structure
		for an AdaptiveCard.
	.LINK
		https://adaptivecards.io/explorer/Image.html
#>
function New-Image{

	param(
		# [String] $url is the URL of the image source (required).
		[Parameter(Mandatory=$true)] [String]$url,

		# [String] $altText is the alt text for accessibility (default: Image Description).
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = 'Image Description')]
		$altText="Image Description",

		# $backgroundColor is displayed below transparent images (default: $null).
		# Options: hexCode
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
		$backgroundColor=$null,

		# $height is desired height of the image (default: auto).
		# Note if a "px" value is supplied, the image will distort to 
		# fit that exact height and overrides the $size property.
		# Options: string,auto,stretch.
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = 'auto')]
		$height="auto",

		# $horizontalAlignment is how to position the image within its parent (default: inherited).
		# Options: ""(inherit),left,center,right.
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = 'inherit')]
		$horizontalAlignment="",

		# $selectAction is invoked when the image is clicked (default: "").
		# Options: "",Action.Execute,Action.OpenUrl,Action.Submit,Action.ToggleVisibility.
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '')]
		$selectAction="",

		# $size is the size of the output image (default: auto).
		# Options: auto,stretch,small,medium,large.
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = 'auto')]
		$size="auto"
	)

	$image = [PSCustomObject]@{
		type = 'Image'
		url = "$url"
		altText = "$altText"
		#backgroundColor = "$backgroundColor"
		height = "$height"
		horizontalAlignment = "$horizontalAlignment"
		#selectAction = "$selectAction"
		size = "$size"
	}

	#ADD OPTIONAL PROPERTIES THAT CAN CAUSE ISSUES IF SUPPLIED AS ""
	If($backgroundColor -ne "") {
		$image.backgroundColor = "$backgroundColor"
	}
	If ($selectAction -ne "") {
		$image.selectAction = "$selectAction"
	}

	return $image;
}