
# test Powershell stuff

# sfdx force:source:deploy:report -u sfcpqdev2 -i 0Af0300000IAGKOCA5
 

 
 Get-Date -Format "yyyyMMdd-HHmmss"


 $alphabet = @()  
 
for ([byte]$c = [char]'A'; $c -le [char]'Z'; $c++)  
{  
    $alphabet += [char]$c  
}  
 
[String]::Join(", ", $alphabet) 