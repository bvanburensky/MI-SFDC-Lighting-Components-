
 

$packageHash = @{}
 
$packageHash.add("Pricebook2", 
@{fields   = "
Unique_ID__c,
IsActive,
Name ,
Description,
IsStandard
  ";
    importOrder ="1"
} ) 

$packageHash.add("SBQQ__BlockPrice__c",
    @{fields   = 
    " Unique_ID__c,
    SBQQ__EffectiveDate__c,
    SBQQ__LowerBound__c,
    SBQQ__OrderProduct__c,
    SBQQ__OriginalBlockPrice__c,
    SBQQ__Price__c,
    SBQQ__PriceBook2__r.Unique_ID__c,
    SBQQ__Product__c,
    SBQQ__QuoteLine__c,
    SBQQ__UpperBound__c ";
        importOrder ="2";
        ignore = $true  #Not used currently 
    } )   



    $packageHash.add("SBQQ__DiscountSchedule__c", 
    @{fields   = "
    Unique_ID__c,
    Name,
    SBQQ__Product__r.Unique_ID__c,
    SBQQ__Pricebook__r.Unique_ID__c,
    SBQQ__Account__c,
    SBQQ__AggregationScope__c,
    SBQQ__ConstraintField__c,
    SBQQ__CrossOrders__c,
    SBQQ__CrossProducts__c,
    SBQQ__Description__c,
    SBQQ__DiscountUnit__c,
    SBQQ__ExcludedPricebookIds__c,
    SBQQ__IncludeBundledProducts__c,
    SBQQ__Order__c,
    SBQQ__OrderProduct__c,
    SBQQ__OriginalDiscountSchedule__c,
    SBQQ__OverrideBehavior__c,
    SBQQ__PriceScale__c,
    SBQQ__Quote__c,
    SBQQ__QuoteLine__c,
    SBQQ__QuoteLineQuantityField__c,
    SBQQ__Type__c,
    SBQQ__UsePriceForAmount__c,
    SBQQ__UserDefined__c
  ";
        importOrder ="2"
    } ) 

    $packageHash.add("SBQQ__DiscountTier__c", 
    @{fields   = "
    Unique_ID__c,
    SBQQ__Schedule__r.Unique_ID__c,
    Name ,
    SBQQ__Discount__c,
    SBQQ__DiscountAmount__c,
    SBQQ__LowerBound__c,
    SBQQ__Number__c,
    SBQQ__Price__c,

    SBQQ__UpperBound__c
      ";
        importOrder ="2"
    } ) 




return $packageHash
 

