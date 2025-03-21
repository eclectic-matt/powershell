class Container {

	[Array] $items
	[PSCustomObject] $selectAction
	hidden [PSCustomObject] $object

	#CONSTRUCTOR, NO INPUT
	Container(){
		$this.items = $null
		$this.selectAction = $null
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
	setSelectAction($action){
		$this.selectAction = $action;
		$this.out();
	}

	[PSCustomObject] out(){
		if($null -eq $this.items){
			throw "This [Container] has no items!";
		}else{
			$this.object = [PSCustomObject]@{
				type = 'Container'
				items = @($this.items)
				selectAction = $this.selectAction
			};
			return $this.object;
		}
	}
}