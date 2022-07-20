#SET TO LOCAL SVN PATH
$svnLocalPath = "C:\path\to\your\SVN\repo";

#ITERATE THROUGH SUB-FOLDERS
foreach($line in Get-ChildItem -Path $svnLocalPath){
	
    #OUTPUT (JUST TO YOU KNOW IT'S WORKING!)
	Write-Output "--------------------------"
	Write-Output "Updating $line"
	Write-Output "--------------------------"
    #EXECUTE COMMAND-PROMPT "svn update" ON THIS SUB-FOLDER
	cmd.exe /c "svn update $svnLocalPath$line"
}

