@IsTest
private   class PDFViewerController_Test {

    @Testsetup
    static void setup(){

        Account acct = new Account();
        //  testAcc.RecordTypeId=recordTypeId;
        acct.Name = 'my test account';
        insert acct;
        String title =   'test';
 

        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient = title +'.pdf'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = title; // Display name of the files
         
        Blob b = Blob.valueOf('asd');
        conVer.VersionData = b;// EncodingUtil.base64Decode(content); // converting your binary string to Blog
        insert conVer;    //Insert ContentVersion
        
        
        // First get the Content Document Id from ContentVersion Object
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        
        //create ContentDocumentLink  record 
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId =acct.id; // Specify Account ID here OR Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //Content Note Id
        conDocLink.shareType = 'V';
        insert conDocLink;
       
    }
 


    @IsTest
    static void test1 () {
        
       account a = [select id from account limit 1];

        PDFViewerController.showPDFforRec(a.id);
        


    }
}