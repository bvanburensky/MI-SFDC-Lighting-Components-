/* 
 Menorah IC 03/01/2023
 * Class Name - MI_Utility.cls
 * Class Short Description - This class contains misc utility functions
 
 */ 
public  without sharing class MI_Utility {

 


	// AV2 
	// Control reexectution execution of triggers 
	// set is execuited on call 
	// check is exected 
	// Added added BVB 200821 


	public static Map<String, Boolean> alreadyDone = new Map<String, Boolean> ();
	public static boolean isExecuted(String name, boolean showDebug) {

		if (alreadyDone.containsKey(name)) {
			return alreadyDone.get(name);
		}
		return false;

	}
	public static boolean isExecuted(String name) {
		return isExecuted(name, false);
	}

	/* Indicates that a section of code has been executed with the indicated name.
	 */
	public static void setExecuted(String name) {

		alreadyDone.put(name, true);
	}
	public static void setExecuted(string name, boolean isDone) {

		alreadyDone.put(name, isDone);
	}
 
    /*
     * This method returns a True/False value to indicate whether the current instance of Salesforce is a Sandbox
     * instance or not. True = Sandbox instance. 
     * This method is supported by Salesforce Knowledge Article #000331873 at this URL - https://help.salesforce.com/articleView?id=000331873&type=1&mode=1
     * This determines whether the instance is a Sandbox or not without expending a SOQL query.
     * Also supports My Domain.
     */ 
    public Static Boolean isSandbox()
    {

        String host = URL.getSalesforceBaseUrl().getHost();
        String server = host.substring(0,host.indexOf('.'));

        // It's easiest to check for 'my domain' sandboxes first 
        // even though that will be rare
        if(server.contains('--'))
            return true;

        // tapp0 is a unique "non-cs" server so we check it now
        if(server == 'tapp0')
            return true;

        // If server is 'cs' followed by a number it's a sandbox
        if(server.length()>2){
            if(server.substring(0,2)=='cs'){
                try{
                    Integer.valueOf(server.substring(2,server.length()));
                }
                catch(exception e){
                    //started with cs, but not followed by a number
                    return false;
                }

                //cs followed by a number, that's a hit
                return true;
            }
        }

        // If we made it here it's a production box
        return false;
    }
    //End of CPQ2-292
    //

	// CPQ2-1163 consolidate schema methods to use Avalara schema class
	// elimianate overhad of mulitple describe calls when inspecting a single sObject using map
	private static map<string,MI_Schema> mMI_Schemas ; 
	public static boolean isDesign = false;
	// get MI_Schema based object name
	public static MI_Schema getObjectSchema(String sObjectName) {
		if(sObjectName==null){
			return null;
		}
		return MI_Schema.getsObjSchema(sObjectName);  
	}

	// get MI_Schema based on object instance
	public static MI_Schema getObjectSchema(sObject sObj) {
		if (sObj == null) {
			return null;
		}
		return MI_Schema.getsObjSchema(sObj);  
 
	}
 
    // for the passed object returns fields seperated by a  ','
	// helpful for building soql
	public static String getSObjectFields(String sObjectName) {
		MI_Schema sch =getObjectSchema(sObjectName);
		string sObjectFields = '';
		sObjectFields += String.join(sch.strFieldNames, ',');
		return sObjectFields;
 
	}
	// return a map of objects field and labels 
	public static Map<String, String> getSObjectFieldsAndLabels(String sObjectName) {

		return getObjectSchema(sObjectName).rdFieldNameLabel;
 
	}

    //This method accepts the API name of an object and returns the first three digits (called the KeyPrefix)
    //for that object as a string. This can be used for comparison purposes. 
    //Added as part of CPQ2-240
	//1163 updated to MI_Schema
    public static String getObjectPrefix(String sObjectAPIName)    {
		MI_Schema sch =getObjectSchema(sObjectAPIName);
        return sch.rdObject.sObjPrefix;
    }
   
 
    //End of CPQ2-240

    // CPQ2-755 
	/* Utilities to handle string and numeric nulls and defaults 
	  -- avoid referencing a null object  ---
	  also used to creates maps and lists from sObjects  
	  -- done a lot in SF ...
	 */

	public static string getString(decimal val, integer formatScale) {
		if (val == null) {
			return((0.00).setscale(FormatScale)).format();
		}
		return((val.setscale(formatScale))).format();

	}

	public static string getString(object val) {
		if (val != null) {
			return String.Valueof(val);
		}
		return '';
	}

	// return the first non blank element
	public static string getString(object val, object defaultVal) {
		if (val != null && String.Valueof(val).length() > 0) {
			return String.Valueof(val).trim();
		}
		if (defaultVal != null && String.Valueof(defaultVal).length() > 0) {
			return String.Valueof(defaultVal).trim();
		}
		return '';
	}



	/**
	 * @description Get String 
	 * @param testAndReturn string to check
	 * @param defaultVal 
	 * @param leftOrRight where right is a negitive number
	 * @return 
	 */
	public static string getString(object testAndReturn, string defaultVal, integer leftOrRight) {
		string str = getString(testAndReturn, defaultVal);
		 
		if (leftOrRight< 0 && str.length()> Math.abs(leftOrRight)) {
			return str.right(Math.abs(leftOrRight));
		}
		if (leftOrRight > 0 && str.length() > leftOrRight) {
			return str.substring(0, leftOrRight);
		}
		return str;
	}

	// Get Left up to the findstring  
	public static string getString(object testAndReturn, string defaultVal, string findstring) {
		string str = getString(testAndReturn, defaultVal);
		integer inx = str.indexof(findstring);
		if (inx == 0) {
			return str;
		}
		return getString(testAndReturn, defaultVal, 0, inx);
	}

	// get substring with ignore overflow
	public static string getString(object val, string defaultVal, integer ileft, integer length) {
		string str = getString(val, defaultVal);
		if (ileft< 0 || length< 0) {
			return '';
		}
		if (str.length() - 1 <ileft) {
			return '';
		}
		str = str.substring(ileft, (str.length()> (length + ileft)) ? length + ileft : str.length());
		return str;

	}

	// Get a field in an Record for SOQL ie : name , contact__r.name  
	public static string getSObjFld(sobject obj, String fld) {
		string ret = '';
		Fld = Fld.deleteWhitespace();
		string[] flds = Fld.deleteWhitespace().split('[.]');
		// system.debug('Flds ' +flds); 
		try {
			if (flds.size() == 1 && obj.get(Fld) != null) {
				string val = string.valueOf(obj.get(flds[0]));
				return Val;
			}
			if (flds.size() == 2 && obj.getSObject(flds[0]) != null) {
				string val = string.valueOf(obj.getSObject(flds[0]).get(flds[1]));
				return Val;
			}

			if (flds.size() == 3 && obj.getSObject(flds[0]) != null) {
				string val = string.valueOf(obj.getSObject(flds[0]).getSObject(flds[1]).get(flds[2]));
				return Val;
			}
		}
		catch(exception ex) { System.debug('getSObjFld Error on Field ' + fld + ' ' + ex.getMessage()); }
		return ret;
	}

	public static integer getInteger(decimal val, integer defaultVal) {

		if (val == null || val == 0) {
			return DefaultVal;
		}
		try {
			return integer.valueOf(val);
		} catch(Exception ex) { System.debug('Error'); }
		return 0;
		//   return val;    
	}

	public static integer getInteger(string val, integer defaultVal) {
		if (isEmpty(val) || val == '0' || !val.remove('.').remove(',').isNumeric()) {
			return DefaultVal;
		}
		try {
			return integer.valueOf(val);
		} catch(Exception ex) { System.debug('Error'); }
		return 0;
		//   return val;    
	}
	public static integer getInteger(object obj, integer defaultVal) {
		string val = string.valueof(obj);
		if (isEmpty(val) || val == '0' || !val.remove('.').remove(',').isNumeric()) {
			return defaultVal;
		}
		try {
			return integer.valueOf(val);
		} catch(Exception ex) { System.debug('Error'); }
		return 0;
		//   return val;    
	}

	public static boolean isEmpty(object val) {
		if (getString(val).length() == 0) {
			return true;
		}
		return false;
	}
	public static boolean isNotEmpty(object val) {
		return !isEmpty(val);
	}
	public static boolean isEmpty(decimal val) {
		if (val == null || val == 0) {
			return true;
		}
		return false;
	}

	
	public static decimal getDecimal(decimal val, integer defaultVal, integer scale) {
		return getDecimal(val, decimal.valueof(DefaultVal), scale);
	}

	public static decimal getDecimal(decimal val, decimal defaultVal, integer scale) {
		if (val == null) {
			return DefaultVal.setscale(scale);
		}
		return val.setscale(scale);
	}

	public static decimal getDecimal(decimal val, decimal defaultVal) {
		return getDecimal(val, defaultval, 4);
	}
	public static decimal getDecimal(decimal val, decimal defaultVal, boolean setDefaultIfZeroOrNull) {
		if (val == null || (setDefaultIfZeroOrNull && val == 0.00)) {
			return getDecimal(DefaultVal, DefaultVal, 2);
		}
		return getDecimal(val, DefaultVal, 2);
	}
	public static decimal getDecimal(object val, decimal defaultVal) {
		return getDecimal(string.valueof(val), DefaultVal, 2);
	}
	public static decimal getDecimal(string val, decimal defaultVal) {
		if (isEmpty(val)) {
			return getDecimal(DefaultVal, DefaultVal, 2);
		}
		try {
			return getDecimal(decimal.valueOf(val), DefaultVal, 2);
		} catch(Exception ex) { System.debug('Error'); }
		return 0;
		//   return val;    
	}
	public static decimal getDecimal(string val, decimal defaultVal, boolean setDefaultIfZeroOrNull) {
		if (isEmpty(val) || (setDefaultIfZeroOrNull && val == '0')) { //|| !val.remove('.').remove(',').isNumeric()
			val = getstring(DefaultVal, '0');
		}
		try {
			return getDecimal(decimal.valueOf(val), defaultVal, 2);
		} catch(Exception ex) { System.debug('Error'); }
		return 0;
		//   return val;    
	}
	public static decimal getDecimal(string val, decimal defaultVal, integer scale) {
		if (isEmpty(val) || val == '0') {
			return DefaultVal.setscale(Scale);
		}
		try {
			return decimal.valueOf(val).setscale(Scale);
		} catch(Exception ex) { System.debug('Error'); }
		decimal x = ((0.00)).setscale(Scale);
		return x;
		//   return val;    
	}

	public static String selectAllMultiLabels(Map<String, Schema.SObjectField> fieldMap, String picklistAPI){
		String selectAllString = '';
		List<Schema.Picklistentry>fld =fieldmap.get(picklistAPI).getDescribe().getpicklistValues();
		List<String> pickList = new List<String>();
		
		for(Schema.Picklistentry pl : fld){
			selectAllString += pl.getValue()+';';
		}
		return selectAllString;
	}
	
	public static String selectAllMultiValues(Map<String, Schema.SObjectField> fieldMap, String picklistAPI){
		String selectAllString = '';
		List<Schema.Picklistentry>fld =fieldmap.get(picklistAPI).getDescribe().getpicklistValues();
		
		for(Schema.Picklistentry pl : fld){
			selectAllString += pl.getValue()+';';
		}
		return selectAllString; 
	}

}