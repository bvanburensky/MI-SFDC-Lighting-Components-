/*

    * menorah-intc 

	a very exceptional class 
	allows apex to raise errors, and trap errors returning stack traces calls that that makes your catch catchie

	try {
		Schema.getGlobalDescribe().get(sObjectAPIName.trim());
	} catch(Exception ex) {
		throw new MI_Exception('Error on GetDescribe for Object:' + sObjectAPIName,ex);
	}
	--- or maybe you raise the error
  		if(x ==null {
	  		throw new MI_Exception('  x is null so bob is your man from uncle.  '  );
  		}
   or 
		  	MI_Exception.createException('Error') ;
      
          * menorah-intc 
		  

*/

public class MI_Exception extends Exception {
	public static final string orgName = 'SFOrg:' + UserInfo.getOrganizationName() + '\n';

 

	public boolean isFieldWriteSecurityError = false;
	public boolean isFieldReadSecurityError = false;
	public static string trace = '';
	public string traces = ''; 


	public static MI_Exception createException(string message) {
		MI_Exception rdx = new MI_Exception(message);
		return rdx;
	}


	public static string getException(DMLException ex) {
		return GetException(ex, 'DML Error:\n');
	}



	public static MI_Exception createException(DMLException ex) {
		return createException(ex, '');
	}
	public static MI_Exception createException(DMLException ex, string message) {
		string str = GetException(ex, message);
		MI_Exception rdx = new MI_Exception(GetException(ex, message));
		rdx.traces = str;
		rdx.setMessage(str);
		return rdx;
	}
	public static MI_Exception createException(Exception ex) {
		return createException(ex, '');
	}
	public static MI_Exception createException(Exception ex, string message) {
		string str = GetException(ex, message);
		MI_Exception rdx = new MI_Exception(GetException(ex, message));
		rdx.traces = str;
	
		return rdx;

	}

	public static MI_Exception createException(MI_Exception ex) {
		return createException(ex,'');
	}

	public static MI_Exception createException(MI_Exception ex, string message) {
		string str = GetException(ex, message);
		MI_Exception rdx = new MI_Exception(GetException(ex, message));
		rdx.traces = str;
		return rdx;
	}


	public static string getException(DMLException ex, string message) {
		trace = 'Org:' + MI_Exception.OrgName + '\n' + message + '\n';
		trace += ex.getStackTraceString();
		trace += ex.getmessage();
		for (Integer i = 0; i<ex.getNumDml(); i++) {
			if (i> 10) {
				continue;
			}
			trace += ex.getDmlMessage(i) + '\n';

		}
		trace += 'End \n' + MI_Exception.OrgName;
		return trace;
	}

	public static string getException(System.CalloutException ex) {
		return GetException(ex, 'Start CalloutException Error \n');
	}


	public static string getException(Exception ex) {
		return GetException(ex, 'Start Error \n');
	}



	public static string getException(Exception ex, string message) {
		trace = 'SFOrg:' + MI_Exception.OrgName + '\n' + message + '\n';
		trace += 'MSG:' + ex.getmessage() + '\n';
		trace += 'Stack:' + ex.getStackTraceString() + '\n';
		trace += 'End:\n';
		return trace;
	}

	public static string getException(MI_Exception ex, string message) {
		trace = 'SFOrg:' + MI_Exception.OrgName + '\n' + message + '\n';
		trace += 'MSG:' + ex.getMessage() + '\n';
		trace += 'Stack:' + ex.getStackTraceString() + '\n';
		trace += 'End:\n';
		return trace;
	}

}