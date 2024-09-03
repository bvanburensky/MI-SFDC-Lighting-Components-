
# function used to retrieve data 

Param(

    $sourceOrgAlias = "",
    [AllowEmptyString()]    
    $targetOrgAlias = "",
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
    $excludeProcesssDirectory = "", 
    [AllowEmptyString()]
    $ReplaceTextFrom = "",
    $ReplaceTextTo = "" 
 
    
    
)
 

if ($sObjectPath -eq "") {
    Write-Host No Path 
    return
}
 
#for output result
if (!(Test-Path $csvOutputPath)) {
    New-Item -Path $csvOutputPath -ItemType Directory  
}
# --- Begin Code run
 

$CPQFiles = Get-ChildItem -Path ($sObjectPath) -Recurse -Include  *.ps1
$sObjectHash = @{}
 
foreach ($sObj in $CPQFiles) {
    #$onlyProcessDirectory
    #$sObj 
    #$sObj.Name
    #$sObj.Directory.Name
    if ( 
        ($onlyProcessFile -ne "" -and -not $onlyProcessFile.contains($sObj.Name) ) -or
        ($excludeProcessFile -ne "" -and $excludeProcessFile.contains($sObj.Name) ) -or 
        ($onlyProcessDirectory -ne "" -and -not $onlyProcessDirectory.contains($sObj.Directory.Name) ) -or 
        ($excludeProcesssDirectory -ne "" -and $excludeProcesssDirectory.contains($sObj.Directory.Name) )   -or
        ($sObj.Name.StartsWith("xRep") )        
    ) {
     #   write-host File  $sObj.Directory.Name"/"$sObj.name excluded  -ForegroundColor DarkRed    
        continue
    }    
    #  $sObj | Get-Member 
    $command = $sObj 
    # $command
    #    return 
    write-host Processing File $sObj.name   -ForegroundColor DarkGreen
    $sObjectHash += Invoke-Expression $command
}
 
$outputArray = @()
$outputJson = @()
$wrk = "scripts/wrk/$sourceOrgAlias.txt" 
$wrkCSV = "scripts/wrk/csv/"

$queryBase = " select {fields} from {sObject} {where} {orderBy}"
$cnter = 0

while ($cnter -lt 10) {

    $cnter++
    write-host ---------- inputOrder $cnter ---------  -ForegroundColor green

    foreach ($x in $sObjectHash.Keys ) {

        $sObjBase = $x.ToString().Replace(".csv", "")
        $sObject = $sObjBase.split('.')[0]
         
        if ( ($onlyProcessSObject -ne "" -and ! $onlyProcessSObject.contains($sObject)) -or 
           ($excludeProcessSObject -ne "" -and $excludeProcessSObject.contains($sObject)) -or
            $sObjectHash[$x].ignore -or 
            $sObjectHash[$x].ignoreGet  
    
           
        ) { continue }      
       
        if ($sObjectHash[$x].importOrder -eq $cnter) {
 
            # write-host $fields 
 
          #  $csvs = sfdx force:data:soql:query -u $sourceOrgAlias -q $query -r csv  
            $outFile = $csvOutputPath + $x + ".csv"
            write-host "File " $outFile  -ForegroundColor green
         #   $recs = $jsonObj.result.totalSize
            
            #    $outputArray += $x + " Records:"  + $recs
            #     write-host "Writing $recs records to $outFile " -ForegroundColor yellow

            #         $filecontent -replace 'Refer the link https://shellgeek.com/tag/active-directory-2/','Refer the link Https://ShellGeek.com'        
          <#
            $null = 
             New-Item -Force $StrExpFile -Value (
              (Get-Content $StrExpFile).Replace($TargetWord, $ReplaceWord) | Out-String
            )
#>
            Start-Sleep -Milliseconds 100
            $csvs  = Get-Content  -Path $outFile  
            $csvs -replace $ReplaceTextFrom, $ReplaceTextTo   |  Set-Content -Path $outFile  -encoding utf8 
           # $csvs |  Set-Content  -Path $outFile -encoding utf8 
           # $csvs
            write-host "Replace Completed " $x  -ForegroundColor green

        }
    
 
    }
}

 
 
