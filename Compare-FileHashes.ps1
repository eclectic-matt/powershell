param($source, $check);
<#
.Description
	Take two files and check if they match, uses file hashes to compare, return: true if hashes match, false otherwise.
.Parameter $source
	The source file to check.
.Parameter $check
	The other file to match against.
#>

#TAKE INPUT (NAMED PARAMS)
$fileOne = $source;
$fileTwo = $check;

#GET HASHES
$hashOne = Get-FileHash $fileOne | Format-List;
$hashTwo = Get-FileHash $fileTwo | Format-List;

#COMPARE HASHES
if($hashOne['Hash'] -eq $hashTwo['Hash']){

	return $true;
}else{

	return $false;
}
