<# 

this may be required. run in terminal 
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser  
#>
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

## ------------------------- Input parameters -------------------------
## --------------------------------------------------------------------------
# retieve to pull from sandbox and deploy to your or another sandbox or production
# source connection 
# NOTE: This alias is also used as the directory for data retrieve and deploy 
 
$sourceOrgAlias = 'sfcpqdev' 
$sourceOrgAlias = 'fullqa' 
$sourceOrgAlias = 'production'   
$sourceOrgAlias = 'DIProd1' 
$sourceOrgAlias = 'DIUAT0TF' 
$sourceOrgAlias = 'DIQA' 
$sourceOrgAlias = 'DCNFull' 
$sourceOrgAlias = 'DCNFullIn' 
$sourceOrgAlias = 'DCNProdIn' 

#$sourceOrgAlias = 'DInessdevnew' 
# target connection to your dev or prodction 
 
 
$targetOrgAlias = 'DIProd' 
$targetOrgAlias = 'DIUAT' 
$targetOrgAlias = 'DIDev'  
$targetOrgAlias = 'DCNFull'  
$targetOrgAlias = 'DCNProd' 

 
 
#######  true|False  # perform the retrieve from the source org or use the artifacts that exist   

$retrieve = $true
#######  true|False deploy or verify the artifacts to the target org.  
#        if retrieve and deploy are false then nothing is going to happen  
$deploy = $false
# to delete records spcified in a csvfile
 
# after deploying, reterieve the objects and take a look 
$reQuerytargetOrgOnDeploy = $true
# process or not a specific file or sObjectcls
 
$onlyProcessFile = "sObjs5Rules.ps1"
$onlyProcessSObject = ""
$onlyProcessDirectory = "getCPQ"

## Inputoutput subdir contain your deployment
$csvOutOverride = 'getCPQ' 


### Exclude yourself or  endless loop
$excludeProcessFile = "dataGetDeployX.ps1,dataGetDeploy.ps1," 
$excludeProcessFile += "asda.ps1" 
$excludeProcessSObject = ""
$excludeProcesssDirectory = ""

# for debug. display the reterive query

$retrieveFieldOverride = "'id,unique_id__c'"
$retrieveFieldOverride = "'id,name'"
$retrieveFieldOverride = "'id,unique_id__c'"
$retrieveFieldOverride = ""
$IDFieldForUpsert = "unique_id__c"
#IDFieldForUpsert = "'id'"

# for debug. display the reterive query
$showQuery = $true
#This only applies to reterive 
$whereOverride ="" ## " 'where Unique_ID__c in (''EX-020120033'')' "

#Add to the existing Query 'and field = ''asd '' ' if false then replaces any Where clause
$whereOverrideAdd = $true
## alpha loop logic.  set onlyProcessSObject to an sobject
# loop through a-z and query
$AlphaBetLoop = $false
## 
$BuildTicketPath = $true
## $AlphaBetLoopWhere = " ' where name like ''{ABIndex}%'' '"
# Codex
$AlphaBetLoopWhere = ""; # ' and Jurisdiction_Code__c like ''{ABIndex}%'' '"

## ------------------------- End Input parameters -------------------------

Invoke-Expression "Clear-Host"

## Test Logins
if ($retrieve) {
  $command = ".\scripts\pssCommon\fxVerifyLogin.ps1 " + $sourceOrgAlias + ' Source'
  if ( (Invoke-Expression $command) -eq $false) {
    return 'Abort Script on bad login '
  }
}
if ($deploy) {
  $command = ".\scripts\pssCommon\fxVerifyLogin.ps1 " + $targetOrgAlias + ' Target'
  if ( (Invoke-Expression $command) -eq $false) {
    return 'Abort Script on bad login '
  }
}


#location pf the scripting files for each object
$scriptPath =  "./scripts/pssData/"
$sObjectPath = "./scripts/pssData/sObjects/"


 
$commandParm += " -sObjectPath $sObjectPath  -whereOverrideAdd $whereOverrideAdd  "
if ($onlyProcessFile -gt "" ) {
  $commandParm += " -onlyProcessFile $onlyProcessFile "
}
if ($onlyProcessSObject -gt "" ) {
  $commandParm += "-onlyProcessSObject $onlyProcessSObject "
}
if ($excludeProcessFile -gt "" ) {
  $commandParm += " -excludeProcessFile $excludeProcessFile "
}
if ($excludeProcessSObject -gt "" ) {
  $commandParm += "-excludeProcessSObject $excludeProcessSObject "
}
if ($onlyProcessDirectory -gt "" ) {
  $commandParm += "-onlyProcessDirectory $onlyProcessDirectory "
}

if ($excludeProcesssDirectory -gt "" ) {
  $commandParm += "-excludeProcesssDirectory $excludeProcesssDirectory "
}
if ($retrieveFieldOverride -gt "" ) {
  $commandParm += "-retrieveFieldOverride $retrieveFieldOverride "
}
if ($IDFieldForUpsert -gt "" ) {
  $commandParm += "-IDFieldForUpsert $IDFieldForUpsert "
}
 


$AlphaBetU = @()
if ( !$AlphaBetLoop) {
  $AlphaBetU += "All"
  if ($whereOverride -gt "" ) {
    $commandParm += " -whereOverride $whereOverride "
  }
}

if ($AlphaBetLoop) {
  $command = ".\scripts\pssCommon\fxGetAlphabet.ps1 "  
  ## returns array of a-z
  $AlphaBetU = Invoke-Expression $command
}
#for output result
if (!(Test-Path ".\scripts\wrk\csv")) {
  New-Item -Path ".\scripts\wrk\csv" -ItemType Directory
}

$csvOutputPath = "./scripts/pssData/data/org/" + $sourceOrgAlias + "/"
if($csvOutOverride -gt "") {
  $csvOutputPath = "./scripts/pssData/data/org/"+$csvOutOverride +"/" + $sourceOrgAlias + "/"
}




$cmdAlpha =""
Write-Host $AlphaBetU
foreach ($letter in $AlphaBetU) {
  if ($letter -ne "All" ) {
    
    $NameLike = $AlphaBetLoopWhere.replace("{ABIndex}",$letter)
    $cmdAlpha = " -whereOverride $NameLike"

  } 
  if ($retrieve) {
    write-host Data Retrieve Starting  -ForegroundColor green
    $command = $scriptPath + "fxGetData.ps1 -sourceOrgAlias $sourceOrgAlias -csvOutputPath $csvOutputPath $commandParm $cmdAlpha  {-showQuery:$showQuery} " 
    write-host running $command  -ForegroundColor yellow
    Invoke-Expression $command
    write-host Retrieve Complete -ForegroundColor green
  }
  
  if ($deploy) {
    write-host Data Deploy Starting  -ForegroundColor green 
    $command = ($scriptPath) + "fxDeployData.ps1 -sourceOrgAlias $sourceOrgAlias -targetOrgAlias $targetOrgAlias -csvOutputPath $csvOutputPath  $commandParm "
    write-host running $command  -ForegroundColor yellow
    Invoke-Expression $command
    write-host Deploy Complete  $sObj -ForegroundColor green
  }
  break
}
 
# repull from target
$csvOutputPath = "scripts/pssData/data/org/" + $targetOrgAlias + "/"
if($csvOutOverride -gt "") {
  $csvOutputPath = "scripts/pssData/data/org/"+$csvOutOverride +"/" + $targetOrgAlias + "/"
}
if ($deploy -and $reQuerytargetOrgOnDeploy) {
  write-host Data Retrieve Starting  -ForegroundColor green
  $command = $scriptPath + "fxGetData.ps1 -sourceOrgAlias $targetOrgAlias -csvOutputPath $csvOutputPath  $commandParm "
  write-host running $command  -ForegroundColor yellow
  Invoke-Expression $command
  write-host Retrieve Complete -ForegroundColor green
}