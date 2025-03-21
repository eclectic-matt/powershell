class Fact {
	
	[String] $title
	[String] $value
	hidden [PSCustomObject] $object

	Fact(){
		$this.title = $null;
		$this.value = $null;
		$this.object = $null;
	}

	setTitle($title){
		$this.title = $title;
		$this.out();
	}
	setValue($value){
		$this.value = $value;
		$this.out();
	}

	[PSCustomObject] out(){
		if( ($null -eq $this.title) -Or ($null -eq $this.value)){
			throw "This [Fact] has no title/value!";
		}else{
			$this.object = [PSCustomObject]@{
				type = 'Fact'
				title = $this.title
				value = $this.value
			}
			return $this.object;
		}
	}
}