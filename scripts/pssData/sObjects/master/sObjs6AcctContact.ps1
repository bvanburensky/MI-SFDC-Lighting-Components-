 
$packageHash = @{}




$packageHash.add("Account.NoParent", 
    @{fields        =
        " 
        Account_Number__c,
        AccountSource,
        Abbott_Pricing__c,
     
     
        BillingCity,
        BillingCountry,
        BillingLatitude,
        BillingLongitude,
        BillingState,
        BillingPostalCode,
        BillingStreet,
        CurrencyIsoCode,
        Customer_Number__c,
        DBA_Alias__c,
        Facility_Type__c,
        Facility_Type2__c,
        Government_Customer__c,
   
        Name,
    
        NetSuite_Internal_Id__c,

        PO_Requirements__c,
        Region__c,
     
    
        ShippingCity,
        ShippingCountry,
        ShippingState,
        ShippingStreet,
        ShippingPostalCode,
        ShippingLongitude,
        Strategic_Account__c,
        Type
    ";
        importOrder = "1";
        where       = " where BillingCity > '' ";
        externalId  = "Account_Number__c";
        orderBy     = "order by Name   ";
        ignore      = $true
     
    } )

$packageHash.add("Account.Parent", 
    @{fields        =
        " 
        Account_Number__c,
        Parent.Account_Number__c 
        
    ";
        importOrder = "2";
        where       = " where ParentId > ''  and   Parent.BillingCity > '' ";
        externalId  = "Account_Number__c";   
        orderBy     = "order by Name  ";  
        ignore      = $true
     
    } )



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


 
return $packageHash
 

