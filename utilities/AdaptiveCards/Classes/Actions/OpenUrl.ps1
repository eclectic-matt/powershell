<#
	.SYNOPSIS
	Generates an OpenUrl SelectAction for an AdaptiveCard.

	.DESCRIPTION
		Takes the options for an OpenURL action and returns
		a SelectAction object with the required structure
		for an AdaptiveCard.
	.LINK
		https://adaptivecards.io/explorer/Action.OpenUrl.html
#>

class ActionOpenUrl {
	
	[String] $url
	[String] $title
	[String] $iconUrl
	hidden [PSCustomObject] $object

	ActionOpenUrl(
		[String] $url
	){
		$this.url = $url
		$this.out();
	}

	ActionOpenUrl(
		[String] $url,
		[String] $title
	){
		$this.url = $url;
		$this.title = $title;
		$this.out();
	}

	[PSCustomObject] out(){
		if($null -eq $this.url){
			throw "This [ActionOpenUrl] has no url!";
		}else{
			$this.object = [PSCustomObject]@{
				type = 'Action.OpenUrl'
				url = $this.url
				title = $this.title
				iconUrl = $this.iconUrl
			}
			return $this.object;
		}
	}
}