class Image {

	[String] $url
	[String] $altText
	[String] $backgroundColor
	[String] $height
	[String] $horizontalAlignment
	[String] $selectAction
	[String] $size
	#THIS IS THE CONTENT
	hidden [PSCustomObject] $object

	#DEFAULT DEFINITION (NO INPUT)
	Image(){
		$this.url = $null
		$this.altText = 'Image Description'
		$this.backgroundColor = '#fff'
		$this.height = 'auto'
		$this.horizontalAlignment = 'center'
		$this.selectAction = $null
		$this.size = 'stretch' #'auto'
		#THIS IS THE CONTENT
		$this.object = $null
	}

	#JUST TEXT?
	Image(
		$url
	){
		$enc        = [System.Text.Encoding]::UTF8
		$byte_array = $enc.GetBytes($url);
		#write-host    $byte_array
		$formatUrl  = $enc.GetString($byte_array)
        #TESTING HERE
        #$formatUrl = $formatUrl -replace '\u0026', '&';
		#$this.url = $url
		$this.url = $formatUrl
		$this.out();
	}

	#==============
	# SETTERS
	#==============

	#SET THE URL
	[void] setUrl(
		$url
	){
        #Write-Host ("SETTING IMAGE URL TO: " + $url);
		$this.url = [string] $url;
		#GENERATE THE OUTPUT OBJECT
		$this.out();
	}
	#SET THE ALT TEXT
	[void] setAltText(
		$altText
	){
		$this.altText = $altText;
		#GENERATE THE OUTPUT OBJECT
		$this.out();
	}
	#SET THE BACKGROUND COLOUR
	[void] setBackgroundColor (
		$color
	){
		$this.backgroundColor = $color;
		#GENERATE THE OUTPUT OBJECT
		$this.out();
	}
	#SET THE HEIGHT
	[void] setHeight (
		$height
	){
		$this.height = $height;
		#GENERATE THE OUTPUT OBJECT
		$this.out();
	}
	#SET THE HORIZONTAL ALIGNMENT
	[void] setHorizontalAlignment (
		$horizontalAlignment
	){
		$this.horizontalAlignment = $horizontalAlignment;
		#GENERATE THE OUTPUT OBJECT
		$this.out();
	}
	#SET THE SELECT ACTION
	[void] setSelectAction (
		$selectAction
	){
		$this.selectAction = $selectAction;
		#GENERATE THE OUTPUT OBJECT
		$this.out();
	}
	#SET THE SIZE
	[void] setSize (
		$size
	){
		$this.size = $size;
		#GENERATE THE OUTPUT OBJECT
		$this.out();
	}

	#==============
	# OUTPUT
	#==============

	[PSCustomObject] out(){
		#GENERATE OBJECT TO STORE
		$this.object = [PSCustomObject]@{
			type = 'Image'
			url = $this.url
			altText = $this.altText
			backgroundColor = $this.backgroundColor
			height = $this.height
			horizontalAlignment = $this.horizontalAlignment
			#selectAction = $this.selectAction
			size = $this.size
		}
		return $this.object;
	}
}