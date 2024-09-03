
<#
test


$sourceOrgAlias = 'DIProd'
$command = ".\scripts\pssCommon\fxVerifyLogin.ps1 " + $sourceOrgAlias + ' Source ' + $true
if ( (Invoke-Expression $command) -eq $false) {
  return 'Abort Script on bad login '
}
 

#>




Param(
    #  
    $OrgAlias  ='',
    $sourceTarget ='unknown',
    $debug = $false
)

if ($OrgAlias -ne '') {
    $SOA = sf force org display -u $OrgAlias --json
    if($Debug) {
        write-host  $SOA
        
    }
    $SOA = $SOA | ConvertFrom-JSON

    if ($SOA.status -ne 0) {
        write-host ($OrgAlias + " $sourceTarget :" + $SOA.message ) -ForegroundColor red
         
       # return $SOA 
    }
    else {
        write-host ($OrgAlias + " $sourceTarget :" + $SOA.result.connectedStatus ) -ForegroundColor green
        return $true
    }
    return $false
}