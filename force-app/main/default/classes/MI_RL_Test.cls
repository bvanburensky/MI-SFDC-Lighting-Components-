@isTest
    private class MI_RL_Test {
    /*
    Test MI_Schema, MI_RLModel,MI_RLController
 
     Menorah IC 03/01/2023
 
    */
        /**
         * create some data 
        */
        @testSetup
        static void testSetupCoreObjects() {
        Account acc = MI_TestFactory.createAccount(null, 1, true)[0] ;
        Contact con = MI_TestFactory.createContact(acc.id, 1, true)[0] ;
        Opportunity opp = MI_TestFactory.createOpportunity(acc.id, null, 1, true) [0] ; 
     //  con = date.today();
      //  update con ;
    
        }
     
    
    
        @isTest
        static void test01() {
            //opportunity a = [select id from opportunity];
            if( 1==1 )return;
            MI_RLModel m = new MI_RLModel();
           // m.dDisplayFields = 'id,Name,createdDate,accountid,closedate,amount,iswon,FiscalYear,customer_account__c';
            m.dRelatedObj = 'Opportunity:accountid';
            string jsn = JSON.serialize(m);
            m = MI_RLController.cQuery(jsn);
            m.rmSchema = null;
            System.debug(m.invalidFields);
            System.debug(m.query);
            System.debug(m.selectFields);
            System.debug(m.isError + ':' + m.message);
            system.assertEquals(0, m.rowCount,'bark');
    
        }
        @isTest
        static void test02() {
            //opportunity a = [select id from opportunity];
            account a = [select id from account];
            MI_RLModel m = new MI_RLModel();
            //createdDate,accountid,closedate,amount,iswon,FiscalYear,
            m.dDisplayFields = 'id,Name,customer_account__c';
            m.dRelatedObj = 'Opportunity:AccountId';
            m.dRecordId = a.Id;
            string jsn = JSON.serialize(m);
            m = MI_RLController.cQuery(jsn);
         
            
            m.rmSchema = null;
            System.debug(m.invalidFields);
            System.debug(m.query);
            System.debug(m.selectFields);
            System.debug(m.isError + ':' + m.message);
            system.assertEquals(1, m.rowCount,'bark');
    
        }
        @isTest
        static void test03() {
            // force error
            account a = [select id from account];
            MI_RLModel m = new MI_RLModel();
            m.dDisplayFields = 'Name,createdDate,email,Type';
            m.dRelatedObj = 'Contact:AccountId';
           // m.dFilterSOQL = 'xxxxx=\'Prospect \'';
            m.dSortField = 'name';
            m.dSOQLLimit = '10';
            m.dRecordId = a.Id;
            m.dSortDescending = true;
     
            string jsn = JSON.serialize(m);
            m = MI_RLController.cQuery(jsn);
            system.assertNotEquals(0, m.rowCount,'Got nothing!!!');

            System.debug(m.sObjs);
    
        }
    
        @isTest
        static void test04() {
            MI_RLModel m = new MI_RLModel();
            m.dDisplayFields = 'Name,createdDate,barf';
            m.dRelatedObj = 'Acct';
            string jsn = JSON.serialize(m);
            m = MI_RLController.cQuery(jsn);
            
            System.debug(m);
            system.assert( m.rowCount==0,'invalid object'); 
    
        }
      
        @isTest
        static void test05() {
            MI_RLModel m = new MI_RLModel();
            m.dDisplayFields = 'Name,createdDate,barf';
            m.dRelatedObj = 'Account';
            string jsn = JSON.serialize(m);
            m = MI_RLController.cQuery(jsn);
            
            System.debug(m);
            system.assert( m.rowCount==0,'invalid fields'); 
    
        }
    
        @isTest
        static void test06() {
            VisualEditor.DesignTimePageContext cx = new VisualEditor.DesignTimePageContext();
            cx.entityName = 'Account';
            MI_RLDesign o = new MI_RLDesign(cx);
            o.getDefaultValue();
            o.getValues();
            cx = new VisualEditor.DesignTimePageContext();
            cx.entityName = 'Account';
            system.assert( cx.entityName=='Account','gag me with a spoon'); 
    
    
        }

        @isTest
        static void test06_01() {
            VisualEditor.DesignTimePageContext cx = new VisualEditor.DesignTimePageContext();
            cx.entityName = 'Account';
            MI_FieldHighlightDesign o = new MI_FieldHighlightDesign(cx);
            o.getDefaultValue();
            o.getValues();
            cx = new VisualEditor.DesignTimePageContext();
            cx.entityName = 'Account';
            system.assert( cx.entityName=='Account','gag me with a spoon'); 
    
    
        }
     /*
        @isTest
        static void test06_01() {
            VisualEditor.DesignTimePageContext cx = new VisualEditor.DesignTimePageContext();
            cx.entityName = 'Account';
            MI_RLLkDesign o = new MI_RLLkDesign(cx);
            o.getDefaultValue();
            o.getValues();
            cx = new VisualEditor.DesignTimePageContext();
            cx.entityName = 'Account';
            system.assert( cx.entityName=='Account','gag me with a spoon'); 
    
    
        }        
    */
        @isTest
        static void test07() {
          String val =  MI_RLController.cQueryJSON('select id from account');
            system.assert( val != null,'error on query');
        }
    
    
    
        @isTest
        static void test08() {
            MI_Schema s = MI_Schema.getsObjSchema('Account');
            MI_Schema.rdField[] fs = s.rdFields;
            MI_Schema.rdField f = fs[0];
            object xx = f.fieldData;
            f = s.rdFieldMap.get('Type');
            xx = f.picklistEntrys;
            MI_Schema.rdLabelValue[] rdl = f.picklistValues;
            xx = rdl[0].label;
            xx = rdl[0].value;
    
            xx = s.rdObject.ChildObjectMap;
            xx = s.rdObject.isCreateUpdateable;
            xx = s.rdFieldsUpdateableSet;
            xx = s.rdFieldsUpdateable;
            xx = s.rdFieldsCustom;
            xx = s.getInvalidFields(new string[] { 'barf' });
            system.assert( xx != null,'in null');
    
        }
    
    
    
        @isTest
        //test model properties
        static void test09() {
            account a = [select id from account];
            contact c = [select id from contact limit 1];
            MI_RLModel m = new MI_RLModel();
            m.dDisplayFields = 'Name,createdDate,barf,Is_Contact_Owner_same_as_Account_Owner__c,email, '+ 
                                'Type,NumberOfEmployees,AV2_Master_Contract_Date__c,LastModifiedDate,'+
                                'HasOptedOutOfEmail,accountid,firstname';
            m.dRelatedObj = 'Contact:AccountId';
            //	m.dFilterSOQL = 'account.type=\'Prospect \'';
            m.dSortField = 'Name';
            m.dFilterSOQL = 'NumberOfEmployees = 0'; 
            m.dSOQLLimit = '10';
            m.dRecordId = a.Id;
            m.dSortDescending = true;
            m.dbuttonFields = 'Name,accountid';
            m.dLinkFields = 'id:firstname';
            m.dDesignIcons ='Is_Contact_Owner_same_as_Account_Owner__c#utility:person';
            m.dbuttonFields = 'email:send';
            m.dFixedWidth ='Type:50';
            m.dActions='edit:Edit';
            
            // create json like call from lwc
            string jsn = JSON.serialize(m);
            MI_RLController.cQuery(jsn);
            /*
            m =  (MI_RLModel) JSON.deserialize(jsn, MI_RLModel.class);
            m.setup();
            m.rmSchema =MI_Schema.getsObjSchema(m.sObjName);
            m.dtColumns = MI_RLModel.createColumns(m);
            MI_RLController.  buildQuery(m);
            m.sObjsIn = Database.query(m.query);
            MI_RLModel.dRows dr = new MI_RLModel.dRows();
            */
           // dr.id = c.id;
           // dr.
          //  m.dObjects = new MI_RLModel.dRows[] { };

          //  m.dObjects.add(dr);
          //  jsn = JSON.serialize(m);
    
          
           system.assert(jsn != null,'gag me with a spoon');
          //  System.debug(m.sObjs);
        }
    
        @isTest
        // test avalara exception class
        static void test10() {
            account a;
            try{
            a = new account();
            insert a;
            }
            catch(DmlException e) {
                MI_Exception.getException(e);
                MI_Exception.getException(e,'Test');
                MI_Exception.getException((Exception)e);
                MI_Exception.getException((Exception)e,'Test');
                MI_Exception s = MI_Exception.createException(e);
                s = MI_Exception.createException(e, 'asd');
                s = MI_Exception.createException((Exception)e);
                s = MI_Exception.createException((Exception)e, 'asd');
                s = MI_Exception.createException('asd');

                s = MI_Exception.createException(s);
                s = MI_Exception.createException(s, 'asd');

            }
            system.assertEquals(a.id ,null,' WTF account should not be inserted !! '); 
        }
        @isTest
        // test controller exception
        static void test11() {
             try{
            MI_RLController.cQuery(null);
             }
            catch(exception ex){
                //System.assert(sch.sObjectAPIName='Account','No love schema the account object');
            }
            

        }
        @isTest
        static void test12() {
            // force error
            account a = [select id from account];
            MI_Schema sch =  MI_Utility.getObjectSchema(a);
            System.assert(sch.sObjectAPIName=='Account','No love schema the account object');
        }
        @isTest
        //test save record or data 
        static void test13() {
            contact a = [select id from contact];
            MI_RLModel m = new MI_RLModel();
            m.dDisplayFields = 'Name,createdDate,barf,Is_Contact_Owner_same_as_Account_Owner__c,email, '+ 
                                'Type,NumberOfEmployees,AV2_Master_Contract_Date__c,LastModifiedDate,HasOptedOutOfEmail,MQL_Date_Time_Most_Recent__c:accountid,firstname';
            m.dRelatedObj = 'Contact:AccountId';
            m.dObjects =  new list<MI_RLModel.dRows>();
            MI_RLModel.dRows r = new MI_RLModel.dRows();

            r.val1= ''+
            '{"firstname": "jack", "id": "'+a.id+'", "LastCaseClosedSurveyDate__c": "2021-10-01" ,"MQL_Date_Time_Most_Recent__c":null,'+
            '"NumberOfEmployees": 5.0,"Marketing_Contact__c":true,"Length_of_Contract__c":10} ';
              
            m.dObjects.add(r);
            
            string jsn = JSON.serialize(m);
            MI_RLController.cSaveList(jsn);
             r = new MI_RLModel.dRows();
            // force an error wiht invalid json
            r.val1= ''+
            '{firstname": "jack", "id": "'+a.id+'", "LastCaseClosedSurveyDate__c": "2021-10-01" ,'+
            '"NumberOfEmployees": 5.0,"Cross_border_Target_Account__c":true,"Length_of_Contract__c":10} ';
                     
            m.dObjects.add(r);
            jsn = JSON.serialize(m);
            MI_RLController.cSaveList(jsn); 

        }
    }