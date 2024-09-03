
<# 

function used to delete 
generate your file using dataGetDeploy
single column with an id field
pass name of file 
becarefull !! backup your data
 #>
 
$targetOrgAlias = "dev"
$csvFile = "Product_Booking_Treatment__c.del" 
$csvOutputPath = "scripts/pssData/data/org/" + $targetOrgAlias + "/"
$wrkLogs = ".\scripts\wrk\csv\" 
 
# --- Begin Code run
 

$command = "sfdx force:data:bulk:delete -u {alias} --sobjecttype {xobj1} " +
" --csvfile " + $csvOutputPath + "{xobj}.csv"
 
$xObj1 = $csvFile.split('.')[0] 
$runCommand = $command.Replace('{alias}', $TargetOrgAlias).Replace('{xobj}', $csvFile).Replace('{xobj1}', $xObj1)
 
 
$OutputSuccess = @()
$OutputErrors = @()
$OutputArrayJsonBatch = @()
$OutputArrayJsonRun = @()


Write-host `n delete!! $csvFile -ForegroundColor green
Write-Output ("Running command  `n" + $runCommand + ' --json')
  
$vValues = Invoke-Expression ($runCommand + ' --json')
$JJson = $vValues | ConvertFrom-JSON
$batchid = $JJson.result.id
$OutputArrayJsonRun += $JJson.result
if ( ( #$JJson.result.numberBatchesFailed -eq 0 -and 
        $JJson.status -eq 0 -and
        $JJson.result.numberRecordsFailed -eq 0)) {
    $OutputSuccess += $xObj1 + ' Completed, Records Processed ' + $JJson.result.numberRecordsProcessed 
     
}

if ( ($JJson.result.numberBatchesFailed -gt 0 -or 
        $JJson.status -ne 0 -or 
        $JJson.result.numberRecordsFailed -ne 0)) {
    
    #$sObjectHash[$x].json = $JJson
    #$sObjectHash[$x].jsonStatus = $JJson.status
    Write-Output ("Error in file : " + $xObj1 + ' status:' + $JJson.status)
    $bchCommand = "sfdx force:data:bulk:status -i " + $batchid + " -u " + $targetOrgAlias + " --json"
    # Write-Output ("Running command For Errors batch : " + $bchCommand )
    $vValues = Invoke-Expression $bchCommand
    #$sObjectHash[$x].OutputArrayJsonBatch = $vValues
    $OutputArrayJsonBatch += $vValues
    # Write-Output ("Running command For Errors : " + $runCommand  )
    $vValues = Invoke-Expression $runCommand
    #$sObjectHash[$x].OutputArrayErrors = $vValues
    if ($null -ne $vValues) { 
        $OutputErrors += ("`n ---------------- Errors in csv File: " + $csvFile +
            "  ------------- `n" + $vValues.replace("===", "`n") +
            "`n ------------End " + $csvFile + "----------------- `n")  
    }
}
$fdated = $wrkLogs + "csv" + (Get-Date -Format "yyyyMMdd-HHmmss") 
$fraw = $wrkLogs 


 
Write-host $OutputSuccess -ForegroundColor green
Write-host See errors ($fraw + 'csv-Delete.txt' ) -ForegroundColor red
#Write-host $OutputArrayErrors  -ForegroundColor red

$OutputSuccess | Set-Content  -Path ($fdated + '.csv-Delete.txt' )
$OutputSuccess | Set-Content  -Path ($fraw + 'csv-Delete.txt' )
$OutputErrors | Set-Content  -Path ($fdated + '.csv-error.txt' )
$OutputErrors | Set-Content  -Path ($fraw + 'csv-error.txt' )
$OutputArrayJsonRun | Set-Content  -Path ($fraw + 'csv-Delete.json' ) 
 
