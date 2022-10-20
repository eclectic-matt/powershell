#IMPORT ENUMS
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Enums.ps1

class AdaptiveCard {

	[String] $version
	[String] $speak
	[PSCustomObject] $body
	[PSCustomObject] $object

	#DEFAULT, NO INPUT
	AdaptiveCard(){
		$this.version = "1.4"
		$this.speak = "Text to be spoken"
		$this.body = ""
		$this.object = $null
	}

	#PASS A BODY ONLY?
	AdaptiveCard(
		#[String]$version,
		#[String]$speak,
		[PSCustomObject]$body
	){
		$this.body = $body;
		$this.object = [PSCustomObject]@{
			type = 'AdaptiveCard'
			version = '1.4'
			msTeams = [PSCustomObject]@{
				width = 'full'
			}
			speak = 'Spoken output'
			body = @(
				$this.body
			)
		}
	}

	[String] out(){
		if($null -eq $this.object){
			throw "The [AdaptiveCard] has no content!"
		}else{
			return $this.object;
			#JSON REQUIRED AT "MESSAGE" OBJECT LEVEL
			#return ConvertTo-Json $this.object -Depth 100;
		}
	}
}