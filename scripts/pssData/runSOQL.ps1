<# 
     
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#>

$targetOrgAlias = "DIProd"
$name = "Product"


$soqlFile = $name +".soql" 
$csvFile = $name +".csv"  



$soqlFilePath = "./scripts/soql/" 
$csvOutputPath = "./scripts/soqlout/" 
  

sfdx force:data:soql:query -f ($soqlFilePath+$soqlFile) -u $targetOrgAlias -r csv | Out-File  ($csvOutputPath + $csvFile )
 