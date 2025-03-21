class Table {

	[PSCustomObject] $columns
	[PSCustomObject] $rows
	[Boolean] $firstRowAsHeader
	[Boolean] $showGridLines
	[String] $gridStyle
	[String] $horizontalCellContentAlignment
	[String] $verticalCellContentAlignment
	hidden [PSCustomObject] $object

	#CONSTRUCTOR, NO INPUT
	Table(){
		$this.columns = $null
		$this.rows = $null
		$this.firstRowAsHeader = $true
		$this.showGridLines = $true
		$this.gridStyle = 'default'
		$this.horizontalCellContentAlignment = 'center'
		$this.verticalCellContentAlignment = 'center'
		$this.object = $null
	}

	#===========
	# SETTERS
	#===========
	setColumns($columns){
		$this.columns = $columns;
		$this.out();
	}
	#SET ALL ROWS AT ONCE
	setRows($rows){
		$this.rows = $rows;
		$this.out();
	}
	#ADD 1 ROW TO THE ROWS ARRAY
	addRow($row){
		$this.rows += $row;
		$this.out();
	}
	#SET THE GRID LINES FLAG
	setShowGridLines($showGridLines){
		$this.showGridLines = $showGridLines;
		$this.out();
	}
	#SET THE FIRST ROW AS HEADER FLAG
	setFirstRowAsHeader($firstRowAsHeader){
		$this.firstRowAsHeader = $firstRowAsHeader;
		$this.out();
	}
	#SET THE STYLE
	setStyle($style){
		$this.style = $style;
		$this.out();
	}
	#SET HORIZONTAL CELL CONTENT ALIGNMENT
	setHorizontalCellContentAlignment($alignment){
		$this.horizontalCellContentAlignment = $alignment;
		$this.out();
	}
	#SET VERTICAL CELL CONTENT ALIGNMENT
	setVerticalCellContentAlignment($alignment){
		$this.verticalCellContentAlignment = $alignment;
		$this.out();
	}

	[PSCustomObject] out(){
		if($null -eq $this.rows){
			throw "This [Table] has no rows!";
		}else{
			$this.object = [PSCustomObject]@{
				type = 'Table'
				columns = @($this.columns)
				rows = @($this.rows)
				firstRowAsHeader = $this.firstRowAsHeader
				showGridLines = $this.showGridLines
				gridStyle = $this.gridStyle
				horizontalCellContentAlignment = $this.horizontalCellContentAlignment
				verticalCellContentAlignment = $this.verticalCellContentAlignment
			};
			return $this.object;
		}
	}
}