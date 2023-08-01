param($intro, $length);
<#
.Description
	Generate a random vehicle data.
.Parameter $intro
    Any intro numbers (e.g. area code) to use.
.Parameter $length
    The resulting length of the number.




REQUIRED DETAILS:
* Item Type (59=car, 60=LCV, 64=motorcycle)     DONE
* Manufacturer                                  DONE
* Model                                         DONE
* Trim                                          DONE          
* Serial
* Screen
* Colour
* Engine
* Fuel
* Transmission
* Mileage
* PurchasePrice
* Registration
* RegistrationDate
* ManufactureDate
* PurchaseDate
* New
* PaintCode
#>


#IMPORTS
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\random\Get-RandomDate.ps1 > $silent;
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\random\Get-RandomNumber.ps1 > $silent;
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\random\Get-RandomString.ps1 > $silent;



<#
    DEFINE OPTIONS
#>

#DEFINE POSSIBLE ITEM TYPES
$itemTypes = @(
    59,  #CAR
    60,  #LCV
    64   #MOTORCYCLE
);

#DEFINE LIST OF POTENTIAL MANUFACTURERS AND MODELS
$makesAndModels = @{
    #'ac'= @()
    #'alpina'= @()
    #'alvis'= @()
    #'ariel'= @()
    #'ascari'= @()
    #'asia'= @()
    #'aston martin'= @() 
    #'auburn'= @()
    #'audi'= @('r8')
    #'austin'= @()
    #'bac'= @()
    'bmw'= @('alpina')
    #'beauford'= @()
    #'bentley'= @()
    #'bowler'= @()
    #'bristol'= @()
    #'bugatti'= @()
    #'buick'= @()
    #'cadillac'= @()
    #'caterham'= @()
    #'chesil'= @()
    #'coleman milne'= @() 
    #'dax'= @()
    #'datsun'= @()
    #'de tomaso'= @() 
    #'delorean'= @()
    #'eterniti'= @()
    #'excalibur'= @()
    #'fso'= @()
    #'farbio'= @()
    #'ferrari'= @()
    #'fisker'= @()
    'ford'= @('cosworth')
    #'gardener'= @()
    #'ginetta'= @()
    #'great wall'= @() 
    #'gumpert'= @()
    #'hmc'= @()
    #'hillman'= @()
    #'holden'= @()
    'honda'= @('nsx')
    #'hummer'= @()
    #'jensen'= @()
    #'ktm'= @()
    #'koenigsegg'= @()
    #'lti'= @()
    #'lada'= @()
    #'lamborghini'= @()
    #'lancia'= @()
    #'ligier'= @()
    #'lincoln'= @()
    #'lotus'= @()
    #'mahindra'= @()
    #'marcos'= @()
    #'maserati'= @()
    #'mclaren'= @()
    'mercedes-benz'= @('amg')
    #'mercury'= @()
    #'messerschmitt'= @()
    'mitsubishi'= @('3000gt', '3000gto', '3000fto', 'vr4', 'wrc', 'evo', 'srt')
    #'mitsuoka'= @()
    #'morgan'= @()
    #'morris'= @()
    #'mosler'= @()
    'nissan'= @('skyline', 'gtr')
    #'noble'= @()
    #'pgo'= @()
    #'pagani'= @()
    #'panther'= @()
    #'plymouth'= @()
    #'pontiac'= @()
    #'porsche'= @()
    #'radical'= @()
    #'reliant'= @()
    'renault'= @('gta', 'a610', '172', 'williams', 'v6')
    #'riley'= @()
    #'rolls royce'= @()			
    #'santana'= @()
    #'sebring'= @()
    #'singer'= @()
    'subaru'= @('impreza', 'wrx', 'wrc', 'p1', 'su', 'r85', 'mcrae')
    #'sunbeam'= @()
    #'tvr'= @()
    #'talbot'= @()
    #'tata'= @()
    #'tesla'= @()
    #'tiger'= @()
    'toyota'= @('supra')
    #'trabant'= @()
    #'triumph'= @()
    #'ultima'= @()
    'vauxhall'= @('calibra', 'turbo', 'vx220', 'minaro')
    #'westfield'= @()
    #'wolseley'= @()
    #'yugo'= @()
}

#DEFINE A LIST OF TRIMS (MODEL VARIANTS)
$trimTypes = @( 
    '',
    'GTi', 
    'GSi' 
);

#SCREEN (WINDSCREEN SIZE?)
$screens = @(32,42);

#COLOUR
$colours = @(
    "blue",
    "red",
    "green",
    "silver",
    "black",
    "white",
    "orange",
    "yellow",
    "purple",
    "grey",
    "pink"
);

#FUEL
$fuelTypes = @(
    'petrol',
    'diesel',
    'electric',
    'hybrid',
    'unknown'
);

#TRANSMISSION
$transmissionTypes = @(
    'automatic',
    'manual',
    'unknown'
);

#NEW (BOOL)
$newFlag = @(
    'true',
    'false'
);

<#
    GET A RANDOM OPTION
#>
$itemType = $itemTypes[(Get-Random -Maximum $itemTypes.Count)];
#Write-Output ("Item Type: " + $itemType.toString());

#$manufacturer = (Get-Random -InputObject (Get-Random -InputObject $makesAndModels.Keys -Count 1) -Count 1);
#Write-Output ("Manufacturer: " + $manufacturer);

$manOpts = $makesAndModels.Keys.split(" ");
$manCount = $manOpts.Count;
#$manufacturer = $manOpts[(Get-Random -Maximum $manCount -Count 1)];
$manufacturer = $manOpts[0];
#Write-Output ("Manufacturer: " + $manufacturer);

$modOpts = $makesAndModels.$manufacturer;
$modCount = $modOpts.Count;
#$model = $modOpts[(Get-Random -Maximum $modCount -Count 1)];
$model = $modOpts[0];
#Write-Output ("Model: " + $model);

#GET A RANDOM OPTION
$trim = $trimTypes[(Get-Random -Maximum $trimTypes.Count)];
$screen = $screens[(Get-Random -Maximum $screens.Count)];
$colour = $colours[(Get-Random -Maximum $colours.Count)];
$fuel = $fuelTypes[(Get-Random -Maximum $fuelTypes.Count)];
$transmission = $transmissionTypes[(Get-Random -Maximum $transmissionTypes.Count)];
$new = $newFlag[(Get-Random -Maximum $newFlag.count)];

#ENGINE
$engine = Get-RandomNumber("1", 4);
#Write-Output $engine;

#SERIAL (VIN)
$serial = Get-RandomString "ABCDEFGHJKLMNPRSTUVWXYZ0123456789" 17;

#MILEAGE
$mileage = Get-RandomNumber "" 5

#PURCHASE PRICE
$purchasePrice = Get-RandomNumber "" 5

#REGISTRATION
$regRegion = Get-RandomString "ABCDEFGHJKLMNPRSTUVWXYZ" 2;
$regYear = Get-RandomNumber "" 2
$regSuffix = Get-RandomString "ABCDEFGHJKLMNPRSTUVWXYZ" 3;
$registration = ($regRegion + $regYear + $regSuffix);
#Write-Output $registration;

#PURCHASE DATE
$purchasedDate = Get-RandomDate "2020-01-01" "2023-05-31"
#Write-Output $purchasedDate;

#REGISTERED DATE 
$registeredDate = Get-RandomDate "2020-01-01" "2023-05-31"
#Write-Output $registeredDate;

#MANUFACTURED DATE
$manufacturedDate = Get-RandomDate "2020-01-01" "2023-05-31"
#Write-Output $manufacturedDate;




$vehicleRecord = @{
    'itemType' = $itemType
    'manufacturer' = $manufacturer
    'model' = $model
    'trim' = $trim
    'screen' = $screen
    'colour' = $colour
    'fuel' = $fuel
    'transmission' = $transmission
    'new' = $new
    'engine' = $engine
    'serial' = $serial
    'mileage' = $mileage
    'purchasePrice' = $purchasePrice
    'registration' = $registration
    'purchasedDate' = $purchasedDate
    'registeredDate' = $registeredDate
    'manufacturedDate' = $manufacturedDate
};

Write-Output $vehicleRecord;
#return $vehicleRecord;
    