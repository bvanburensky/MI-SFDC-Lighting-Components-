 
$packageHash = @{}




    $packageHash.add("Account.fix", 
    @{fields        =
        " 
        Account_Number__c,
        Name ,
        BillingCity,
        BillingStreet,
        ShippingCity,
        ShippingStreet
     
           

        
    ";
        importOrder = "2";
        where       = " where  BillingCity > ''   ";
        externalId  = "Account_Number__c";   
        orderBy     = "order by Name  ";  
         ignore      = $true
     
    } )


$packageHash.add("Contact", 
    @{fields        =
        " 
    Account.Account_Number__c,
    Active__c,
 
    Add_l_Phone__c,
    Community_Access__c,
    Community_Access_Type__c,
    Contact_Number__c,
    Contact_Type__c,
    CurrencyIsoCode,
    CWP_Type__c,
    Department,
    DoNotCall,
    Email,
    FirstName,
    lastname,
    Functional_Department__c,
    IndividualId,
    LeadSource,
    MailingCity,
    MailingCountry,
    MailingLatitude,
    MailingLongitude,
    MailingPostalCode,
    MailingState,
    MailingStreet,
    MobilePhone,

    NetSuite_Internal_ID__c,
 
    OtherCity,
    OtherCountry,
    OtherLatitude,
    OtherPhone,
    OtherPostalCode,
    OtherState,
    OwnerId,
    Primary_Account_Contact__c,
    Title
    ";
        importOrder = "2";
        where       = " where firstname > '' and  Accountid > '' and " +
                        "  lastname > '' and Account.BillingCity > ''  and Email != null ";
    


        externalId  = "Contact_Number__c";   
        orderBy     = "order by Contact_Number__c    " #+ " limit 100 ";  
        ignore      = $true
     
    } )


 
    ## no address meta data .  

    # Address_Number__c,    
$packageHash.add("Address__c.raw", 
    @{fields        =
        " 
    Name , 
    Type__c,
    Primary__c,
    Active__c,    
    Account__r.Account_Number__c, 
    Street__c,
    City__c,
    State_Province__c,
    Zip_Postal_Code__c,
    Country__c

    ";
        importOrder = "2";
        where       = " where  Account__r.BillingCity > '' and Account__c != null ";
        externalId  = "Address_Number__c";   
        orderBy     = "order by Country__c ,State_Province__c  ";  
        ignore      = $true
     
    } )

 <#
 Name,Primary__c,Active__c,Is_Valid_Address__c,Type__c,Address__Street__s,Address__City__s,Address__StateCode__s,     Address__PostalCode__s,Address__CountryCode__s,    
 Address__PostalCode__s:Post,Address__Street__s:Str, Address__City__s:City,Address__StateCode__s:State,Address__CountryCode__s:Contry,


 Primary__c,Active__c,Type__c,Is_Valid_Address__c,Address__c,Address__Street__s,
    Address__City__s,Address__StateCode__s,Address__CountryCode__s,Address__PostalCode__s,Name


    
    
    Address__PostalCode__s,Address__CountryCode__s,

     Street__c,City__c,State_Province__c,Country__c


 #>
  ## try different combos  ###############

  $packageHash.add("Address__c.staged_xAll", 
  @{fields        =
      " 
  address_number__c,    

  max(Street__c) Address__Street__s,
  max(City__c) Address__City__s,
  max(State_Province__c) Address__StateCode__s,    
  max(Zip_Postal_Code__c) Address__PostalCode__s,
  max( Country__c ) Address__CountryCode__s

  ";
      importOrder = "5";
      where       = " where  Address__City__s = null and City__c != null";
      externalId  = "address_number__c";   
      orderBy     = "group by address_number__c  order by  max( Country__c )    limit 2000";  
      ignore      = $true
   
  } )


    $packageHash.add("Address__c.staged_xState", 
    @{fields        =
        " 
    address_number__c,    

    max(Street__c) Address__Street__s,
    max(City__c) Address__City__s,

    max(Zip_Postal_Code__c) Address__PostalCode__s,
    max( Country__c ) Address__CountryCode__s

    ";
        importOrder = "5";
        where       = " where Address__City__s = null and City__c != null";
        externalId  = "address_number__c";   
        orderBy     = "group by address_number__c  order by  max( Country__c )    limit 2000";  
     #   ignore      = $true
     
    } )

 
 
    $packageHash.add("Address__c.staged_xCountry", 
    @{fields        =
        " 
    address_number__c,    
    max(Street__c) Address__Street__s,
    max(City__c) Address__City__s,
    max(State_Province__c) Address__StateCode__s,
    max(Zip_Postal_Code__c) Address__PostalCode__s
 

    ";
        importOrder = "5";
        where       =  " where Address__City__s = null and City__c != null"; ;
        externalId  = "address_number__c";   
        orderBy     = "group by address_number__c  order by  max( Country__c )    limit 2000";  
     ignore      = $true
     
    } )


    $packageHash.add("Address__c.staged_xPostalCode_", 
    @{fields        =
        " 
    address_number__c,    

    max(Street__c) Address__Street__s,
    max(City__c) Address__City__s,
    max(State_Province__c) Address__StateCode__s
 

    ";
        importOrder = "5";
        where       = " where  Address__City__s = null   " ;
        externalId  = "address_number__c";   
        orderBy     = "group by address_number__c  order by  max( Country__c )    limit 2000";  
       ignore      = $true
     
    } )


    $packageHash.add("Address__c.addressCk", 
    @{fields        =
        " 
    
    address_number__c,
    name,
    Primary__c,
   
    Active__c,
    Type__c,
 
    Address__Street__s,
    Address__City__s,
    Address__PostalCode__s,
    Address__StateCode__s,

    Address__CountryCode__s,
    Address__Latitude__s,
    Address__Longitude__s, 
    Address__GeocodeAccuracy__s,

    State_Province__c,
    Street__c,
    City__c,
    Zip_Postal_Code__c,
    Country__c


    ";
        importOrder = "4";
        
        where3       = " where Country__c != null   and Street__c != null and City__c != null and Zip_Postal_Code__c !=null and Address__Street__s = null  ";
        where1       = "  where Address__Country__s = null and address_number__c = 'A-010989' ";
        where       = "  where Address__City__s = null  ";        

       externalId  = "address_number__c";   
        orderBy     = "order by Country__c  ";  
      ignore      = $true ;
       # ignoreGet      = $true ;
        ignoreDeploy = $true
     
    } )
    

    $packageHash.add("Address__c.Ok", 
    @{fields        =
        " 
    
    address_number__c,
    name,
    Primary__c,
   
    Active__c,
    Type__c,
 
    Address__Street__s,
    Address__City__s,
    Address__PostalCode__s,
    Address__StateCode__s,

    Address__CountryCode__s,
    Address__Latitude__s,
    Address__Longitude__s, 
    Address__GeocodeAccuracy__s,

    State_Province__c,
    Street__c,
    City__c,
    Zip_Postal_Code__c,
    Country__c


    ";
        importOrder = "10";
        
        where3       = " where Country__c != null   and Street__c != null and City__c != null and Zip_Postal_Code__c !=null and Address__Street__s = null  ";
        where1       = "  where Address__Country__s = null and address_number__c = 'A-010989' ";
        where       = "  where Address__City__s != null  ";        

       externalId  = "address_number__c";   
        orderBy     = "order by Country__c  ";  
       ignore      = $true ;
       # ignoreGet      = $true ;
        ignoreDeploy = $true
     
    } )

## pull it down then upload

    $packageHash.add("Address__c.fixCountry", 
    @{fields        =
        " 
    
    address_number__c,
 
    Country__c
  

    ";
        importOrder = "7";
        where       = " where Address__City__s = null and City__c != null and Country__c != null";
        externalId  = "address_number__c";   
        orderBy     = "order by Country__c  ";  
      ignore      = $true ;
        #ignoreDeploy = $true ;
       #  ignoreGet    =   $true
     
    } )
    $packageHash.add("Address__c.fixCountryGet", 
    @{fields        =
        " 
    
    address_number__c,
    Country__c
  

    ";
        importOrder = "4";
        where       = " where Address__City__s = null and Country__c != null";
        externalId  = "address_number__c";   
        orderBy     = "order by Country__c  ";  
       ignore      = $true ;
        ignoreDeploy = $true ;
      #  ignoreGet    =   $true
     
    } )

return $packageHash
 

