
# not part of the deploy scripts
# pull down metadata that is incomplete using standard methods

 
sfdx force:source:retrieve -m layout:"SBQQ__CustomAction__c-SBQQ__Custom Action Layout"
sfdx force:source:retrieve -m FlexiPage

sfdx force:source:retrieve -m CompactLayouts
sfdx force:source:retrieve -m permissionset:SBQQ-SteelBrickCPQAdmin
 

 