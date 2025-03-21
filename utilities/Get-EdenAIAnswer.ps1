param($question, $text);
<#
    Get the answer to a question from Eden AI.
#>

#CLEAR SCREEN FOR TESTING
#Cls


##

###### TO DO!

##

#$text = 'In 1479 - Battle of Guinegate: French troops of King Louis XI were defeated by the Burgundians led by Archduke Maximilian of Habsburg.';
#$question = 'what is the most appropriate wikipedia link for the following historical event?';


#GET API KEY FROM SECRET STORE
$fileName = "C:\Users\matthew.tiernan\Desktop\POWERSHELL\api\apiKeys.json";
$file = Get-Content -Path $fileName -Raw;
$json = ConvertFrom-Json $file;
$edenApiKey = $json.keys.edenai;


$url = 'https://api.edenai.run/v2/text/question_answer';
#Write-Output $url;

#ADD API KEY TO HEADERS
$headers = @{
    'accept' = 'application/json'
	'authorization' = 'Bearer ' + $edenApiKey
	'content-type' = 'application/json'
};

$body = '{"response_as_dict":true,"attributes_as_list":false,"show_original_response":false,"temperature":0,"providers":"openai,tenstorrent","texts":["' + $text + '"],"question":"' + $question + '","examples_context":"In 2017, U.S. life expectancy was 78.6 years.","examples":[["What is human life expectancy in the United States?","78 years."]]}';

$response = Invoke-WebRequest -Uri 'https://api.edenai.run/v2/text/question_answer' -Method POST -Headers $headers -ContentType 'application/json' -Body $body;

$json = ConvertFrom-Json($response);
$wikiLink = $json.openai.answers[0];

return $wikiLink;