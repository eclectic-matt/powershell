class TextBlock {

	[String] $text
	[String] $color
	[String] $fontType
	[String] $horizontalAlignment
	[Boolean] $isSubtle
	[Nullable[Int]] $maxLines
	[String] $size
	[String] $weight
	[Boolean] $wrap
	[String] $style
	#THIS IS THE CONTENT
	hidden [PSCustomObject] $object

	#DEFAULT DEFINITION (NO INPUT)
	TextBlock(){
		$this.text = "This is the text content"
		$this.color = "default"
		$this.fontType = "default"
		$this.horizontalAlignment = "center"
		$this.isSubtle = $false
		$this.maxLines = $null
		$this.size = "default"
		$this.weight = "bolder"
		$this.wrap = $true
		$this.style = "default"
		#THIS IS THE CONTENT
		$this.object = $null
	}

	#JUST TEXT?
	TextBlock(
		$text
	){
		$this.text = $text
		$this.out();
	}

	TextBlock(
		[String] $text,
		[String] $color,
		[String] $fontType,
		[String] $horizontalAlignment,
		[Boolean] $isSubtle,
		[Nullable[Int]] $maxLines,
		[String] $size,
		[String] $weight,
		[Boolean] $wrap,
		[String] $style
	){
		#HANDLE INPUTS
		if($null -eq $text){
			throw "Cannot make a TextBlock without text!";
		}else{
			$this.text = $text;
		}
		if($null -eq $color){
			$this.color = "default";
		}else{
			$this.color = $color;
		}
		if($null -eq $fontType){
			$this.fontType = "default";
		}else{
			$this.fontType = $fontType;
		}
		if($null -eq $horizontalAlignment){
			$this.horizontalAlignment = "center";
		}else{
			$this.horizontalAlignment = $horizontalAlignment;
		}
		if($null -eq $isSubtle){
			$this.isSubtle = $false;
		}else{
			$this.isSubtle = $isSubtle;
		}
		if($null -eq $maxLines){
			$this.maxLines = $null;
		}else{
			$this.maxLines = $maxLines;
		}
		if($null -eq $size){
			$this.size = "default";
		}else{
			$this.size = $size;
		}
		if($null -eq $weight){
			$this.weight = "default";
		}else{
			$this.weight = $weight;
		}
		if($null -eq $wrap){
			$this.wrap = $true;
		}else{
			$this.wrap = $wrap;
		}
		if($null -eq $style){
			$this.style = "default";
		}else{
			$this.style = $style;
		}

		#GENERATE THE OUTPUT OBJECT
		$this.out();
	}


	#==============
	# SETTERS
	#==============

	#SET THE TEXT
	[void] setText(
		$text
	){
		$this.text = $text;
		#GENERATE THE OUTPUT OBJECT
		$this.out();
	}
	#SET THE COLOUR
	[void] setColor(
		$color
	){
		$this.color = $color;
		#GENERATE THE OUTPUT OBJECT
		$this.out();
	}
	#SET THE FONT TYPE
	[void] setFontType (
		$fontType
	){
		$this.fontType = $fontType;
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
	#SET THE WEIGHT
	[void] setWeight (
		$weight
	){
		$this.weight = $weight;
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
	#SET THE isSubtle FLAG
	[void] setIsSubtle (
		$isSubtle
	){
		$this.isSubtle = $isSubtle;
		#GENERATE THE OUTPUT OBJECT
		$this.out();
	}
	#SET THE MAX LINES
	[void] setMaxLines (
		$maxLines
	){
		$this.maxLines = $maxLines;
		#GENERATE THE OUTPUT OBJECT
		$this.out();
	}
	#SET THE WRAP FLAG
	[void] setWrap (
		$wrap
	){
		$this.wrap = $wrap;
		#GENERATE THE OUTPUT OBJECT
		$this.out();
	}
	#SET THE STYLE
	[void] setStyle (
		$style
	){
		$this.style = $style;
		#GENERATE THE OUTPUT OBJECT
		$this.out();
	}


	#==============
	# OUTPUT
	#==============

	[PSCustomObject] out(){
		#GENERATE OBJECT TO STORE
		$this.object = [PSCustomObject]@{
			type = 'TextBlock'
			text = $this.text
			color = $this.color
			fontType = $this.fontType
			horizontalAlignment = $this.horizontalAlignment
			isSubtle = $this.isSubtle
			maxLines = $this.maxLines
			size = $this.size
			weight = $this.weight
			wrap = $this.wrap
			style = $this.style	
		}
		return $this.object;
	}
}