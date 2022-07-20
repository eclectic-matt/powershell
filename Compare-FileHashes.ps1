param($source, $check);
<#
.Description
	Take two files and check if they match, uses file hashes to compare, return: true if hashes match, false otherwise.
.Parameter $source
	The source file to check.
.Parameter $check
	The other file to match against.
#>

#TAKE INPUT
#$fileOne = $args[0];
#$fileOne = "D:\web\sites\xepta.com\dev\nukulams\script\xmlrpc\server\server.php";
$fileOne = $source;
#$fileTwo = $args[1];
#$fileTwo = "L:\web\sites\nukula.com\ims\script\xmlrpc\server\server.php";
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