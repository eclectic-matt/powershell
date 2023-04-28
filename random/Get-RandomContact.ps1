param($name);
<#
.Description
	Generate a random human name string.
.Parameter $name
    An input name used to generate the email.
#>

#Cls

#INIT CONTACT ARRAY
$contact = @{email=''; landline=''; mobile=''; work=''}

#LOAD JSON
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\random\random.json";
$file = Get-Content -Path $fileName -Raw;
$json = ConvertFrom-Json $file;

#GENERATE EMAIL
if($null -ne $name){

    #USE NAME TO GENERATE
    $firstInitial = $name.first.Substring(0,1);
    $lastInitial = $name.last.Substring(0,1);
    $randomNumber = Get-Random -Minimum 1 -Maximum 999999;
    $providers = $json.contact.email.provider;
    $providerCount = $providers.length;
    $providerIndex = Get-Random -Maximum ($providerCount - 1);
    $provider = $providers[$providerIndex];

    #$contact.email = ($firstInitial + $lastInitial + $randomNumber + $provider);
}else{
    #GET THE RANDOM FOLDER (MAY NOT BE INVOKED FROM HERE)
    $scriptpath = $MyInvocation.MyCommand.Path
    $dir = Split-Path $scriptpath
    #GET THE Get-RandomName FILE
    $randomPath = $dir + "\Get-RandomName.ps1";
    #CALL THIS SCRIPT TO GET A RANDOM NAME
    $name = . $randomPath;

    #USE NAME TO GENERATE
    $firstInitial = $name.first.Substring(0,1);
    $lastInitial = $name.last.Substring(0,1);
    $randomNumber = Get-Random -Minimum 1 -Maximum 999999;
    $providers = $json.contact.email.provider;
    $providerCount = $providers.length;
    $providerIndex = Get-Random -Maximum ($providerCount - 1);
    $provider = $providers[$providerIndex];

    #$contact.email = ($firstInitial + $lastInitial + $randomNumber + $provider);
}

$emailFormat = Get-Random -Maximum 5;
#USE A RANDOM EMAIL FORMAT
switch($emailFormat)
{
    1{
        #fl0000@provider.com
        $email = ($firstInitial + $lastInitial + $randomNumber + $provider);
    }
    2 {
        #firstlast@provider.com
        $email = ($name.first + $name.last + $provider);
    }
    3 {
        #firstlast00000@provider.com
        $email = ($name.first + "." + $name.last + $randomNumber + $provider);
    }
    4 {
        #f.last00000@provider.com
        $email = ($firstInitial + "." + $name.last + $randomNumber + $provider);
    }
}

$contact.email = $email;

#EACH CONTACT NUMBER SHOULD BE THIS LENGTH
$numberLength = 11;

#GET THE RANDOM FOLDER (MAY NOT BE INVOKED FROM HERE)
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
#GET THE Get-RandomName FILE
$randomPath = $dir + "\Get-RandomNumber.ps1";

#GENERATE A LANDLINE NUMBER
$landlines = $json.contact.landline.intro;
$landlineCount = $landlines.length;
$landlineIndex = Get-Random -Maximum ($landlineCount - 1);
$landlineIntro = $landlines[$landlineIndex];
$landline = . $randomPath -intro $landlineIntro -length $numberLength;
$contact.landline = $landline;

#GENERATE A MOBILE NUMBER
$mobiles = $json.contact.mobile.intro;
$mobilesCount = $mobiles.length;
$mobilesIndex = Get-Random -Maximum ($mobilesCount - 1);
$mobilesIntro = $mobiles[$mobilesIndex];
$mobile = . $randomPath -intro $mobilesIntro -length $numberLength;
$contact.mobile = $mobile;

#GENERATE A WORK NUMBER
$works = $json.contact.work.intro;
$worksCount = $works.length;
$worksIndex = Get-Random -Maximum ($worksCount - 1);
$worksIntro = $works[$worksIndex];
$work = . $randomPath -intro $worksIntro -length $numberLength;
$contact.work = $work;

#Write-Output $contact;
return $contact;