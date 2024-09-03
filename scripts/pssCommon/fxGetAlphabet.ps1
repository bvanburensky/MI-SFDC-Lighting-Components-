
<#
test

$command =".\scripts\pss\fxVerifyLogin.ps1 sfcpqdev1"
$result = Invoke-Expression $command
 write-host $result

#>


$alphabet = @()  
 
for ([byte]$c = [char]'A'; $c -le [char]'Z'; $c++)  
{  
    $alphabet += [char]$c  
}  
 
return $alphabet