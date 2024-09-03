
<# 
Delete unused fields

 testing
 #sfdx force:source:retrieve -m CustomField:Contract.CPOStatus__c -u sfcpqdev2
 #sfdx force:source:deploy -m CustomField:Contract.CPOStatus__c -u sfcpqdev
 #sfdx force:source:delete --sourcepath force-app\main\default\objects\Contract\fields\CPOStatus__c.field-meta.xml --noprompt -u sfcpqdev --loglevel trace 

#>

80103000000jI3nAAE::CreateContract


sfdx force:data:bulk:delete -u fullqa -s sbqq__recordjob__c -f './scripts/data/delete.csv'

sfdx force:data:bulk:delete -u DInessdevnew -s sbqq__recordjob__c -f './scripts/pssData/data/org/DInessdevnew/SBQQ__LineColumn__c.toDelete.csv'

sfdx force:data:record:get -s SBQQ__LineColumn__c -i a0T2h000002Ct75EAC

,a0T2h000002Ct75EAC,UNIT PRICE
,a0T2h000002Ct73EAC,PART #
,a0T2h000002Ct72EAC,QTY
,a0T2h000002Ct76EAC,DISC (%)
,a0T2h000002Ct77EAC,EXTENDED
,a0T2h000002Ct74EAC,DESCRIPTION


sfdx force:data:bulk:status -i 75003000002L4VwAAK -b 75103000002oI95AAE

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