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

# IMPORT ACTION OPEN URL
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Actions\Action.OpenUrl.ps1

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
        [ValidateNotNullOrEmpty()]
        #[ValidateSet([String],'auto','stretch')] #CANNOT IMPLEMENT IN STANDARD FUNCTION PARAM/ENUM, MAYBE POSSIBLE IN A CLASS?
        #https://adamtheautomator.com/powershell-classes/
		#$height="auto",
        [BlockElementHeight]$height=[BlockElementHeight]::auto,

		# $horizontalAlignment is how to position the image within its parent (default: inherited).
		# Options: ""(inherit),left,center,right.
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = 'center')]
        [ValidateNotNullOrEmpty()]
		[HorizontalAlignment]$horizontalAlignment=[HorizontalAlignment]::center,

		# $selectAction is invoked when the image is clicked (default: "").
		# Options: "",Action.Execute,Action.OpenUrl,Action.Submit,Action.ToggleVisibility.
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
        #[Nullable[ISelectAction]]$selectAction=$null, #NO, NEED TO DEFINE THESE SEPARATELY (Action.OpenUrl, Action.Submit etc...)
        $selectAction=$null,

		# $size is the size of the output image (default: auto).
		# Options: auto,stretch,small,medium,large.
		[Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = 'auto')]
        [ValidateNotNullOrEmpty()]
		[ImageSize]$size=[ImageSize]::auto
	)

	$image = [PSCustomObject]@{
		type = 'Image'
		url = "$url"
		altText = "$altText"
		backgroundColor = ""
		height = "$height"
		horizontalAlignment = "$horizontalAlignment"
		selectAction = ""
		size = "$size"
	}

    #ADD/REMOVE $null OPTIONAL PROPERTIES
	if($null -ne $backgroundColor){
		$image.backgroundColor = "$backgroundColor"
	}else{
		$image.PSObject.Properties.Remove('backgroundColor');
	}

    #ADD/REMOVE $null OPTIONAL PROPERTIES
	if($null -ne $selectAction){
		$image.selectAction = $selectAction;
	}else{
		$image.PSObject.Properties.Remove('selectAction');
	}

	return $image;
}