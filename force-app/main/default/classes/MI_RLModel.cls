/* 
 Menorah IC 03/01/2023
  Related List Model
Builds a SFDC Datatable model to return to to the DataInnovations Related list component / Datatable
Attributes configured design time and exported in this model documented for the datatable in  https://developer.salesforce.com/docs/component-library/bundle/lightning:datatable
Bvb 08/31/2021


*/


public class MI_RLModel {
	public MI_RLModel() {
		setup();
	}
	public void setup() {
		invalidFields = new String[] { };
		relatedFields = new String[] { };
	 
		mSelectFields = new String[] { };
		dEditableFields = dEditableFields == null ? '' : dEditableFields;
		dIsBaseObject = dIsBaseObject == null ? false : dIsBaseObject;
		rowCount = 0;
		// this comes in in the form of sObject:LookupField ==  Contact:AccountId
		if (dRelatedObj != null) {
			string[] parts = dRelatedObj.deleteWhitespace().split(':');
			if (parts.size() > 0) {
				sObjName = parts[0].trim();
			}
			if (parts.size() > 1) {
				lookupField = parts[1].trim();
			}
		}
	}

	/* Design Time Imputs */

	@AuraEnabled public boolean dIsBaseObject { get; set; }
	@AuraEnabled public string dRecordId { get; set; }
	@AuraEnabled public string dRelatedObj { get; set; }
	@AuraEnabled public string dEditableFields { get; set; }
	@AuraEnabled public string dSortField { get; set; }
	@AuraEnabled public boolean dSortDescending { get; set; }
	@AuraEnabled public string dFilterSOQL { get; set; }
	@AuraEnabled public string dDisplayFields { get; set; }
	@AuraEnabled public string dSOQLLimit { get; set; }
	@AuraEnabled public string dLinkFields { get; set; }
	@AuraEnabled public string dbuttonFields { get; set; }
	@AuraEnabled public string dDesignIcons { get; set; }
	@AuraEnabled public string dFixedWidth { get; set; }
	@AuraEnabled public string dLabelOverrides{ get; set; }
	@AuraEnabled public string dActions { get; set; }
 
	

	@AuraEnabled public dRows[] dObjects { get; set; }


 
	/* Returned Data */
	@AuraEnabled public RowsModel sObjs { get {
			//		System.debug(dataTable.selectFields);
			rowCount = (sObjsIn == null ? 0 : sObjsIn.size());
			RowsModel s = new RowsModel(sObjsIn, this);
			return s;
		} }

	@AuraEnabled public string message { get; set; }
	@AuraEnabled public boolean isError { get; set; }
	@AuraEnabled public string query { get; set; }
	@AuraEnabled public string trace { get; set; }
	@AuraEnabled public ColumnsModel dtColumns { get; set; }
	@AuraEnabled public integer rowCount { get; set; }
	@AuraEnabled public string sObjName { get; set; }
	@AuraEnabled public string sObjLabel { get; set; }



	/* APEX populated */
	/* note :all field names changed to lower case */

	public sObject[] sObjsIn { get; set; }
	public MI_Schema rmSchema { get; set; }
	public string lookupField { get; set; }
	public string[] invalidFields { get; set; }
	public string[] relatedFields { get; set; }
	public string[] mSelectFields { get; set; }


 
	/**
	 * @description ColumnsModel   
	 * builds data table columns 
	 * @param MI_Schema = this 
	 * @return ColumnsModel
	 */
	public static ColumnsModel createColumns(MI_RLModel am) {

		MI_Schema schm = am.rmSchema;
		am.sObjLabel = schm.rdObject.labelPlural;
		string[] datacolumns = am.columnFields;

		ColumnsModel m = new ColumnsModel();

		ColumnModel c;
		integer ccnt = - 1;

		for (string d : datacolumns) {
			ccnt++;
			if (d.length() < 2) {
				continue;
			}
			c = new ColumnModel();
			//	c.isFirstField = ccnt ==0;
			if (!schm.rdFieldMapLC.containsKey(d)) {
				c.label = 'INVALIDFIELD';
				c.fieldName = d;
				continue;
			}
			MI_Schema.rdField f = schm.rdFieldMapLC.get(d);
		 	c.editable = am.dEditableFields.containsIgnoreCase(f.fieldName);
			c.label = f.fieldLabel;
 		
			c.fieldName = f.fieldName.toLowerCase();
			if(am.labelOverrides.containsKey(c.fieldName)){
			 c.label = am.labelOverrides.get(c.fieldName);
			} 
			//			
			c.schType = (ccnt == 0 ? 'url' : f.fieldType.toLowerCase());
			c.schType = (am.linkFields.containsKey(d) ?'url' : c.schType);
			// field and icon field are valid
			c.typeAttributes.tooltip.fieldName = c.fieldName + '_label';
        	//c.isLinkField = linkFields.contains(d);
			if ( (c.type == 'url' || am.linkFields.containsKey(d) ) && (c.schType != 'reference')) {
				c.typeAttributes.label.fieldName = c.fieldName + '_label';
				if (am.linkFields.containsKey(d)) {
					c.typeAttributes.linkId = schm.rdFieldMapLC.get(am.linkFields.get(d)).fieldName.tolowercase();
					//c.schType ='url';
				}
				if(c.fieldName == 'Name') {
				 	c.label = 'Name';

				}
				else {
				//	c.typeAttributes.label.fieldName = c.fieldName + '_label';
				}
				
				c.typeAttributes.target = '_parent';
				c.typeAttributes.variant = 'base';
				c.typeAttributes.name = 'view';
				c.typeAttributes.title = 'view';
				c.typeAttributes.classValue = 'slds-truncate';
				c.typeAttributes.iconName = null;
				c.typeAttributes.iconPosition = null;
				//	c.cellAttributes=null;

			}
			if (c.type == 'url' && c.schType == 'reference') {
				// accountid || custom__c
				c.relatedFieldName = f.referenceTo;
				MI_Schema relatedFieldSchena =MI_Schema.getsObjSchema(c.relatedFieldName);
				string fldWork = c.fieldName;
				if (fldWork.endsWith('__c')) {
					fldWork = fldWork.left(fldWork.length() - 3) + '__r';
				}
				fldWork = fldWork.removeEnd('id');
				if(relatedFieldSchena.rdFieldMapLC.containsKey('name')) {
					c.relatedFieldName = fldWork  +'.'+'name';
					}else {
				c.relatedFieldName = fldWork  +'.'+ relatedFieldSchena.rdIdNameField[0].fieldName;
				}

				am.relatedFields.add(c.relatedFieldName);
				System.debug('Related Field Name-------------------------' + c.relatedFieldName);

				c.typeAttributes.label.fieldName = fldWork   + '_label';
				c.typeAttributes.tooltip.fieldName = fldWork   + '_label';
				c.typeAttributes.linkId = c.fieldName.toLowerCase();
				c.typeAttributes.target = '_parent';
				c.typeAttributes.variant = 'base';
				c.typeAttributes.name = 'view';
				c.typeAttributes.title = 'view';
				c.typeAttributes.classValue = 'slds-truncate';
				c.typeAttributes.iconName = null;
				c.typeAttributes.iconPosition = null;
				c.isRefOnly = am.linkFieldRef.contains(c.fieldName);
				if(c.isRefOnly){
					c.typeAttributes.classValue = 'slds-hide';
				}
				//	c.cellAttributes=null;

			}
			if (f.fieldType == 'date' && c.schType == 'Date') {
//				c.typeAttributes.month = 'UTC';
			 	c.typeAttributes.month ='2-digit';
			 	c.typeAttributes.day ='2-digit';
			 
 
			}
			// here we are forcing a checkbox
		 	c.isDesignIcon = am.designIconFields.containsKey(c.fieldName) && schm.rdFieldMapLC.containsKey(c.fieldName);

			// here we are using a sfdc field for the 'utility:icon value' id get returns u_xxxIcon__c
			if (c.isDesignIcon) {
				c.cellAttributes.iconName.fieldName =  c.fieldName +'_icon' ; // ; am.designIconFields.get(c.fieldName) +'_icon');
				c.cellAttributes.iconName.icon = am.designIconFields.get(c.fieldName);
				c.cellAttributes.iconPosition = 'right';
			}
 
			if (c.schType == 'boolean') {
			//  c.cellAttributes.iconName.fieldName = c.fieldName + '_chk';
			//  c.cellAttributes.iconPosition = 'left';
			//  c.cellAttributes.label.fieldName = c.fieldName + '_label';
			// c.cellAttributes = null;

			 	c.typeAttributes = null;
				//	c.label = null;
			}
			if (am.buttonFields.containsKey(c.fieldName)) {
				c.typeAttributes.label.fieldName = c.fieldName + '_btnLabel'; //am.buttonFields.get(c.fieldName);
				//	c.typeAttributes.linkId = null;
				// 	c.typeAttributes.variant = 'Neutral';
				//	  c.typeAttributes.iconName = new SubAttributesModel();
				//		c.typeAttributes.iconName.fieldName = c.fieldName + '_btnIcon'; 
				c.typeAttributes.tooltip.fieldName = c.fieldName + '_label';

				c.schType = 'button';
				c.typeAttributes.title = am.buttonFields.get(c.fieldName);
				c.typeAttributes.name = am.buttonFields.get(c.fieldName);
				//c.typeAttributes.value = am.buttonFields.get(c.fieldName);
			}
			if (c.cellAttributes.iconPosition == null) {
				c.cellAttributes = null;
			}
			c.fixedWidth = null;
			if (am.fieldWiths.containsKey(c.fieldName)) {
				c.fixedWidth =  am.fieldWiths.get(c.fieldName);
			}
			m.columns.add(c);
			//	System.debug(c);
		}
		if (am.actions.size() > 0) {
		     c = new ColumnModel();
			c.schType = 'action';
			c.label = null;
			c.typeAttributes.rowActions = am.actions;
			m.columns.add(c);
		}
	 
		return m;
	}


	/**
	 * Columns Data Model  
	 * THis and othe object generate model per 
	 *  https://developer.salesforce.com/docs/component-library/bundle/lightning:datatable/documentation
	 */
	public class ColumnsModel {

		public ColumnsModel() {
			columns = new ColumnModel[] { };
		}
		@AuraEnabled
		Public ColumnModel[] columns { get; set; }
		// Public string[] selectFields { get; set; }

	}
	public class ColumnModel {
		public ColumnModel() {
			label = 'Name';
			fieldName = 'Name';
			typeAttributes = new AttributesModel(); // { };
			cellAttributes = new AttributesModel(); // { };
		}
		@AuraEnabled Public string schType { get; set; }
		@AuraEnabled public string label { get; set; }
		@AuraEnabled public string fieldName { get; set; }
		@AuraEnabled public string relatedFieldName { get; set; } 
		@AuraEnabled public string relatedFieldObject { get; set; }
     
	//	public MI_Schema relatedFieldSchena { get; set; }

		@AuraEnabled public Integer fixedWidth { get; set; }
		@AuraEnabled public boolean isFirstField { get; set; }
		@AuraEnabled public boolean isDesignIcon { get; set; }
		@AuraEnabled public string initialWidth { get; set; }
		@AuraEnabled public string actions { get; set; }
		@AuraEnabled public string iconName { get; set; }
		@AuraEnabled public boolean editable { get; set; }
		@AuraEnabled public AttributesModel typeAttributes { get; set; }
		@AuraEnabled public AttributesModel cellAttributes { get; set; }
		@AuraEnabled public boolean isRefOnly { get; set; }		
		@AuraEnabled
		public MI_Schema.rdField rdField { get; set; }
		@AuraEnabled Public boolean sortable { get {
				return true; //type != 'url';
			} }
		@AuraEnabled Public string type { get {

				if (schType == 'action') {
					return 'action';
				}
				if (schType == 'id' ||
				    schType == 'url') {
					return 'url';
				}

				if (schType == 'button') {
					return 'button';
				}
				if (schType == 'reference') {
					return 'url';
				}

				if (
				    schType == 'string' ||
				    schType == 'id') {
					return 'text';
				}
				if (schType == 'CURRENCY') {
					return 'currency';
				}
				if (schType == 'Date') {
					return 'date-local';
				}
				if (schType == 'Datetime') {
				return 'date-local';
				}				
				if (schType == 'email' ||
				    schType == 's') {
					return 'email';
				}
				if (schType == 'phone' ||
				    schType == 's') {
					return 'phone';
				}
				if (schType == 'number' ||
				    schType == 'integer' ||
				    schType == 'decimal' ||
				    schType == 'double'  ||
				    schType == 'percent' 
				) {
					return 'number';
				}
				if (schType == 'boolean' || 
				    schType == 's') {
					return 'boolean';
				}
				return 'text';

			} }

	}

 
	Public class AttributesModel {

		public AttributesModel() {
			iconName = new SubAttributesModel();
			label = new SubAttributesModel();
			tooltip = new SubAttributesModel();

		}
		@AuraEnabled public SubAttributesModel iconName { get; set; }
		@AuraEnabled public string iconPosition { get; set; }
		@AuraEnabled public string l_label { get; set; }
		@AuraEnabled public SubAttributesModel label { get; set; }
		public map<String, string> actions { get; set; }
		@AuraEnabled public SubAttributesModel[] rowActions { get; set; }

		@AuraEnabled public string title { get; set; }
		@AuraEnabled public string timeZone { get; set; }
		@AuraEnabled public string month { get; set; }
		@AuraEnabled public string day { get; set; }
		@AuraEnabled public string variant { get; set; }
		@AuraEnabled public string target { get; set; }
		@AuraEnabled public SubAttributesModel tooltip { get; set; }
		@AuraEnabled public string urladdress { get; set; }
		@AuraEnabled public string name { get; set; }
		@AuraEnabled public string value { get; set; }
		// changed to class in component
		@AuraEnabled public string classValue { get; set; }
		@AuraEnabled public string linkId { get; set; }
		

	}

	Public class SubAttributesModel {
		@AuraEnabled public string fieldName { get; set; }
		@AuraEnabled public string name { get; set; }
		@AuraEnabled public string label { get; set; }
		// utility:person
		@AuraEnabled public string icon { get; set; }


	}



	// select fields for SOQL
	public string[] selectFields { get {

			set<string> flds = new Set<string> ();
			flds.add('id');
			flds.addall(columnFields);
			flds.addall(designIconFields.keySet());
			flds.addall(designIconFields.values());
			flds.addall(linkFields.keySet());
			flds.addall(linkFields.values());
			flds.addall(buttonFields.keySet());
			flds.addall(MI_Utility.getString(deditableFields, '').toLowerCase().deleteWhitespace().replace(',,', ',').split(','));
			flds.addall(MI_Utility.getString(dsortField, '').toLowerCase().deleteWhitespace().replace(',,', ',').split(','));
			flds.addall(relatedFields);
			flds.removeAll(invalidFields);
			for (string s : flds) {
				s = s.toLowerCase();
			}
			mSelectFields = new List<string> (flds);
			return mSelectFields;

		} }

	set<string> lColumnFields;
	@AuraEnabled
	public string[] columnFields { get {
			if (lColumnFields == null) {
				lColumnFields = new set<string> ();
				//		lColumnFields.add('id');
				lColumnFields.addall(MI_Utility.getString(ddisplayFields, '').toLowerCase().deleteWhitespace().replace(',,', ',').split(','));
			}
			return new List<string> (lColumnFields);
		} }
	map<string, integer> lFieldWiths;
	@AuraEnabled
	public map<string, integer> fieldWiths { get {
			if (lFieldWiths == null) {
				Set<string> flds = new Set<string> ();
				lFieldWiths = new map<String, integer> ();
				//		lColumnFields.add('id');
				flds.addall(MI_Utility.getString(dFixedWidth, '').deleteWhitespace().toLowerCase().replace(',,', ',').split(','));
				for (string s : flds) {
					string[] vals = s.split(':');
					if (vals.size() == 2) {
						Integer i = MI_Utility.getInteger(vals[1], 0);
						if (i > 0) {
							lFieldWiths.put(vals[0], i);
						}
					}
				}
			}
			return(lFieldWiths);
		} }
	// Link Fields
	map<string, string> llinkFields;
	set<String> lllinkFieldRef;
	@AuraEnabled
	public map<String, string> linkFields { get {
			if (llinkFields == null) {
				llinkFields = new map<String, string> ();
				lllinkFieldRef = new set<string>();
				Set<string> flds = new Set<string> ();
				flds.add('name:id');
				flds.addall(MI_Utility.getString(dLinkFields, '').deleteWhitespace().toLowerCase().replace(',,', ',').split(','));
				for (string s : flds) {
					if (s.split(':').size() == 2) {
						llinkFields.put(s.split(':') [0], s.split(':') [1]);
					}
				}
				lllinkFieldRef.addAll(llinkFields.values());
			}
			return(llinkFields);
		} }
		@AuraEnabled
		public set<String> linkFieldRef { get {
			if(linkFields != null) {
	 		  return lllinkFieldRef ;
			}
		return null; 
		}}
		 


	map<string, string> llabelOverrides;
	@AuraEnabled
	public map<String, string> labelOverrides { get {
			if (llabelOverrides == null) {
				llabelOverrides = new map<String, string> ();
				Set<string> flds = new Set<string> ();
				flds.add('name:id');
				flds.addall(MI_Utility.getString(dlabelOverrides, '').deleteWhitespace().replace(',,', ',').split(','));
				for (string s : flds) {
					if (s.split(':').size() == 2) {
						llabelOverrides.put(s.split(':') [0].toLowerCase(), s.split(':') [1]);
					}
				}
			}
			return(llabelOverrides);
		} }
	map<string, string> lbuttonFields;
	//@AuraEnabled
	public map<String, string> buttonFields { get {
			if (lbuttonFields == null) {
				lbuttonFields = new map<String, string> ();
				Set<string> flds = new Set<string> ();
				//	flds.add('name:id');
				flds.addall(MI_Utility.getString(dbuttonFields, '').deleteWhitespace().replace(',,', ',').split(','));
				for (string s : flds) {
					if (s.split(':').size() == 2) {
						lbuttonFields.put(s.split(':') [0].toLowerCase(), s.split(':') [1]);
					}
				}
			}
			return(lbuttonFields);
		} }

	SubAttributesModel[] lactions;
	map<string, string> xactions;
	//@AuraEnabled
	public SubAttributesModel[] actions { get {
			if (xactions == null) {
				lactions = new SubAttributesModel[] { };
				SubAttributesModel sub;
				xactions = new map<String, string> ();
				Set<string> flds = new Set<string> ();
				//	flds.add('name:id');
				flds.addall(MI_Utility.getString(dActions, '').deleteWhitespace().replace(',,', ',').deleteWhitespace().split(','));
				for (string s : flds) {
					if (s.split(':').size() == 2) {
						xactions.put(s.split(':') [0].toLowerCase(), s.split(':') [1]);
						sub = new SubAttributesModel();
						sub.name = s.split(':') [0];
						sub.label = s.split(':') [1];
						lactions.add(sub);
					}
				}
			}
			return lactions;
		} }


	/**
	 * @description input  field__c:u_flds__c
	 */

	map<string, string> lDesignIcons;
	@AuraEnabled
	public map<string, string> designIconFields { get {
			if (lDesignIcons == null) {
				set<string> flds = new Set<string> ();
				lDesignIcons = new map<String, string> ();
				flds.addall(MI_Utility.getString(dDesignIcons, '').toLowerCase().deleteWhitespace().replace(',,', ',').split(','));
				for (string s : flds) {
					if (s.split('#').size() == 2) {
						lDesignIcons.put(s.split('#') [0], s.split('#') [1]);
					}
				}
			}
			return(lDesignIcons);
		} }
 
	// Create Row Data 
	// Cannot use sObjects as it does not support related fields on the JSON return
	public class RowsModel {

		public RowsModel(sObject[] sObjs, MI_RLModel rml) {

			rows = new object[] { };
			if (sObjs != null) {

				for (sObject sOb : sObjs) {

					rows.add(getRow(sOb, rml));
				} }
		}
		@AuraEnabled
		Public object[] rows { get; set; }

		Map<String, object> getRow(sObject s, MI_RLModel rml) {
			Map<String, object> row = new Map<String, object> ();
			row.put('id', s.id);
			//Map<String, object> oFlds = s.getPopulatedFieldsAsMap();
		
			for (ColumnModel c : rml.dtColumns.columns) {
				//MI_RLModel.ColumnModel cm = rml.dtColumns.columns. ;
				string key = c.fieldName;
				object o = MI_Utility.getSObjFld(s, key);
				if (key.length() > 0) {
					row.put(key, o);
					row.put(key + '_label', o);
				 	if (c.schType == 'boolean') {
				 		//row.put(key + '_chk', Boolean.valueOf(o) ? 'utility:check' : '');
				 		//row.put(key + '_label', '');
				 	//	row.put(key, '');

				 	}
				 
					 if (c.schType == 'Date' || c.schType == 'Datetime' ) {
						string xxx =MI_Utility.getString(row.get(key),'',  0, 10) ; 
						 row.put(key,xxx)  ;
						//MI_Utility.getString(

					}
					if (rml.buttonFields.containsKey(key)) {
						row.put(key + '_btnLabel', o);
						row.put(key + '_btnIcon', 'utility:' + rml.buttonFields.get(key).toLowerCase());
					}
					if (c.relatedFieldName != null && c.typeAttributes.label != null) {
						object o1 = MI_Utility.getSObjFld(s, c.relatedFieldName);
						if (o1 != null) {
							row.put(c.typeAttributes.label.fieldName, o1);
							row.put(c.typeAttributes.tooltip.fieldName, o1);
						} }

				} }
			 	for(string key : rml.linkFieldRef) {
					if(!row.containsKey(key) ) {
						object o = MI_Utility.getSObjFld(s, key);
							row.put(key, o);
					}
				}
			return row;

		}

	}

	public class dRows {
		public string id { get; set; }
		public string val1 { get; set; }
	}
}