 
<#
 
 Used to configure your logins to sandboxs and prod 
 The alias are needed in the deploy of code and data such that no ambiguity as to org names. 
 Default vscodeOrg is not used
 see C:\Users\your.name\.sfdx\alias.json to clean up any duplicates or junk 
 the default should be your personal sandbox  --setdefaultusername
 #>
 Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass


    sf org login web -r "https:/test.salesforce.com" --alias MIDev

    sf org login web  -r "https:/login.salesforce.com" --alias MIDev 

    
    sf org login web  -r "https://menorahinternationalconsult-dev-ed.develop.my.salesforce.com" --alias MIDev 


    
    sf org login web  -r "https:/login.salesforce.com" --alias PCProd 
 

$Reauth = $true
if ($Reauth -eq $false) {

   # adjust as needed

    sf org login web -r "https:/test.salesforce.com" --alias DCNFull --set-default
    sf org login web -r "https:/test.salesforce.com" --alias DCNFullIn --set-default


    sf org login web -r "https:/test.salesforce.com" --alias DCNFullBk  
    sf org login web  -r "https:/login.salesforce.com" --alias DCNProd 
 

  
    sf org login web  -r "https:/login.salesforce.com" --alias DCNProdIn 
    sf org login web  -r "https:/login.salesforce.com" --alias DCNProdBk
 
    sf org login web  -r "https:/test.salesforce.com" --alias BVBDeploy  
    
 
###  Verify connections 
sf org display -o DCNFull
}
 
<#
 git config --global user.email bburen@datainnovations.com

 git config --global user.name "bburen"

 #>

 