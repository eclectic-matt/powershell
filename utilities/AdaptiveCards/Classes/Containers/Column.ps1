class Column {

	[Array] $items
	[String] $width
	[Boolean] $separator
	hidden [PSCustomObject] $object

	#CONSTRUCTOR, NO INPUT
	Column(){
		$this.items = $null
		$this.width = 'stretch'
		$this.separator = $false
		$this.object = $null
	}

	#===========
	# SETTERS
	#===========
	setItems($items){
		$this.items = $items;
		$this.out();
	}
	#ADD 1 ITEM TO THE COLUMN
	addItem($item){
		$this.items += $item;
		$this.out();
	}
	#SHOULD THIS COLUMN INCLUDE A SEPARATOR FROM THE PREVIOUS COLUMN 
	setSeparator($separate){
		$this.separator = $separate;
	}

	[PSCustomObject] out(){
		if($null -eq $this.items){
			throw "This [Column] has no items!";
		}else{
			$this.object = [PSCustomObject]@{
				type = 'Column'
				items = @($this.items)
				width = $this.width
				separator = $this.separator
			};
			return $this.object;
		}
	}
}