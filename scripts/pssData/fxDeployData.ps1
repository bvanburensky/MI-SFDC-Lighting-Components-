### function called by dataGetDeploy to deploy data from source directory to target org

<#



Update data from the data subdirectory to the target system

sfdx uses bulk data load so all errors can be researched using thoses docs

my common errors
    all csv columns need to be real api names.
    You cannot have a random column for helpful notes 
    external lookups apis must be formated as account__r.Unique_ID__c 
      where account__c is the lookup field and Unique_ID__c is a external id type unique
    to fill a value with data to blank/null use #N/A 

 
#>
 
Param(

  $targetOrgAlias = '' ,
  $sourceOrgAlias = "",
  $sObjectPath = "",
  $csvOutputPath = "",
  [AllowEmptyString()]
  $onlyProcessFile = "",
  [AllowEmptyString()]
  $onlyProcessSObject = "",
  [AllowEmptyString()]
  $excludeProcessFile = "",
  [AllowEmptyString()]
  $excludeProcessSObject = "",
  [AllowEmptyString()]
  $onlyProcessDirectory = "",
  [AllowEmptyString()]
  $excludeProcesssDirectory = "" ,
  [AllowEmptyString()]
  $IDFieldForUpsert = ""  ,
  [AllowEmptyString()]
  $IsInsert = $false ,
  [AllowEmptyString()]
  $IsUpdate = $false 
)
 
write-host starting deploy from $sourceOrgAlias to $targetOrgAlias  file: $onlyProcessFile sobj:$onlyProcessSObject
 

$wrkLogs = ".\scripts\wrk\csv\"


#for logging
if (!(Test-Path $wrkLogs)) {
  New-Item -Path $wrkLogs -ItemType Directory
}
# where csv files are located
if (!(Test-Path $csvOutputPath)) {
  New-Item -Path $csvOutputPath -ItemType Directory
}
$cntIgnored = 0 
$cntFound = 0 
$CPQFiles = Get-ChildItem -Path $sObjectPath  -Recurse -Include *.ps1
$sObjectHash = @{}
foreach ($sObj in $CPQFiles) {
 
  if ( 
    ($onlyProcessFile -ne "" -and ! $onlyProcessFile.contains($sObj.Name) ) -or
    ($excludeProcessFile -ne "" -and $excludeProcessFile.contains($sObj.Name) ) -or 
    ($onlyProcessDirectory -ne "" -and -not $onlyProcessDirectory.contains($sObj.Directory.Name) ) -or 
    ($excludeProcesssDirectory -ne "" -and $excludeProcesssDirectory.contains($sObj.Directory.Name) )  -or
    ($sObj.Name.StartsWith("xRep") )        

  ) {
    $cntIgnored += 1
    continue
  }
  $cntFound += 1 
  
  $command = $sObj 
  # $command
  #    return 
  write-host Processing File $sObj.name  -ForegroundColor DarkGreen
  $sObjectHash += Invoke-Expression $command
}

write-host Number of Files Ignored  $cntIgnored  -ForegroundColor DarkRed    
write-host Number of Files Found  $cntFound  -ForegroundColor DarkGreen 

#indicate a file exists 
$CSVFiles = Get-ChildItem -Path $csvOutputPath  -Recurse
foreach ($sObj in $CSVFiles) {
  $totalSize = ($sObj | Measure-Object -Sum Length).Sum  
 
  if($totalSize -lt 11) {
    Write-Host error  $sObj.Name file size $totalSize '<' 11
    continue
  }
 
  $sObjBase = $sObj.Name.Replace(".csv", "")
  $sObject = $sObjBase.split('.')[0]
 
  if (
     ($onlyProcessSObject -ne "" -and -not $onlyProcessSObject.contains($sObject)) -or
     ($excludeProcessSObject -ne "" -and $excludeProcessSObject.contains($sObject)) ) {
    #write-host Processing sObject $sObject excluded  -ForegroundColor DarkRed 
    continue
  }     
  if ($sObjectHash.ContainsKey($sObjBase)) {
    $sObjectHash[$sObjBase].sObject = $sObjBase.split('.')[0]
    if ($null -eq $sObjectHash[$sObjBase].externalId ) {
      $sObjectHash[$sObjBase].externalId = "Unique_ID__c"
    }
    if ($IDFieldForUpsert -gt "" ) {
      $sObjectHash[$sObjBase].externalId = $IDFieldForUpsert
    } 
  }
  else {
    if ($onlyProcessFile -eq "") {
      write-host csv file $sObj.name found in data/org/$sourceOrgAlias `nbut is not configured in /objects files. `nmay be junk. `nFile not Processed `n $sObjectPath  $sObj -ForegroundColor red
    }
  }
}
 
 
 
$OutputArray = @()
$OutputArrayJsonBatch = @()
$OutputArrayJsonRun = @()

$OutputArrayErrors = @()
$batchid 


$command = "sfdx force:data:bulk:upsert -o {alias} --sobject {xobj1} " + 
" --external-id {externalId} " + 
"  -w 0.5 -r " +
" --file " + $csvOutputPath + "{xobj}.csv"

if ($IsInsert) {

  $command = "sfdx force:data:bulk:insert -o {alias} --sobject {xobj1} " + 
  "  -w 1 -r " +
  " --file " + $csvOutputPath + "{xobj}.csv"


}
if ($IsUpdate) {

  $command = "sfdx force:data:bulk:update -o {alias} --sobject {xobj1} " + 
  "   -w 0.5 -r " +
  " --file " + $csvOutputPath + "{xobj}.csv"


}

$cnter = 0
while ($cnter -lt 10) {
  
  $cnter++
  write-host ---------- importOrder $cnter ---------  -ForegroundColor yellow
  foreach ($x in $sObjectHash.keys) {  
  
 
    if ($sObjectHash[$x].importOrder -ne $cnter -or
      $null -eq $sObjectHash[$x].sObject -or  
      $sObjectHash[$x].ignore -or 
      $sObjectHash[$x].ignoreDeploy 
    ) { 
      continue;
    }

    $xObj1 = $x.split('.')[0] 
    $runCommand = $command.Replace('{alias}', $TargetOrgAlias).Replace('{xobj}', $x).Replace('{xobj1}', $xObj1)
    $runCommand = $runCommand.Replace("{externalId}" , $sObjectHash[$x].externalId)
    Write-host `nupsert $x -ForegroundColor green
    Write-host "Running command  `n"   $runCommand  ' --json' -ForegroundColor yellow
  
    $vValues = Invoke-Expression ($runCommand + ' --json')
    $JJson = $vValues | ConvertFrom-JSON
    $batchid = $JJson.result.id
    if ( ($JJson.result.numberBatchesFailed -eq 0 -and $JJson.status -eq 0 -and $JJson.result.numberRecordsFailed -eq 0)) {
      $OutputArray += $x + ' Completed, Records Processed ' + $JJson.result.numberRecordsProcessed 
      $sObjectHash[$x].success = $x + ' Completed, Records Processed ' + $JJson.result.numberRecordsProcessed 
      Write-host upsert $x complete -ForegroundColor green

    }

    if ( ($JJson.result.numberBatchesFailed -gt 0 -or $JJson.status -ne 0 -or $JJson.result.numberRecordsFailed -ne 0)) {
      $OutputArrayJsonRun += $JJson
      $sObjectHash[$x].json = $JJson
      $sObjectHash[$x].jsonStatus = $JJson.status
      #Write-Output ("Error in file : " + $x + ' status' + $JJson.status)
      $bchCommand = "sfdx force:data:bulk:status -i " + $batchid + " -u " + $TargetOrgAlias + " --json"
      # Write-Output ("Running command For Errors batch : " + $bchCommand )
      $vValues = Invoke-Expression $bchCommand
      $sObjectHash[$x].OutputArrayJsonBatch = $vValues
      $OutputArrayJsonBatch += $vValues
      # Write-Output ("Running command For Errors : " + $runCommand  )
      $vValues = Invoke-Expression $runCommand
      $sObjectHash[$x].OutputArrayErrors = $vValues
      if ($null -ne $vValues) { 
        $sObjectHash[$x].OutputErrors = ("`n ---------------- Errors in csv File: " + $x +
          "  ------------- `n" + $vValues.replace("===", "`n") +
          "`n ------------End " + $x + "----------------- `n")  
      }
    }
  }
  
}  

$fdated = $wrkLogs + "csv" + (Get-Date -Format "yyyyMMdd-HHmmss") 

$fraw = $wrkLogs 


$success = @() 

foreach ( $x in  $sObjectHash.keys ) {
  $success += $sObjectHash[$x].success
  $OutputArrayErrors += $sObjectHash[$x].OutputErrors

}
Write-host $success -ForegroundColor green
Write-host See errors ($fraw + 'csv-Upserts.txt' )
#Write-host $OutputArrayErrors  -ForegroundColor red

$success | Set-Content  -Path ($fdated + '.csv-Upserts.txt' )
$success | Set-Content  -Path ($fraw + 'csv-Upserts.txt' )
$OutputArrayErrors | Set-Content  -Path ($fdated + '.error.txt' )
$OutputArrayErrors | Set-Content  -Path ($fraw + 'csv-error.txt' )

<#
Write-Output ("----------------  json run Error Results ----------------------")
foreach ( $x in $OutputArrayJsonRun ) {
  Write-Output($x)
}
Write-Output ("----------------  json Batch Error Results ----------------------")
foreach ( $x in $OutputArrayJsonBatch ) {
  Write-Output($x)
}
 
Write-Output ("----- Completed Upserts / No Errors  ------")
foreach ( $x in $OutputArray ) {
  Write-Output($x)
}
#>


 
#Write-Output("json" +$jobResult)
#sfdx force:data:bulk:status -u sfcpqdev2  --json -i (($JJson.result.id)+"/batch")
<#
if( ($JJson.result.numberRecordsFailed -gt 0)) {
    Write-Output("Number of records failed :" + $JJson.result.numberRecordsFailed)
    sfdx force:data:bulk:status -u sfcpqdev2  --json -i (($JJson.result.id)+"/batch")

}

sfdx force:data:bulk:status -u sfcpqdev2 -i 75003000002VoGFAA0  -b "75103000002ZHTiAAO"
#sfdx force:data:bulk:status -u sfcpqdev2  --json -i 75003000002VoALAA0
#>
#Write-Debug ( $jobResult.status)
#Write-Debug ( $jobResult[0].id)
#sfdx force:data:bulk:status -i 75003000002Vnk3 -u sfcpqdev2 --json


<#
{@{id=75003000002Vnq3AAC; operation=upsert; object=SBQQ__TemplateContent__c; createdById=0055a000007KLYUAA4; createdDate=2021-09-02T17:03:24.000Z; systemModstamp=2021-09-02T17:03:25.000Z; state=Closed; externalIdFieldName=Unique_ID__c; concurrencyMode=P... 

{
  "status": 0,
  "result": [
    {
      "id": "75003000002VnoAAAS",
      "operation": "upsert",
      "object": "SBQQ__TemplateContent__c",
      "createdById": "0055a000007KLYUAA4",
      "createdDate": "2021-09-02T16:44:08.000Z",
      "systemModstamp": "2021-09-02T16:44:09.000Z",
      "state": "Closed",
      "externalIdFieldName": "Unique_ID__c",
      "concurrencyMode": "Parallel",
      "contentType": "CSV",
      "numberBatchesQueued": "0",
      "numberBatchesInProgress": "0",
      "numberBatchesCompleted": "1",
      "numberBatchesFailed": "0",
      "numberBatchesTotal": "1",
      "numberRecordsProcessed": "1",
      "numberRetries": "0",
      "apiVersion": "53.0",
      "numberRecordsFailed": "1",
      "totalProcessingTime": "204",
      "apiActiveProcessingTime": "64",
      "apexProcessingTime": "49"
    }
  ]
}

#>