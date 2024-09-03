/* 
 Menorah IC 03/01/2023
  Related List Controller 
Called By DataInnovations Related List Aura Component to build json class to feed sFDC data table
 
 Menorah IC 03/01/2023
 
  
*/
public with sharing class MI_RLController {

	@AuraEnabled
	public static MI_RLModel cQuery(string dModel) {
		MI_RLModel m = (MI_RLModel) JSON.deserialize(dModel, MI_RLModel.class);
 
		try {
			m.setup();
			if (m.sObjName == null || (!m.dIsBaseObject && m.lookupField == null)) {
				m.isError = true;
				m.Message = 'Related Object or Lookup field not defined';
				return m;
			}


			m.rmSchema =  MI_Schema.getsObjSchema(m.sObjName);
			m.invalidFields = m.rmSchema.getInvalidFields(m.selectFields);
			m.dtColumns = MI_RLModel.createColumns(m);
			m.dfilterSOQL = MI_Utility.getString(m.dfilterSOQL, ''); // .toLowerCase();
			m.dsortField = MI_Utility.getString(m.dsortField, '').toLowerCase();
			m.dRecordId = MI_Utility.getString(m.dRecordId, '');
			buildQuery(m);
			if (m.query.length() > 0 && (m.dIsBaseObject || m.dRecordId.length() > 0)) {
				m.sObjsIn = Database.query(m.query);
				//		for(SObject s:m.sObjs){
				//	}

			} 
			else {
				m.isError = true;
				m.Message = 'No Select Fields entered or invalid lookup Record id for: ' + m.lookupField;
				m.Message += '\n recordId' + m.dRecordId;
				m.Message += '\n Query :' + m.query;
				m.Message += '\n IsBaseObject :' + m.dIsBaseObject;


			}
			m.trace = 'Query(' + m.query + ' )\n ';
			m.trace += 'ColumnFields:' + m.columnFields + ' \n';
			m.trace += 'Data:' + m.sObjs + ' \n';

			m.trace += 'DataTable Columns: </br>' + JSON.serializePretty(m.dtColumns.columns);

		}
		catch(DmlException ex) {
			m.isError = true;
			m.Message = 'DML Error in MI_RLController.query:\n(' + m.query + ' )\n' + MI_Exception.getException(ex);
		}
		catch(Exception ex) {
			m.isError = true;
			m.Message = 'Error in rdxRLController.query:\n(' + m.query + ' )\n' + MI_Exception.getException(ex);
		}
		 
 		return m;
	}


	@AuraEnabled
	public static string cQueryJSON(String soql) {
		return JSON.serialize(Database.query(soql));
	}

	static MI_RLModel buildQuery(MI_RLModel m) {
		try {
			m.query = '';
			if (m.selectFields.size() > 0) {
				string sql = 'select ';
				sql += String.join(m.selectFields, ',');

				sql += ' from ' + m.sObjName;
				if (!m.dIsBaseObject) {
					sql += ' where ' + m.lookupField + ' = ' + '\'' + m.dRecordId + '\'';
				}
				else {
					sql += ' where createdDate != null ';

				}

				if (m.dFilterSOQL.length() > 5) {
					sql += ' and ( ' + m.dfilterSOQL + ' )';
				}

				if (m.dSortField != null && m.selectFields.contains(m.dSortField)) {
					sql += ' Order by ' + m.dSortField;
					if (m.dSortDescending != null && m.dSortDescending) {
						sql += ' Desc';
					}
				}
				System.debug('Sql ' + sql);
				if (MI_Utility.getInteger(m.dSOQLLimit, 0) > 0) {
					sql += ' limit ' + m.dSOQLLimit;
				}

				sql += ' ';

				m.query = sql;
			}
		}
		catch(Exception ex) {
			m.isError = true;
			m.Message = 'Error ACController.query:' ;
			m.message += MI_Exception.getException(ex);
		}
		return m;
	}
 
	@AuraEnabled
	public static MI_RLModel cSaveList(string dModel) {
		string trace = 'dModel:' + dModel + '\n';
		MI_RLModel m = (MI_RLModel) JSON.deserialize(dModel, MI_RLModel.class);
		try { 
		System.debug(m.dObjects);
		Map<String, object> jMap = (Map<String, object>) JSON.deserializeUntyped(dModel);
		List<object> rows = (List<object>) jMap.get('dObjects');
		if (rows.size() == 0) {
			return m;
		}
		string relatedObj = m.dRelatedObj.split(':') [0].trim();
		System.debug(relatedObj);
		MI_Schema sch =  MI_Schema.getsObjSchema(relatedObj);
		sObject[] sObjs = new sObject[] { };
		for (object row : rows) {
			sObject obj = sch.newSObject(); 
			Map<String, object> mp = (Map<String, object>) row;
			for (string ky : mp.keySet()) {
				MI_Schema.rdField f = sch.rdFieldMapLC.get(ky.toLowerCase());
				if (f == null) {
					continue;
				}
				System.debug('rdField :' + f);
                 
				trace += ' Row : Field Type:' + f.fieldType + ' ddType:' + f.ddType  +   '\n';
				trace += ' Value :' + mp.get(ky) + '\n';

				if (Schema.DisplayType.DOUBLE == f.ddType ||
				   Schema.DisplayType.CURRENCY == f.ddType ||
				   Schema.DisplayType.PERCENT == f.ddType) {
					if( mp.get(ky)==null || mp.get(ky)=='') {
						obj.put(ky,null);
					}else {
						obj.put(ky, MI_Utility.getDecimal(mp.get(ky), 0));			
					}	
				} else if (Schema.DisplayType.DATE == f.ddType) {
					if( mp.get(ky)==null || mp.get(ky)=='') {
						obj.put(ky,null);
					}else {
					 string dTmp = ((string) mp.get(ky)).split('T') [0];
					 obj.put(ky, Date.valueOf(dTmp));
					}
				} else if (Schema.DisplayType.BOOLEAN == f.ddType) {
					Boolean b = Boolean.valueOf(mp.get(ky)); // (((string) mp.get(ky)).toLowerCase()) == 'true';  string.va
					obj.put(ky, b);
				}
				else {
					obj.put(ky, mp.get(ky));
				}
				System.debug(ky);
			}
			sObjs.add(obj);
		}
		System.debug('You updated:' + sObjs);
		update sObjs;
		}
		catch(Exception ex) {
			m.isError = true;
			m.Message = 'Update Error:' ;  
			m.message += MI_Exception.getException(ex);
			m.message += trace;

		}
		return m;
	}
}