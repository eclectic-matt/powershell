class ImageSet {
	
	[System.Collections.ArrayList] $images
    [string] $imageSize
	hidden [PSCustomObject] $object

    <#
    Image Sizes, from https://adaptivecards.io/explorer/ImageSet.html#dedupe-headerimagesize
    "auto": Image will scale down to fit if needed, but will not scale up to fill the area.
    "stretch": Image with both scale down and up to fit as needed.
    "small": Image is displayed with a fixed small width, where the width is determined by the host.
    "medium": Image is displayed with a fixed medium width, where the width is determined by the host.
    "large": Image is displayed with a fixed large width, where the width is determined by the host.
    #>

	ImageSet(){
		$this.images = [System.Collections.ArrayList]::new();
        $this.imageSize = "medium";
	}

	setImages($images){
		[System.Collections.ArrayList]$this.images = ($images);
		$this.out();
	}
	addImage($image){
		$this.images.Add($image);
		$this.out();
	}
    setSize($imageSize){
        $validSizes = @("auto", "stretch", "small", "medium", "large");
        if ($validSizes -contains $imageSize){
            $this.imageSize = $imageSize;
        }else{
            throw ("Image Size must be one of " + $validSizes -join(",") );
        }
    }

	[PSCustomObject] out(){
		if($null -eq $this.images){
			throw "This [ImageSet] has no images!";
		}else{
			$this.object = [PSCustomObject]@{
				type = 'ImageSet'
				images = $this.images
			}
			return $this.object;
		}
	}
}