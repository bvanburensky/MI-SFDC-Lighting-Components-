/* 
 Menorah IC 03/01/2023
// test data factory 

*/
@isTest(SeeAllData = false)
public class MI_TestFactory {
 
    public static List<Lead> createLead(Integer numberOfRecords,Boolean isInsert) {
        List<Lead> listLeads=new List<Lead>();
        for(Integer i=0;i<numberOfRecords;i++){
            Lead testLead = new Lead();
            testLead.LastName='LastName'+i;
            testLead.Company='CompanyName'+i;
            testLead.Status='Prospect';
            listLeads.add(testLead);
        }
        if(isInsert){
            insert listLeads;
        }
        return listLeads;
    }
    public static List<Account> createAccount(Id recordTypeId,Integer numberOfRecords,Boolean isInsert) {
        List<Account> listAccounts=new List<Account>();
        for(Integer i=0;i<numberOfRecords;i++){
            Account testAcc = new Account();
          //  testAcc.RecordTypeId=recordTypeId;
            testAcc.Name = 'my test account'+i;
       //     testAcc.BillingState = 'CA';
        //    testAcc.ShippingState = 'CA';
       //     testAcc.BillingCountry = 'USA';
       //     testAcc.ShippingCountry = 'USA';
        //    testAcc.Facility_Type2__c = 'Blood Bank';

            //testAcc.Type__c = 'Customer';
            listAccounts.add(testAcc);
        }
        if(isInsert){
            insert listAccounts;
        }
        return listAccounts;
    }
    public static List<Contact> createContact(Id accountId,Integer numberOfRecords,Boolean isInsert) {
        List<Contact> listContacts=new List<Contact>();
        for(Integer i=0;i<numberOfRecords;i++){
            Contact testContact = new Contact();
            testContact.FirstName = 'firstname';
            testContact.LastName = 'lastname'+i;
            testContact.Email = 'email@mail.me';
            testContact.AccountId = accountId;
            listContacts.add(testContact);
        }
        if(isInsert){
            insert listContacts;
        }
        return listContacts;
    }
    public static List<Case> createCase(Id recordTypeId,Integer numberOfRecords,Boolean isInsert) {
        List<Case> listCase=new List<Case>();
        for(Integer i=0;i<numberOfRecords;i++){
            Case testCase = new Case();
            testCase.Status = 'Open';
            //testCase.RecordTypeId = recordTypeId;
            listCase.add(testCase);
        }
        if(isInsert){
            insert listCase;
        }
        return listCase;
    }
    public static List<Opportunity> createOpportunity(Id accountId,Id recordTypeId,Integer numberOfRecords,Boolean isInsert) {
        List<Opportunity> listOpportunity=new List<Opportunity>();
        for(Integer i=0;i<numberOfRecords;i++){
            Opportunity testOpportunity = new Opportunity();
            testOpportunity.Name = 'my test opportunity'+i;
            testOpportunity.Type = 'New Business';
       
           // testOpportunity.RecordTypeId = recordTypeId;
            testOpportunity.AccountId = accountId;
            testOpportunity.CloseDate =date.today().addDays(30);
            testOpportunity.StageName ='Prove';
            testOpportunity.LeadSource = 'Epic';
            testOpportunity.Amount = 10.00;
 
            listOpportunity.add(testOpportunity);
        }
        if(isInsert){
            insert listOpportunity;
        }
        return listOpportunity;
    }
    //add role 
    public static List<OpportunityContactRole> createOpportunityContactRole(Id opportunityId,Id contactID,Id roleId,Integer numberOfRecords,Boolean isInsert) {
        List<OpportunityContactRole> listOpportunityContactRole=new List<OpportunityContactRole>();
        for(Integer i=0;i<numberOfRecords;i++){
            OpportunityContactRole testOpportunityContactRole = new OpportunityContactRole();
            testOpportunityContactRole.opportunityId = opportunityId;
            testOpportunityContactRole.contactID = contactID;
            testOpportunityContactRole.Role= roleId;
            listOpportunityContactRole.add(testOpportunityContactRole);
        }
        if(isInsert){
            insert listOpportunityContactRole;
        }
        return listOpportunityContactRole;
    }
    //Create Product
    public static List<Product2> createProdcut(Integer numberOfRecords,Boolean isInsert)
    {
        List<Product2> listProduct =new List<Product2>();
        for(Integer i=0;i<numberOfRecords;i++){
            Product2 testProduct = new Product2();
            testProduct.Name = 'my test prodcut'+i;
            testProduct.ProductCode = 'my test prodcut code'+i;
            testProduct.IsActive = true;
    
            testProduct.Family = 'EP Evaluator Subscriptions';
 
            listProduct.add(testProduct);
        }
        if(isInsert){
            insert listProduct;
        }
        return listProduct;
    }
    
    //Create pricebook entry
    public static List<PricebookEntry> createPricebookEntry(Id prdId,Integer numberOfRecords,Boolean isInsert)
    {
        Id pricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> listPricebookEntry=new List<PricebookEntry>();
        for(Integer i=0;i<numberOfRecords;i++){
            PricebookEntry testPricebookEntry = new PricebookEntry();
            testPricebookEntry.Pricebook2Id = pricebookId;
            testPricebookEntry.Product2Id = prdId;
            testPricebookEntry.UnitPrice = 10.00;
            testPricebookEntry.IsActive = true;
            listPricebookEntry.add(testPricebookEntry);
        }
        if(isInsert){
            insert listPricebookEntry;
        }
        return listPricebookEntry;
    }
    
    //add Opportunity Line Item  
    public static List<OpportunityLineItem> createOpportunityLineItem(Id opportunityId,Id pricebookEntryID, Integer numberOfRecords,Boolean isInsert) {
        List<OpportunityLineItem> listOpportunityLineItem=new List<OpportunityLineItem>();
        for(Integer i=0;i<numberOfRecords;i++){
            OpportunityLineItem testOpportunityLineItem = new OpportunityLineItem();
            testOpportunityLineItem.opportunityId = opportunityId;
            testOpportunityLineItem.Quantity = 1;
            testOpportunityLineItem.PricebookEntryId = pricebookEntryID;
            testOpportunityLineItem.UnitPrice = 100.00;
            listOpportunityLineItem.add(testOpportunityLineItem);
        }
        if(isInsert){
            insert listOpportunityLineItem;
        }
        return listOpportunityLineItem;
    }
    public static List<User> createUser(ID profileId,Id roleId,Integer numberOfRecords,Boolean isInsert) {
        List<User> listUser =new List<User>();
        for(Integer i=0;i<numberOfRecords;i++){
            User testUser = new User();
            testUser.FirstName = 'firstname';
            testUser.LastName = 'lastname'+i;
            testUser.Email = 'test' + i + '@example.com';
            testUser.Alias = 'test' + i;
            testUser.Username = 'test' + i + '@ava-001-example.com';
            testUser.LocaleSidKey = 'en_US';
            testUser.TimeZoneSidKey = 'GMT';
            testUser.ProfileID = profileId;
            testUser.UserRoleId = roleId;
            testUser.LanguageLocaleKey = 'en_US';
            testUser.EmailEncodingKey = 'UTF-8';
            listUser.add(testUser);
        }
        if(isInsert){
            insert listUser;
        }
        return listUser;
    }
    public static List<Event> createEvent(Id WhoId,Id WhatId, Id UserID,Integer numberOfRecords,Boolean isInsert) {
        List<Event> listEvent =new List<Event>();
        for(Integer i=0;i<numberOfRecords;i++){
            Event testEvent = new Event();
            testEvent.WhoId = WhoID;
            testEvent.OwnerId = UserID;
            testEvent.IsAllDayEvent = true;
            testEvent.ActivityDate =  Date.today();
            testEvent.WhatId = WhatId;
            listEvent.add(testEvent);
        }
        if(isInsert){
            insert listEvent;
        }
        return listEvent;
    }

    public static List<contract> createContract(Account acct,boolean isInsert) {
        contract ct =   new Contract(Accountid = acct.id, startdate = Date.Today(), ContractTerm = 12);
        List<contract> listContract =new List<contract>(); 
        listContract.add(ct);
        if(isInsert){
            insert listContract ;
        }
        return listContract ;
    }
    
}