 
$packageHash = @{}


  


$packageHash.add("SBQQ__Subscription__c", 
    @{fields        =
        " 
        Id,
        Name, 
        SBQQ__RevisedSubscription__c,
        SBQQ__RevisedSubscription__r.Name 
        
    ";
        importOrder = "1";
        where       = " where sbqq__contract__c ='8002M000000KLZCQA4' and SBQQ__RevisedSubscription__c != null ";
        externalId  = "Id";
        orderBy     = "order by SBQQ__RevisedSubscription__r.Name    ";
         ignore      = $true
     
    } )



    $packageHash.add("Asset.ToTouch", 
    @{fields        =
        " 
       AssetNumber__c,
       
        
    ";
        importOrder = "1";
        where       = " where sys_NeedsUpdate__c = true ";
        externalId  = "AssetNumber__c";
        orderBy     = "order by SBQQ__RevisedSubscription__r.Name    ";
         ignore      = $true
     
    } )


return $packageHash
 

