 

$packageHash = @{}

 
$packageHash.add("SBQQ__ProductFeature__c",
    @{
        where       = " where Unique_ID__c like 'EX-20221113%'"; 
        fields        = 
        "  
        Name,
        Unique_ID__c,
        SBQQ__Category__c,
        SBQQ__ConfigurationFieldSet__c,
        SBQQ__ConfiguredSKU__r.Unique_ID__c,
        SBQQ__DiscountSchedule__r.Unique_ID__c,
        SBQQ__DynamicProductFilterFieldSet__c,
        SBQQ__DynamicProductLookupFieldSet__c,
        SBQQ__MaxOptionCount__c,
        SBQQ__MinOptionCount__c,
        SBQQ__Number__c,
        SBQQ__OptionSelectionMethod__c
      ";
     
    #   ignore      = $true  
        importOrder = "1" ;

    } )  

$packageHash.add("SBQQ__ProductOption__c",
@{
    #ignore      = $true  ;
    where       = " where SBQQ__OptionalSKU__r.Unique_ID__c like 'EX-20221113%'";
    fields        = 
        "  
      
        Unique_ID__c,
        SBQQ__ConfiguredSKU__r.Unique_ID__c, 
        SBQQ__DiscountSchedule__r.Unique_ID__c,     
        SBQQ__OptionalSKU__r.Unique_ID__c,    
        SBQQ__Feature__r.Unique_ID__c,               
        Connection_Notes__c,
   
        Expiration_Date__c,
        Expiring__c,
          
        SBQQ__AppliedImmediately__c,
        SBQQ__AppliedImmediatelyContext__c,
        SBQQ__Bundled__c,
        SBQQ__ComponentCode__c,
        SBQQ__ComponentCodePosition__c,
        SBQQ__ComponentDescription__c,
        SBQQ__ComponentDescriptionPosition__c,
    
        SBQQ__DefaultPricingTable__c,
        SBQQ__Discount__c,
        SBQQ__DiscountAmount__c,
        SBQQ__DiscountedByPackage__c,
      
        SBQQ__ExistingQuantity__c,
  
        SBQQ__MaxQuantity__c,
        SBQQ__MinQuantity__c,
        SBQQ__Number__c,
        SBQQ__Quantity__c,
        SBQQ__QuantityEditable__c,
        SBQQ__QuoteLineVisibility__c,
        SBQQ__RenewalProductOption__c,
        SBQQ__Required__c,
        SBQQ__Selected__c,
        SBQQ__SubscriptionScope__c,
        SBQQ__System__c,
        SBQQ__Type__c,
        SBQQ__UnitPrice__c,
        SBQQ__UpliftedByPackage__c,
        Subscription_Term_for_Bundle__c,
        Time_Zone_Awareness__c,
        Total_3rd_Party_Connections__c,
        Total_Non_3rd_Party_Connections__c  ";
 
          importOrder = "3"
    } )  


 
 

    $packageHash.add("SBQQ__OptionConstraint__c",
    @{fields        = 
        " Unique_ID__c,
        Name,
        SBQQ__Active__c,
        SBQQ__CheckPriorPurchases__c,
        SBQQ__ConfiguredSKU__r.Unique_ID__c ,
        SBQQ__ConstrainedOption__r.Unique_ID__c ,
        SBQQ__ConstrainingOption__r.Unique_ID__c ,
        SBQQ__OptionConstraintGroup__c,
        SBQQ__Type__c ";
        importOrder = "4" ;
        where       = ""
        ignore      = $true
    } ) 

$packageHash.add("SBQQ__ConfigurationAttribute__c",
    @{fields        = " 
        Unique_ID__c,
        SBQQ__Feature__r.Unique_ID__c,
        SBQQ__Product__r.Unique_ID__c ,       
        Name,
        RecordTypeId,
       SBQQ__AppliedImmediately__c,
       SBQQ__ApplyToProductOptions__c,
       SBQQ__AutoSelect__c,
       SBQQ__ColumnOrder__c,
       SBQQ__DefaultField__c,
       SBQQ__DefaultObject__c,
       SBQQ__DisplayOrder__c,
       SBQQ__Hidden__c,
       SBQQ__HiddenValues__c,
       SBQQ__Position__c,
       SBQQ__Required__c,
       SBQQ__ShownValues__c,
       SBQQ__TargetField__c       ";
       ignore      = $true  
        where       = "" ;
        importOrder = "2"
    } )  
    




return $packageHash
 

