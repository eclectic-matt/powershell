<#
.Description
	Generate a random address string.
#>

#Clear-Host;

#IMPORT RANDOM FUNCTIONS
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\random\Get-RandomString.ps1 > $silent;
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\random\Get-RandomNumber.ps1 > $silent;

function Get-RandomLocation(){
    #GET CULTURE FOR TITLE CASE
    $textInfo = (Get-Culture).TextInfo

    #INIT MESSAGE
    $address = @{
        houseNum=''; 
        streetName=''; 
        streetType='';
        townName='';
        countyName='';
        postcode='';
        string=''
    }

    #LOAD JSON
    $fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\random\random.json";
    $file = Get-Content -Path $fileName -Raw;
    $json = ConvertFrom-Json $file;

    #GENERATE HOUSE NUMBER
    $maximumHouseNum = 300; #HOUSE NUMBERS USUALLY < 300
    $houseNum = (Get-Random -Maximum $maximumHouseNum).ToString();

    #GET A RANDOM STREET NAME
    $streetNames = $json.location.streetNames;
    $streetNamesLen = $streetNames.length;
    $streetNamesIdx = Get-Random -Maximum ($streetNamesLen - 1);
    $streetName = $streetNames[$streetNamesIdx];

    #GET A RANDOM STREET TYPE
    $streetTypes = $json.location.streetTypes;
    $streetTypesLen = $streetTypes.length;
    $streetTypesIdx = Get-Random -Maximum ($streetTypesLen - 1);
    $streetType = $streetTypes[$streetTypesIdx];

    #GET A RANDOM TOWN NAME
    $townNames = $json.location.townNames;
    $townNamesLen = $townNames.length;
    $townNamesIdx = Get-Random -Maximum ($townNamesLen - 1);
    $townName = $townNames[$townNamesIdx];

    #GET A RANDOM COUNTY
    $counties = $json.location.counties;
    $countiesLen = $counties.length;
    $countiesIdx = Get-Random -Maximum ($countiesLen - 1);
    $countyName = $textInfo.ToTitleCase($counties[$countiesIdx]);

    #POSTCODE
    $postcodeRegion = Get-RandomString -chars "ABCDEFGHJKLMNPRSTUVWXYZ" -length 1;
    $postcodePrefixNumber = Get-RandomNumber -intro "" -length 2
    $postcodeSuffixNumber = Get-RandomNumber -intro "" -length 1
    $postcodeSuffixChars = Get-RandomString -chars "ABCDEFGHJKLMNPRSTUVWXYZ" -length 2;
    $postcode = ($postcodeRegion + $postcodePrefixNumber + " " + $postcodeSuffixNumber + $postcodeSuffixChars);

    #STORE ADDRESS STRING
    $addressString = ($houseNum + " " + $streetName + " " + $streetType + ", " + $townName + ", " + $countyName + ", " + $postcode);

    #STORE IN OBJECT
    $address.houseNum = $houseNum;
    $address.streetName = $streetName;
    $address.streetType = $streetType;
    $address.townName = $townName;
    $address.countyName = $countyName;
    $address.postcode = $postcode;
    $address.string = $addressString;

    #Write-Output $name;
    return $address;
}