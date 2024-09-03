 
<#
 
 Used to configure your logins to sandboxs and prod 
 The alias are needed in the deploy of code and data such that no ambiguity as to org names. 
 Default vscodeOrg is not used
 see C:\Users\your.name\.sfdx\alias.json to clean up any duplicates or junk 
 the default should be your personal sandbox  --setdefaultusername
 #>
 Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
 

  $sqol = ''
  $path =  "./scripts/pssCommon/users/userfileProd.csv"
  # sfdx org assign permset -o DCNFull -n Salesforce_CPQ_User_Custom -b  

   # sfdx force:data:soql:query -q "SELECT Id,PermissionSetLicenseId,AssigneeId from PermissionSetLicenseAssign" -o DCNFull

    #sfdx force:data:soql:query -q "SELECT Id,name from permissionset order by name" -o DCNFull


    $sqol = "SELECT Id,PermissionSetId,AssigneeId,Assignee.username  from PermissionSetAssignment  "

   
    $sqol = "SELECT  PermissionSetId,Assignee.username  from PermissionSetAssignment  " 
    $sqol += " where PermissionSetId= '0PS3i000001z24kGAA'and Assignee.isactive=true order by Assignee.username"
    sfdx data query -q $sqol -o DCNProd -r csv  >> $path

   # sfdx force:data:soql:query -q "SELECT Id,PermissionSetLicenseId,AssigneeId from PermissionSetLicenseAssign" -o DCNFull

 
<#
 git config --global user.email bburen@datainnovations.com

 git config --global user.name "bburen"

 #>
 
 