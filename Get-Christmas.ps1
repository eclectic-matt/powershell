# IMPORT ADAPTIVE CARD CLASSES
. C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\AdaptiveCards\Classes\Imports.ps1

# MESSAGE
#	ADAPTIVE CARD
#		TEXTBLOCK - HEADER
#		TEXTBLOCK - INTRO (On the Xth day of Christmas my true love gave to me...)
#		Foreach gift
#			TEXTBLOCK - Gift Name
#			TEXTBLOCK - Gift Image
#		Next gift


#FIRST DAY OF CHRISTMAS (12th DEC GIVES 12 DAYS OF GIFTS BEFORE FRIDAY 23RD DEC - FINAL WORKING DAY)
$firstDayOfChristmas = "2022-12-11"; 	#MONDAY 12th (SUNDAY 11TH SO IT FITS!)
$finalDayOfChristmas = "2022-12-23"; 	#FRIDAY 23rd
$today = Get-Date -Format "yyyy-MM-dd";

#12th = Fri 23
#11th = Thu 22
#10th = Wed 21
#9th = Tue 20
#8th = Mon 19
#7th = Fri 16
#6th = Thu 15
#5th = Wed 14
#4th = Tue 13
#3rd = Mon 12
#2nd = Fri 9
#1st = Thu 8

#CREATE ARRAY OF GIFTS
$gifts = @();
#DAY 1
$day = @('a partridge in a pear tree');
$gifts = $gifts + $day;
#DAY 2
$day = @('two turtle doves');
$gifts = $gifts + $day;
#DAY 3
$day = @('three french hens');
$gifts = $gifts + $day;
#DAY 4
$day = @('four calling birds');
$gifts = $gifts + $day;
#DAY 5
$day = @('five gold rings');
$gifts = $gifts + $day;
#DAY 6
$day = @('six geese a-laying');
$gifts = $gifts + $day;
#DAY 7
$day = @('seven swans a-swimming');
$gifts = $gifts + $day;
#DAY 8
$day = @('eight maids a-milking');
$gifts = $gifts + $day;
#DAY 9
$day = @('nine ladies dancing');
$gifts = $gifts + $day;
#DAY 10
$day = @('ten lords a-leaping');
$gifts = $gifts + $day;
#DAY 11
$day = @('eleven pipers piping');
$gifts = $gifts + $day;
#DAY 12
$day = @('twelve drummers drumming');
$gifts = $gifts + $day;

#LIVE VERSION - GET THE CURRENT DAY
#$today = Get-Date -Format "yyyy-MM-dd";
#TESTING BY DATE
$today = Get-Date -Year 2022 -Month 12 -Day 23 -Format "yyyy-MM-dd";

#GET THE DAY OF CHRISTMAS (DIFF TO FINAL)
#$day = (New-TimeSpan -Start $firstDayOfChristmas -End $today).Days;

#OR FORCE THE DAY OF CHRISTMAS
#$day = 1;	#MON 12
#$day = 2;	#TUE 13th
#$day = 3;	#WED 14th
#$day = 4;	#THU 15th
#$day = 5;	#FRI 16th
#$day = 6;	#SAT 17th
#$day = 7;	#SUN 18th
#$day = 8;	#MON 19th
#$day = 9;	#TUE 20th
#$day = 10;	#WED 21st
#$day = 11;	#THU 22nd
$day = 12;	#FRI 23rd



Function Get-GiftForThisDay{
	param(
		[Parameter(Mandatory=$true)] [int]$day
	)
	return $gifts[$day - 1];
}

#HELPER FUNCTION TO GET THE ORDINAL (st, nd, rd, th) FOR A DATE
Function getDateOrdinal{
	param(
		[Parameter(Mandatory=$true)] [String]$date
	)

	#IS THE PARAM LENGTH < 10
	if($date.Length -lt 10){
		
		#SUPPLYING A DAY (e.g. 1, 2, 3)
		$day = $date;
	}else{

		#SUPPLYING A DATE (e.g. "2022-11-12")
		$day = Get-Date -Date $date -Format "d";
	}

    switch($day){
		1 {
			return "st"
		}
		2 {
			return "nd"
		}
		3 {
			return "rd"
		}
		4 {
			return "th"
		}
		5 {
			return "th"
		}
		6 {
			return "th"
		}
		7 {
			return "th"
		}
		8 {
			return "th"
		}
		9 {
			return "th"
		}
		10 {
			return "th"
		}
		11 {
			return "th"
		}
		12 {
			return "th"
		}
		13 {
			return "th"
		}
		14 {
			return "th"
		}
		15 {
			return "th"
		}
		16 {
			return "th"
		}
		17 {
			return "th"
		}
		18 {
			return "th"
		}
		19 {
			return "th"
		}
		20 {
			return "th"
		}
		21 {
			return "st"
		}
		22 {
			return "nd"
		}
		23 {
			return "nd"
		}
		24 {
			return "th"
		}
		25 {
			return "th"
		}
		26 {
			return "th"
		}
		27 {
			return "th"
		}
		28 {
			return "th"
		}
		29 {
			return "th"
		}
		30 {
			return "th"
		}
		31 {
			return "st"
		}
	}
}


function Scrape-ChristmasGiftImage{
	param(
		[Parameter(Mandatory=$true)] [String]$giftName
	)
	#GET GOOGLE IMAGES
	$content = Invoke-RestMethod "https://www.google.com/search?q=$giftName&sxsrf=ALiCzsZ3iOWI-1dHX8uZnJkdXDfHkRSHtw:1658304343535&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiMnc2KgYf5AhV5QUEAHUp8AAkQ_AUoAXoECAEQAw&cshid=1658304366384794&biw=1368&bih=769&dpr=2";
	#FIND THE FIRST <img>
	$content -match '<img class="yWs4tf".*src="(?<imgSrc>.*)"/>' > $silent;
	$giftImage = $Matches.imgSrc;
	return $giftImage;

	<#
	#GET GOOGLE IMAGES
	$content = Invoke-RestMethod "https://www.google.com/search?q=$currentGift&sxsrf=ALiCzsZ3iOWI-1dHX8uZnJkdXDfHkRSHtw:1658304343535&source=lnms&tbm=isch&sa=X&ved=2ahUKEwiMnc2KgYf5AhV5QUEAHUp8AAkQ_AUoAXoECAEQAw&cshid=1658304366384794&biw=1368&bih=769&dpr=2";
	#FIND THE FIRST <img>
	$content -match '<img class="yWs4tf".*src="(?<imgSrc>.*)"/>' > $silent;
	Write-Host $Matches.Count + " matches";
	#GENERATE A NEW IMAGE TAG
	$giftImage = $Matches.imgSrc;
	Write-Host $giftImage;

	#<img class="yWs4tf"(?> | alt="" )src="(?<src>.*)"\/\>
	#TRYING HERE TO GET MULTIPLE MATCHES (SELECT A RANDOM IMAGE EACH TIME)
	Write-Host "======= ALL MATCHES ========="
	$index = 1;
	$allmatches = ([regex]::matches($content, '<img class="yWs4tf".*src="(?<src>.*)"/>'));
	Write-Host $allmatches.Count;
	if ($allmatches.Count -gt 0) {

		#ITERATE THROUGH THE MATCHES
		foreach($match in $allmatches){

			Write-Host "`n======= MATCH #$index ========="
			Write-Host $match.groups["src"].value;
			$index = $index + 1;
		}
	} else {
		# Nah, no match
		Write-Host "No images available";
		exit 1;
	}
	#>
}

function Get-ChristmasHeader{

	$headerText = [TextBlock]::new();
	$headerText.setText('CHRISTMAS GIFTS');
	$headerText.setSize('extraLarge');
	$headerText.setWeight('bolder');
	return $headerText;
}

function Get-ChristmasIntro{

	param(
		[Parameter(Mandatory=$true)] [int]$day
	)

	#GET THE ORDINAL FOR THIS DAY
	$ordinal = getDateOrdinal($day);

	#PREPARE OUTPUT
	$output = "On the ";
	$output = -join($output, $day);
	$output = -join($output, $ordinal);
	#TEST - WORK ADDED HERE
	$output = -join($output, " WORKday of Christmas my colleague gave to me: ");

	$introText = [TextBlock]::new();
	$introText.setText($output);
	$introText.setSize('large');
	#$introText.setWeight('bolder');
	
	return $introText;
}

function Get-ChristmasList {
	param(
		[Parameter(Mandatory=$true)] [int]$day
	)

	$allDays = @();

	for($i = $day; $i -gt 0; $i--){
		
		$thisDay = @();
		$giftName = Get-GiftForThisDay $i;

		#GENERATE THE CARD USING FUNCTIONS 
		$nameText = [TextBlock]::new();
		$nameText.setText($giftName);
		$nameText.setSize('large');
		$nameText.setFontType('monospace');
		$nameText.setWeight('bolder');
		#$thisDay = $thisDay + $nameText.out();
		#$thisDay = $thisDay + $nameText.out();#.out();

		$imgUrl = Scrape-ChristmasGiftImage $giftName;
		$image = [Image]::new();
		$image.setUrl($imgUrl);
		$image.setSize('extralarge');

		#$thisDay = $thisDay + $image.out();
		#$thisDay = $thisDay + $image.out();#.out();

		$thisDay = @($nameText.out(), $image.out());

		#PREPARE AN ACTION (REQUIRED?)
		$action = [ActionOpenUrl]::new($imgUrl,"View your gift image");

		#STORE IN A CONTAINER
		$thisContainer = [Container]::new();
		$thisContainer.setItems($thisDay);
		$thisContainer.setSelectAction($action.out());

		$allDays = $allDays + $thisContainer.out();
	}

    #PREPARE AN ACTION (REQUIRED?)
	$action = [ActionOpenUrl]::new("https://en.wikipedia.org/wiki/The_Twelve_Days_of_Christmas_(song)","View on Wikipedia");
	
    $thisList = [Container]::new();
	$thisList.setItems($allDays);
    $thisList.setSelectAction($action.out());

	#return $thisList;
    return $allDays;
}


function Get-ChristmasMessage{
	param(
		[Parameter(Mandatory=$true)] [int]$day
	)

	#GET THE HEADER
	$header = Get-ChristmasHeader;

	#GET THE INTRO
	$intro = Get-ChristmasIntro $day;

    

	#GET THE LIST OF GIFTS
	$list = Get-ChristmasList $day;
	$giftColumn = [Column]::new();
	#$giftColumn.setItems($list.out());
    $giftColumn.setItems($list);
    
    #WRAP IN A COLUMN SET - REQUIRED!!!!
    $columnSet = [ColumnSet]::new();
    $columnSet.setColumns($giftColumn.out());

	#WRAP THIS INTO AN ARRAY
	#$content = @($header.out(), $intro.out(), $giftColumn.out());#, $list.object);
    $content = @($header.out(), $intro.out(), $columnSet.out());#, $list.object);

	#SET THIS AS THE ADAPTIVE CARD CONTENT
	$card = [AdaptiveCard]::new($content);

	#WRAP THE ADAPTIVE CARD IN A MESSAGE (.out NOT SUITABLE HERE?)
	[Message]$message = [Message]::new($card.object);

	#STRINGIFY THE FINAL MESSAGE - THIS *MUST* USE THE out() METHOD
	$output = $message.out();

	$output | Set-Content -Path "C:\Users\matthew.tiernan\Desktop\POWERSHELL\daily-hooks\lastCardOutput.json" -Encoding 'UTF8';

	Invoke-Expression -Command "C:\Users\matthew.tiernan\Desktop\POWERSHELL\utilities\Send-TeamsMessage.ps1 `$output` ""true""" > $silent;
    
    return $message;
}




#GET THE MESSAGE
$msg = Get-ChristmasMessage $day;
Write-Host $msg.out();
exit 1;

#====