 
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



    $packageHash.add("SBQQ__RecordJob__c", 
    @{fields        =
        " 
          CreatedById, 
          CreatedDate, Id,
           LastModifiedDate,
            Name, SBQQ__IsRead__c, 
            SBQQ__JobDetails__c, SBQQ__JobId__c,
            SBQQ__JobStatus__c, SBQQ__RecordId__c, 
            SBQQ__RedirectUrl__c, 
            SBQQ__Stacktrace__c
 
       
      
        
    ";
        importOrder = "1";
      #  where       = " where sbqq__contract__c ='8002M000000KLZCQA4' and SBQQ__RevisedSubscription__c != null ";
        externalId  = "Id";
        orderBy     = " ORDER BY LastModifiedDate DESC  llimit 100 ";
       #  ignore      = $true
     
    } )


    ORDER BY LastModifiedDate DESC



return $packageHash
 

