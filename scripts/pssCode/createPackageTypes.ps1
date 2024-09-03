<#

Called by createPackage.PS1 

#>
 
 
Param(
  # Scan appFolder directory or scan by file type as needed by objects   
  $dirScan = "true",
  # the file extension type as in field or fieldset in  Mr_Field__c.field-meta.xml TheSet.fieldSet-meta.xml
  # not used in object scan
  $fileType = "field",
  #FLoder off /force-app/main/default/ that will bs scanned and file path removed
  $appFolder = "objects",
  # subfolder - used in object substructure 
  $appSubFolder = "fields",
  # type name in package xml
  $metaName = "CustomField"
 
)

$DebugPreference = "Continue"
# scrach path 
$wrkScrachPath = "scripts/wrk/"
$tempFile = ($wrkScrachPath) + "temp.txt"

if ($dirScan -eq "true") {
  $fileSearch = "**/" + $appFolder + "/*"
}
if ($dirScan -eq "false") {
  $filetype = ($fileType + "-meta.xml")
  $fileType = ("." + $fileType )
  $fileSearch = "*" + ($fileType)
}



$appFolderPath = "/" + $appFolder + "/"
$appSubFolder = "/" + $appSubFolder + "/"
$filePathFull = "force-app/main/default" + $appFolderPath + "" 

$membersPre = "    <members> "
$membersSufx = " </members>`n"

$metaName = "    <name>" + $metaName + "</name>"

git ls-files $fileSearch --others --exclude-standard > $tempFile
Set-Variable -Name 'New' -Value  (Get-Content -Path $tempFile -Raw )
git ls-files $fileSearch --modified   > $tempFile
Set-Variable -Name 'mod' -Value  (Get-Content -Path $tempFile -Raw )
Set-Variable -Name "all" -Value  ($mod + $new )
if ($null -eq $all ) {
  $DebugPreference = "Continue"
  Write-Debug ( " No changes found for " + $metaName + " in path:" + $filePathFull + " Filetypes:" + $fileSearch) 
  Write-Output ""
  return ""
}

#Sort the lines
$all > $tempFile
$all =  Get-Content -Path $tempFile | Where-Object{$_ -ne ""} | Sort-Object | Get-Unique  

if ($dirScan -eq "true") {
  $all = $all.replace($filePathFull, $membersPre) 
}
else {
  $all = $all.replace($filePathFull, $membersPre).replace($fileType, $membersSufx).replace($appSubFolder, ".")
}
 
 
#$all > $tempFile
#$all =  Get-Content -Path $tempFile -Raw | Sort-Object | Get-Unique  

$parseWrk = "" 
#if ($appFolder -eq "aura") {
if ($dirScan -eq "true") {
  ForEach ($xx in $($all -split "`n") ) {
    # Write-Debug ( "line :" + $xx  )
    if ($xx.trim.length -ge 1) {

      $lastExtendion = $xx.split(".").length - 1 
      Write-Debug ( $xx + " " + $lastExtendion    )
      $xx = $xx.replace("."+$xx.split(".")[$lastExtendion],"") #  .xml
      $xx = $xx.replace("."+$xx.split(".")[$lastExtendion-1],"") # .XXXXX-meta
      #$parseWrk = $parseWrk + $xx.split(".")[0].split("/")[0] + " </members>`n"  
      $parseWrk = $parseWrk + $xx.split("/")[0] + " </members>`n"  
      #$paresWrk = $paresWrk + $xx.split("/")[0] + " </members>`n"
    }
  } 
  $all = $parseWrk
  $all = $all | Sort-Object |  Get-Unique  
  #Write-Debug ( $parseWrk  )
}


$all = "`n  <types>`n" + $all + $metaName + "`n  </types>"
return  $all
Write-Output $all

 

