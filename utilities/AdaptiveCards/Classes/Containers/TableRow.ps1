class TableRow {
	
	[System.Collections.ArrayList] $cells
	hidden [PSCustomObject] $object

	TableRow(){
		$this.cells = $null;
	}

	setCells($cells){
		$this.cells = $cells;
		$this.out();
	}
	addCell($cell){
		$this.cells += $cell;
		$this.out();
	}

	[PSCustomObject] out(){
		if($null -eq $this.cells){
			throw "This [TableRow] has no cells!";
		}else{
			$this.object = [PSCustomObject]@{
				type = 'TableRow'
				cells = $this.cells
			}
			return $this.object;
		}
	}
}