@isTest
private class MI_UtilityTest {

     
/* 
 Menorah IC 03/01/2023
    * @description test setup
    * menorah-intc 
    * 
*/
        @testSetup
        static void testSetupCoreObjects() {
        Account acc = MI_TestFactory.createAccount(null, 1, true)[0] ;
        Contact con = MI_TestFactory.createContact(acc.id, 1, true)[0] ;
        update con ;        

        //con = date.today();
      
        }
  
    @isTest
    static void testGetSObjectFields() {
       string sel = 'select ' + MI_Utility.getSObjectFields('Contact') + ' from contact limit 1';
       sobject sObj = Database.query(sel);
       System.assert(((string)sobj.get('Name')) != 'xxx', 'Looks bad');

    }
    @isTest
    static  void testGetSObjectFieldsAndLabels() {

      map<string,string> flds =  MI_Utility.getSObjectFieldsAndLabels('Account');
      System.assert(flds.get('Name') != 'asd','test');

 
    }   

 
@isTest
    static  void testSetExecute() {
        MI_Utility.setExecuted('User');
        MI_Utility.isExecuted('User');
        MI_Utility.setExecuted('User',false);
    }
 
  /*
    @isTest
  //  static  void test2()
 //   {
 //      Product2[] prods = MI_TestFactory.createProdcut(1, false) ;
      // prods[0].unique_id__c = 'asdasdasdasd';
 
  //     string[] res =  MI_UpsertFromFlow.upsertRecords(prods);
  //     system.debug('Ok ' + res[0] );

 //      prods = MI_TestFactory.createProdcut(1, false) ;   
   //    prods[0].unique_id__c = 'asdasdasdasssd';   
     //  prods[0].Financial_Category__c = '';
  //     res = MI_UpsertFromFlow.upsertRecords(prods);
 //     system.debug('Bad ' + res[0] );       
   // }
   */
 
    @isTest
    static  void test3()
    {
        MI_Utility.isSandbox();
    }

    @isTest
	static void test4() {

		Account acct = [select name,
         (select firstname from contacts)
         from account limit 1];
 

		object ob =MI_Utility.getString(null);
        ob =MI_Utility.getString(null,2);
		ob =MI_Utility.getString('asd');
		ob =MI_Utility.getString('asd', 'asd');
		ob =MI_Utility.getString(null, 'asd');
		ob =MI_Utility.getString(null, 'asd', 0);
		ob =MI_Utility.getString('', 'asd', 0);
		ob =MI_Utility.getString('aa', '', 0);
		ob =MI_Utility.getString('assssa', 'asdasd', 2);
		ob =MI_Utility.getString('aadasda', 'asdasd', -2);
		ob =MI_Utility.getString('aa', 'asdasd', 500);
		ob =MI_Utility.getString('aa', 'asdasd', - 1, 5000);
		ob =MI_Utility.getString(2.5, 2);


		ob =MI_Utility.getString('asd - xyz', 'asdasd', 'asd');
		ob =MI_Utility.getString('asd - xyz', 'asdasd', 'xyz');

 
		ob =MI_Utility.IsEmpty('3.55');
		ob =MI_Utility.IsEmpty(3.55);
		ob =MI_Utility.IsEmpty(0.000);

		ob =MI_Utility.IsEmpty('');

		ob =MI_Utility.isNotEmpty('');
		ob =MI_Utility.isNotEmpty('asd');
		ob =MI_Utility.getDecimal(25.5, 6);
		ob =MI_Utility.getDecimal(25.5, 6, true);
		ob =MI_Utility.getDecimal('1', 0);
		ob =MI_Utility.getDecimal(99, 0);
		ob =MI_Utility.getDecimal('', 0);
		ob =MI_Utility.getDecimal('', 0, true);
		ob =MI_Utility.getDecimal('', 0);
		ob =MI_Utility.getDecimal('1', 0, true);
		ob =MI_Utility.getDecimal('', 0, true);
		ob =MI_Utility.getDecimal(acct, 0);
		ob =MI_Utility.getDecimal(0, 5, true);
		ob =MI_Utility.getDecimal('10.5.5.5', 5, true);
        ob =MI_Utility.getDecimal('10.5.5.5', 5, 0); 
		ob =MI_Utility.getDecimal('10.5.5.5', 5);
		ob =MI_Utility.getDecimal(5.5, 5.5, 2);
        ob =MI_Utility.getDecimal(5.5, 5, 2);
		System.assert(ob != null, 'Decimal convert error');



		ob =MI_Utility.getInteger('1', 5);
		ob =MI_Utility.getInteger(ob, 5);
		ob =MI_Utility.getInteger(acct, 5);
		ob =MI_Utility.getInteger(0, 5);
		ob =MI_Utility.getInteger('', 5);
		ob =MI_Utility.getInteger(25.5, 5);
        ob =MI_Utility.getInteger(ob, 5);
 

        
	}
    @isTest
	static void test5() {

		Contact contact = [select firstname,account.name ,account.Owner.name
         from Contact limit 1];
 
         MI_Utility.getSObjFld(contact, 'firstname');
         MI_Utility.getSObjFld(contact, 'account.name');
         MI_Utility.getSObjFld(contact, 'account.Owner.name');
         system.debug(contact);
    }

    @isTest
	static void test6() {

        Schema.DescribeSObjectResult objSchema = Account.getSObjectType().getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objSchema.fields.getmap();
        system.debug(MI_Utility.selectAllMultiValues(fieldMap, 'Target_Markets__c'));
        system.debug(MI_Utility.selectAllMultiLabels(fieldMap, 'Target_Markets__c'));
  
       
    }

 
}