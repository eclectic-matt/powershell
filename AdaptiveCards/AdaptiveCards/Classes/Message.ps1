class Message {

	[PSCustomObject] $content
	[PSCustomObject] $object

	Message(){
		$this.object = $null;
	}

	Message(
		[PSCustomObject] $content
	){
		$this.content = $content;
		$this.out();
	}

	#==============
	# SETTERS
	#==============
	#SET THE CONTENT
	[void] setContent (
		$content
	){
		$this.content = $content;
		#GENERATE THE OUTPUT OBJECT
		$this.out();
	}

	[String] out(){
		if($null -eq $this.content){
			throw "This [Message] has no content!"
		}else{
			#GENERATE IN CONSTRUCTOR
			$this.object = [PSCustomObject]@{
				type = 'message'
				attachments = @(
					[PSCustomObject]@{
						contentType = 'application/vnd.microsoft.card.adaptive'
						contentUrl = $null
						content = $this.content
					}
				)
			}
			return ConvertTo-Json $this.object -Depth 100;
		}
	}
}