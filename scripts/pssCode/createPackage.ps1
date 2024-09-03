
<# rr
  Build a Package.xml like the wind!!! 
   
  To run in terminal 
  Terminal->Run Active File 
  
this may be required. run in terminal 
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser  

#>       
 
$DebugPreference = "Continue"
Set-Variable -Name "packageName" -Value (git branch  --show-current)
Write-Output ("Package Name:" + $packageName)
$PSSpath = ".\scripts\pssCode\"
$WrkpathFile = ".\scripts\wrk\Lc.txt"
if(!(Test-Path ".\scripts\wrk")) {
  New-Item -Path ".\scripts\wrk" -ItemType Directory
} 

$array = @()     
 
$array += " -fileType permissionset -appFolder permissionsets -metaName PermissionSet"
$array += " -fileType flow -appFolder flows -metaName Flow"
$array += " -fileType layout -appFolder layouts -metaName Layout"
$array += " -fileType flexipage -appFolder flexipages -metaName FlexiPage"
# this the custom metatadata instance with data - may not want to deploy unless new
#$array +=  " -fileType md -appFolder customMetadata  -metaName CustomMetadata"
$array += " -fileType aura -appFolder aura -metaName AuraDefinitionBundle "
$array += " -fileType cls -appFolder classes -metaName ApexClass " 
$array += " -fileType trigger -appFolder triggers -metaName ApexTrigger " 
$array += " -fileType workflowRule -appFolder workflowRules  -metaName WorkflowRule "
#$array += " -fileType reportType -appFolder reportTypes  -metaName ReportType "
$array += " -fileType quickAction -appFolder quickActions  -metaName QuickAction "
$array += " -fileType customPermission -appFolder customPermissions  -metaName CustomPermission "

$array += " -dirScan false -fileType fieldSet -appFolder objects -appSubFolder fieldSets -metaName FieldSet "
##$array += " -dirScan false -fileType listView -appFolder objects -appSubFolder listViews -metaName ListView "
$array += " -dirScan false -fileType validationRule -appFolder objects -appSubFolder validationRules -metaName ValidationRule "
$array += " -dirScan false -fileType compactLayout -appFolder objects -appSubFolder compactLayouts -metaName CompactLayout "
# $array += " -dirScan false -fileType recordType -appFolder objects -appSubFolder recordTypes -metaName RecordType "
 
$array += " -dirScan false -fileType field -appFolder objects -appSubFolder fields -metaName CustomField "

 
 
$packFile = ""
$lines = 0
$command = ($PSSpath) + "\createPackageTypes.ps1" 

foreach ( $x in $array ) {
  $runCommand = ($command + $x)
  Write-Output ("Running command: " + $runCommand)
  $vValues = Invoke-Expression $runCommand
  $packFile = $packFile + $vValues
  $vValues > $WrkpathFile
  $mLines =Get-Content -Path $WrkpathFile | Where-Object{$_ -ne ""} | Measure-Object -Line -Property length
 
   if ($mlines.Lines -gt 3) {
    $x =   $mlines.Lines -3
    $lines += $x
    Write-Debug ("Types.members #:" + $x  + " of  " + $lines) 
    }
  }
#Write-Output ("Data " +   $packFile)
 
Set-Variable -Name "packHeader" -Value (Get-Content -Path "./scripts/pssCommon/packagexml-Header.txt" -Raw)
Set-Variable -Name "packFooter" -Value (Get-Content -Path "./scripts/pssCommon/packagexml-Footer.txt" -Raw)
 
$packHeader = $packHeader.replace("REPLACENAME", $packageName )
$packHeader = $packHeader.replace("TOTALNUMBERLINES", $lines )
 

$packFile = $packHeader + $packFile + $packFooter 
$packFile | Set-Content -Path "scripts/wrk/packageCreated.xml"

