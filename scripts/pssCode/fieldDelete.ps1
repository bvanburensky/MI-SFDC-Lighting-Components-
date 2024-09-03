
<# 
Delete unused fields
Not part of the deploy but this is the only way i figured out to do it with sfdx 
 testing
 #sfdx force:source:retrieve -m CustomField:Contract.CPOStatus__c -u sfcpqdev2
 #sfdx force:source:deploy -m CustomField:Contract.CPOStatus__c -u sfcpqdev
 #sfdx force:source:delete --sourcepath force-app\main\default\objects\Contract\fields\CPOStatus__c.field-meta.xml --noprompt -u sfcpqdev --loglevel trace 

#>

sfdx force:source:delete --sourcepath force-app\main\default\objects\Contract\fields\CPOStatus__c.field-meta.xml --noprompt -u sfcpqdev --loglevel trace 


#    sfdx force:source:delete -p ./objects/Contract/fields/Total_Renewal_Forecast__c

#   sfdx force:source:delete -m -c CustomField:Contract.Total_Renewal_Forecast__c

#  sfdx force:source:delete --help

 #sfdx force:source:retrieve -m CustomField:Contract.CPOStatus__c
 # sfdx auth:web:login -r "https://avalara--sfcpqdev2.my.salesforce.com/"
 # sfdx auth:web:login -r "https://avalara--sfcpqdev.my.salesforce.com/" --setdefaultusername
 <#
 sfdx auth:web:login -a sfcpqdev2
 sfdx alias:list
 sfdx auth:list
sfdx force:source:delete --loglevel trace -m  "CustomField:Contract.CPOStatus__c"
#>

 
 ##sfdx force:source:retrieve -m CustomField:Contract.audit__c  -u sfcpqdev2
 #sfdx force:source:retrieve -m CustomField:Contract.CPOStatus__c -u sfcpqdev2
 #sfdx force:source:deploy -m CustomField:Contract.CPOStatus__c -u sfcpqdev

 # sfdx force:source:delete --loglevel trace -m  "CustomField:Contract.CPOStatus__c"  -u sfcpqdev2
 sfdx force:source:delete --sourcepath force-app\main\default\objects\Contract\fields\CPOStatus__c.field-meta.xml --noprompt -u sfcpqdev --loglevel trace 
 #sfdx force:source:delete --sourcepath d:\VSDev\VSProjects\VS-CPQ2-755\force-app\main\default\objects\Contract\fields\CPOStatus__c.field-meta.xml  --loglevel trace 