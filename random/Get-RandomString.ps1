#param($chars, $length);
<#
.Description
	Generate a random string
.Parameter $chars
    The permitted characters for this string, e.g:
     * [ABCDEFGHJKLMNPRSTUVWXYZ0123456789]
.Parameter $length
    The length of the resulting string
#>

function Get-RandomString($chars, $length){
    #INIT RANDOM STRING
    $randomString = '';

    for($i = 0; $i -lt $length; $i++){
        $randomIndex = Get-Random -Maximum $chars.length;
        $randomString = ($randomString + $chars[$randomIndex]);
    }

    return $randomString;
}