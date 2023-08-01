#param($minDate="2000-01-01", $maxDate="2030-12-31");
<#
.Description
	Generate a random date in YYYY-mm-dd FORMAT
.Parameter $minDate
    The minimum date
.Parameter $maxDate
    The maximum date
#>

function Get-RandomDate($minDate, $maxDate){

    $Start = Get-Date $minDate.toString();
    $End = Get-Date $maxDate.ToString();
    $Random = Get-Random -Minimum $Start.Ticks -Maximum $End.Ticks


    $randomDate = [datetime]$Random;

    $formatDate = Get-Date $randomDate -Format "yyyy-MM-dd";

    return $formatDate;
}