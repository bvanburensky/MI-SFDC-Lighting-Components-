
# pull all SBQQ objects 
 

sfdx project retrieve start -m customObject:breadwinner_ns__BW_Invoice__c
sfdx project retrieve start -m customObject:breadwinner_ns__BW_Line_Item__c
sfdx project retrieve start -m customObject:breadwinner_ns__BW_Credit_Memo__c
sfdx project retrieve start -m customObject:breadwinner_ns__BW_Payment__c
sfdx project retrieve start -m customObject:breadwinner_ns__BW_Payment_Transaction__c
sfdx project retrieve start -m customObject:breadwinner_ns__BW_Sales_Order__c
sfdx project retrieve start -m customObject:breadwinner_ns__BW_Item__c
sfdx project retrieve start -m customObject:breadwinner_ns__BW_Company__c

