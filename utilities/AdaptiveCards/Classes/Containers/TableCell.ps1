class TableCell {

	[System.Collections.ArrayList] $items
	[String] $style
	hidden [PSCustomObject] $object

	TableCell(){
		$this.items = @()
		$this.style = 'default'
	}

	#===========
	# SETTERS
	#===========
	setItems($items){
		$this.items = $items;
		$this.out();
	}
	addItem($item){
		$this.items += $item;
		$this.out();
	}
	#ContainerStyle
	setStyle($style){
		$this.style = $style;
		$this.out();
	}

	[PSCustomObject] out(){
		if($null -eq $this.items){
			throw "This [TableCell] has no items!";
		}else{
			$this.object = [PSCustomObject]@{
				type = 'TableCell'
				items = $this.items
				style = $this.style
			}
			return $this.object;
		}
	}
}