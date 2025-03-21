class ColumnSet {

	[Array] $columns
	hidden [PSCustomObject] $object

	#CONSTRUCTOR, NO INPUT
	ColumnSet(){
		$this.columns = $null
		$this.object = $null
	}

	#===========
	# SETTERS
	#===========
	setColumns($columns){
		$this.columns = $columns;
		$this.out();
	}
	#ADD 1 COLUMN TO THE SET
	addColumn($column){
		$this.columns += $column;
		$this.out();
	}

	[PSCustomObject] out(){
		if($null -eq $this.columns){
			throw "This [ColumnSet] has no columns!";
		}else{
			$this.object = [PSCustomObject]@{
				type = 'ColumnSet'
				columns = @($this.columns)
			};
			return $this.object;
		}
	}
}