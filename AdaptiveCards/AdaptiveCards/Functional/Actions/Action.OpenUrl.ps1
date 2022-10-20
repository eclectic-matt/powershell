<# 
	.SYNOPSIS
		Generates an OpenUrl SelectAction action for an AdaptiveCard.
	.DESCRIPTION
		Takes the options for an OpenURL action and returns
		a SelectAction object with the required structure
		for an AdaptiveCard.
	.LINK
		https://adaptivecards.io/explorer/Action.OpenUrl.html
#>
function New-ActionOpenUrl {

    param(
		# [String] $url is the URL to open with this action (required).
		[Parameter(Mandatory=$true)] [String]$url,

        # [String] $title is the label for a link or button for this action (default: $null).
        [Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
		[String]$title=$null,

        # [String] $iconUrl is the optional icon to be shown in conjunction with the title (default: $null).
        [Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
		[String]$iconUrl=$null,

        # [String] $id is the unique identifier for this action (default: $null).
        [Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
		[String]$id=$null,

        #NOTE: THE ActionStyle DO NOT WORK ON MS TEAMS! SO default/positive/destructive ALL LOOK THE SAME!
        # [ActionStyle] $style controls the style of how the action is displayed, spoken etc (default: "default").
        [Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = 'default')]
        [ValidateNotNullOrEmpty()]
		[ActionStyle]$style=[ActionStyle]::default,

        # [PSCustomObject] $fallback controls what to do when an unknown element is encountered (default: $null).
        [Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
        [ValidateNotNullOrEmpty()]
		[PSCustomObject]$fallback=$null,

        # [String] $tooltip defines text displayed to the user on hover or via screen reader (default: $null).
        [Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
        [ValidateNotNullOrEmpty()]
		[String]$tooltip=$null,

        # [Boolean] $isEnabled determines if an action should be enabled (default: $true).
        [Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$true')]
        [ValidateNotNullOrEmpty()]
		[Boolean]$isEnabled=$true,

        # [ActionMode] $mode determines if the action is a button or in an overflow menu (default: primary).
        [Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
        [ValidateNotNullOrEmpty()]
		[Nullable[ActionMode]]$mode=[ActionMode]::primary,

        # [String] $requires is a series of key/value pairs indicating required features (default: $null).
        [Parameter(Mandatory=$false)] 
		[PSDefaultValue(Help = '$null')]
        [ValidateNotNullOrEmpty()]
		[String]$requires=$null
	)

    $action = [PSCustomObject]@{
		type = 'Action.OpenUrl'
		url = "$url"
		title = "$title"
        iconUrl = "$iconUrl"
        id = "$id"
        style = "$style"
        fallback = ""
        tooltip = "$tooltip"
        isEnabled = $isEnabled
        mode = "$mode"
        requires = "$requires"
	}

    #ADD/REMOVE $null OPTIONAL PROPERTIES
    $nullableProps = @('title', 'iconUrl', 'id', 'fallback', 'tooltip', 'mode', 'requires');

    foreach($prop in $nullableProps){
        if($null -ne (Get-Variable -Name "$prop" -ValueOnly) -And (Get-Variable -Name "$prop" -ValueOnly) -ne ""){
            $action."$prop" = Get-Variable -Name "$prop" -ValueOnly;
        }else{
            $action.PSObject.Properties.Remove("$prop");
        }
    }
    
	return $action;
}