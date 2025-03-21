class ArkhamDB {

    [String] $id
	[String] $baseUrl
	[String] $cacheFolder
	
    ArkhamDB(){
        $this.id = 1;
        $this.baseUrl = 'https://arkhamdb.com/api/public/';
        $this.cacheFolder = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\data\arkhamdb\";
    }

    [object] callAndGetJson(
        [string] $url
    ){
        $stringResponse = Invoke-WebRequest -Uri $url;
        $jsonResponse = ConvertFrom-Json $stringResponse;
        return $jsonResponse;
    }

    <#[object] outputInvestigators(
        [object] $setData
    ){
        foreach($card in $setData){
            if($card.type_name -eq "Investigator"){
                Write-Host ($card.name + " (id: " + $card.code + ")");
            }

            return $this.getCardData($card.code);
        }
    }#>

    [boolean] outputDeckbuilding(
        [string] $name
    ){

        Write-Host "===============================";
        Write-Host "DECKBUILDING '$name'";
        Write-Host "===============================";
        Write-Host "";

        $card = $this.getInvestigatorCard($name);

        if($card -eq $false){
            Write-Host ("CANNOT GET INVESTIGATOR CARD FOR " + $name);
            return $false;
        }

        Write-Host "DECK REQUIREMENTS";
        Write-Host ("Deck Size: " + $card.deck_requirements.size);
        $requiredLength = ($card.deck_requirements.card.psobject.properties.name).Count;
        for($i = 0; $i -lt $requiredLength; $i++){
            $requiredCardId = $card.deck_requirements.card[0].psobject.properties.name[$i];
            $requiredCard = Get-Content ($this.cacheFolder + "cards\" + $requiredCardId + ".json") | ConvertFrom-Json;
            Write-Host ("[required card] " + $requiredCard.name);
        }
        Write-Host ("[required random] " + $card.deck_requirements.random[0].value);
        Write-Host "";
            
        Write-Host "DECK OPTIONS";
        $deckOptionLength = $card.deck_options.Count;
        #Write-Host ("DECK OPTIONS LENGTH: " + $deckOptionLength);
        for($i = 0; $i -lt $deckOptionLength; $i++){
            $option = ($card.deck_options[$i]);
            Write-Host ("[faction option] " + $option.faction + " cards, level " + $option.level.min + "-" + $option.level.max);
        }

        Write-Host "";
        #Write-Host "=====================";
        Write-Host "";
        return $true;
    }

    [array] getFactionCards(
        [string] $faction="Guardian", 
        [int] $level=-1
    ){
        Write-Host ("Getting results for $faction at level $level");
        $searchResults = $this.cacheFolder + "cards" | Get-ChildItem -Recurse | Select-String $faction -List;
        #Write-Host $searchResults;
        $resultsArr = [System.Collections.ArrayList]@();
        foreach($result in $searchResults){
            #LOAD THE CARD
            $card = Get-Content -Path $result.Path -Raw | ConvertFrom-Json;
            #Write-Host ($card.name + " -> " + $card.faction_code + " -> " + $card.xp);
            #CHECK THIS FACTION MATCHES
            if($card.faction_code -eq $faction){
                #if(Get-Variable -Name "card.xp" -Scope Local){
                if($card.xp -ne $null){
                    #CHECK THIS LEVEL MATCHES (IF NOT -1)
                    if( ($level -ne -1) -and ($card.xp -eq $level) ){
                        #Write-Host ("Card " + $card.name + "[" + $card.xp + "] matches level " + $level);
                        #ADD TO RETURN ARRAY
                        $resultsArr.Add($card);
                    }
                }else{
                    #Write-Host ("Card " + $card.name + " has no xp");
                    #NO XP SET - ADD TO RETURN ARRAY
                    $resultsArr.Add($card);
                }
            }
        }
        return $resultsArr;
    }

    [object] getSetData(
        [string] $code
    ){
    
        $setLocalCachePath = $this.cacheFolder + "/sets/" + $code + ".json";
        if(Test-Path $setLocalCachePath){
            Write-Host ("GETTING CARD DATA FROM CACHED JSON AT: " + $setLocalCachePath);
            $setData = Get-Content $setLocalCachePath | ConvertFrom-Json;
        }else{
            $setUrl = ($this.baseUrl + "cards/" + $code + ".json");
            Write-Host ("GETTING REMOTE CARD DATA FROM: " + $setUrl);
            $setData = callAndGetJson($setUrl);
            #THEN CACHE DATA?
            $setData | ConvertTo-Json -depth 100 | Out-File ($this.cacheFolder + "\sets\" + $code + ".json");# > $silent;
        }
        return $setData;
    }

    [object] getCardData(
        [string] $code
    ){
        $cardLocalCachePath = $this.cacheFolder + "/cards/" + $code + ".json";
        if(Test-Path $cardLocalCachePath){
            Write-Host ("GETTING CARD DATA FROM CACHED JSON AT: " + $cardLocalCachePath);
            $setData = Get-Content $cardLocalCachePath | ConvertFrom-Json;
        }else{
            $setUrl = ($this.baseUrl + "card/" + $code);
            Write-Host ("GETTING REMOTE CARD DATA FROM: " + $setUrl);
            $setData = callAndGetJson($setUrl);
            #THEN CACHE DATA?
            $setData | ConvertTo-Json -depth 100 | Out-File ($this.cacheFolder + "\cards\" + $code + ".json");# > $silent;
        }
        return $setData;
    }

    [object] getInvestigatorCard(
        [string] $name
    ){
        $searchResults = $this.cacheFolder + "cards" | Get-ChildItem -Recurse | Select-String $name -List;
        foreach($result in $searchResults){
            #LOAD THE CARD
            $card = Get-Content -Path $result.Path -Raw | ConvertFrom-Json;
            if($card.name -eq $name){
                return $card;
            }
        }
        return $false;
    }

}