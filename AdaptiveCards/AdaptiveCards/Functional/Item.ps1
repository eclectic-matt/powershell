# INCLUDE New-TextBlock
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\CardElements\TextBlock.ps1

# IMPORT New-Image
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\CardElements\Image.ps1

<#
	TO DO
#>
function New-Item{
    param(
        [Parameter(Mandatory=$true)] [System.Object]$item
    )

	switch($item["type"]){
		"TextBlock" {
			$textblock = New-TextBlock -text $item.text -size $item.size -horizontalAlignment $item.horizontalAlignment -weight $item.weight -wrap $item.wrap;
			return $textblock;
		}
		"Image" {
			$image = New-Image -url $item.url -size $item.size -altText $item.altText;
			return $image;
		}
	}
}