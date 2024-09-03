
# not part of the deploy scripts
# pull down metadata that is incomplete using standard methods

sfdx project retrieve start -m CustomObject

 

sfdx project retrieve start -m CustomObject:Contract 
sfdx project retrieve start -m CustomObject:OrderItem

sfdx project retrieve start -m CustomObject:Order
sfdx project retrieve start -m CustomObject:Account
sfdx project retrieve start -m CustomObject:Contact
sfdx project retrieve start -m CustomObject:Opportunity
# sfdx project retrieve start -m customObject:AV2_Setting__mdt
sfdx project retrieve start -m customObject:Opportunity
sfdx project retrieve start -m customObject:OpportunityLineItem
sfdx project retrieve start -m customObject:Order_IQ_Line__c
sfdx project retrieve start -m customObject:Account_Service__c  
sfdx project retrieve start -m Flow
sfdx project retrieve start -m flexipage
sfdx project retrieve start -m ApexClass
sfdx project retrieve start -m ApexTrigger
sfdx project retrieve start -m layout
sfdx project retrieve start -m customPermission
sfdx project retrieve start -m permissionSet

 
 
sfdx project retrieve start -m approvalProcess 
 
sfdx project retrieve start -m StandardValueSet

sfdx project retrieve start -m EmailTemplate

sfdx project retrieve start -m AuraDefinitionBundle

sfdx project retrieve start -m GlobalValueset
 
sfdx project retrieve start -m QuickAction
sfdx project retrieve start -m ValidationRule
 
 