# Log File Checker
# Written in Powershell 2.0
# Date: 23 Dec'16


# For Execution in cmd (execution policy is restricted by default): powershell -ExecutionPolicy ByPass -File ScriptName

Write-Host "`nLog Checker v1.0`n"

# First enter the path
$FullPath = Read-Host "Enter the absolute path"

# Enter the log file extension, one at a time
$DesiredFilter = Read-Host "Enter the filter (Format *.log, *.txt)"

# Enter desired text to fine
$TextToFind = Read-Host "Enter text"

# Display Path, Extension, Text
Write-Host "This is your path:" $FullPath -foregroundcolor "magenta"
Write-Host "This is your extension:" $DesiredFilter -foregroundcolor "magenta"
Write-Host "This is your search:" $TextToFind -foregroundcolor "magenta"

# Actual work begin after getting the input

# To measure the script runtime
$StartTime = Get-Date 

# No of folder including empty ones (Without parent folder)
$Folder = ((Get-ChildItem -path $FullPath  -recurse | Where-Object {$_.PSIsContainer}) | Measure-Object).Count

# Add one to include the given path (parent folder)
$AllFolder = $Folder + 1
Write-Host "No of folders in given path (including Parent Folder):" $AllFolder


#Log file number; Filter by extension
$Log = ((Get-ChildItem -path $FullPath -recurse -filter $DesiredFilter) | Measure-Object).Count
Write-Host "No of log file:" $Log
"`n"
# Now read the content of the log

# Code for match
$Search_Found = Get-ChildItem -Path $FullPath -Recurse -Filter $DesiredFilter | foreach-object{if (select-string -inputobject $_ -Pattern $TextToFind -AllMatches){$_}}
Write-Host "Match found:" $Search_Found.count -foregroundcolor "green"
# Save the result in csv in script working directory
$Search_Found | Select-Object Directory, Name | Export-Csv "$pwd\match.csv"
Write-Host "For more details see $pwd\match.csv"


# Code for not match
$Search_Not_Found = Get-ChildItem -Path $FullPath -Recurse -Filter $DesiredFilter | foreach-object{if ( -not (select-string -inputobject $_ -Pattern $TextToFind -AllMatches)){$_}}
Write-Host "Match ot found:" $Search_Not_Found.count -foregroundcolor "red"
# Save the result in csv in script working directory
$Search_Not_Found | Select-Object Directory, Name | Export-Csv "$pwd\not_match.csv"
Write-Host "For more details see $pwd\not_match.csv"


$EndTime = Get-Date
"`n"
Write-Host "Script runtime $(($EndTime-$StartTime).totalseconds) seconds"
