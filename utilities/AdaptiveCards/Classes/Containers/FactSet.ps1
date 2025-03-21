class FactSet {
	
	[System.Collections.ArrayList] $facts
	hidden [PSCustomObject] $object

	FactSet(){
		$this.facts = $null;
	}

	setFacts($facts){
		#$this.facts = [System.Collections.ArrayList]::new();
		#$this.facts.add($facts);
		[System.Collections.ArrayList]$this.facts = ($facts);
		$this.out();
	}
	addFact($fact){
		#$this.facts = @($this.facts, $fact);
		$this.facts.add($fact);
		#$this.facts += $fact;
		$this.out();
	}

	[PSCustomObject] out(){
		if($null -eq $this.facts){
			throw "This [FactSet] has no facts!";
		}else{
			$this.object = [PSCustomObject]@{
				type = 'FactSet'
				facts = $this.facts
			}
			return $this.object;
		}
	}
}