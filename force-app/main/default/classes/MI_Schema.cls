@JsonAccess(serializable='never')
public class MI_Schema {

/* 
 Menorah IC 03/01/2023
	a class with standard string keys and maps for the object and the fields schema
	enampulates all the getDescribes such that the sobject info can be accessed directly from class instance

	Usage :

		MI_Schema schm = getObjectSchema
		string name = schm.rdObject.sObjName
		rdField nameField = schm.RdFieldMapLC('Name'.tolowercase()); 
		string type = nameField.fieldType()

		string fields = schm.RdFieldMapLC.keyset();
		schm.RdFieldMapLC.values();

		
	 */

	 // internal map of design schema instances
	 // used to create instence of the schema once per session
	static  map<string,MI_Schema> slSchema = new map<string,MI_Schema>();

	// get schema by name
	public static MI_Schema getsObjSchema(string sObjName) {
	sObjName = sObjName.toLowerCase();
     if(slSchema.containsKey(sObjName)) {
		 return slSchema.get(sObjname);
	 }
	 MI_Schema s = new MI_Schema(sObjName);
	 slSchema.put(sObjName, s);
	 return s;

	}
		// get schema by object reference
	public static MI_Schema getsObjSchema(sObject sObj) {
		if (sObj == null) {
			return null;
		}
		string sObjectAPIName = sObj.getSObjectType().getDescribe().getName();
		return getsObjSchema(sObjectAPIName);
	
		}

	public string sObjectAPIName { get; set; }
	@AuraEnabled
	public rdObject rdObject { get; set; }
	@AuraEnabled
	public RdField[] rdFields { get; set; }
 
	public MI_Schema() {
		RdFields = new RdField[] { };
	}
	// pass object name to build 
	public MI_Schema(string sObjName) {
		if (sObjName == null) {
			return;
		}
		sObjectAPIName = sObjName.toLowerCase();
		if(slSchema.containsKey(sObjectAPIName)) {
		  throw new MI_Exception('Plase use static function MI_Schema.getsObjSchema( '+ sObjectAPIName +') to create instance of MI_Schema') ;
		}
		RdFields = new RdField[] { };
		sObjectAPIName = sObjectAPIName;
		setup();
		
	}
	// pass sObject to build
	public MI_Schema(sObject sObj) {
		if (sObj == null) {
			return;
		}
		sObjectAPIName = sObj.getSObjectType().getDescribe().getName();
		if(slSchema.containsKey(sObjectAPIName)) {
			throw new MI_Exception('Plase use static function MI_Schema.getsObjSchema( '+ sObjectAPIName +') to create instance of MI_Schema') ;
		  }		
		RdFields = new RdField[] { };
		setup();
	}
     // for instaniated MI_Schema create a new instance of the object 
	public sObject newSObject() {
		return rdObject.sObjt.newSObject();
	}
 
	public class rdObject {
		public rdObject() { System.debug('create'); }
		public rdObject(Schema.SObjectType sObj) {
			sObjt = sObj;
			sObjName = sObj.getDescribe().getName();
			sObjLabel = sObj.getDescribe().getLabel();
			sObjPrefix = sObj.getDescribe().getKeyPrefix();
			LabelPlural = sObj.getDescribe().getLabelPlural();
			isUpdateable = sObj.getDescribe().isUpdateable();
			isFeedEnabled = sObj.getDescribe().isFeedEnabled();
			isAccessible = sObj.getDescribe().isAccessible();
			isCreateable = sObj.getDescribe().isCreateable();
			childRelations = sObj.getDescribe().getChildRelationships();


		}
		Schema.SObjectType sObjt;
		Schema.ChildRelationship[] childRelations;
		@AuraEnabled
		public string sObjName { get; set; }
		@AuraEnabled
		public boolean isUpdateable { get; set; }
		@AuraEnabled
		public boolean isCreateable { get; set; }
		@AuraEnabled

		public boolean isFeedEnabled { get; set; }
		@AuraEnabled
		public boolean isAccessible { get; set; }

		@AuraEnabled
		public string sObjLabel { get; set; }
		public string sObjPrefix { get; set; }
		@AuraEnabled
		public string labelPlural { get; set; }

		public boolean isCreateUpdateable { get {
				return isAccessible && isUpdateable && isUpdateable;
			} }
		Map<String, string[]> childObjectMapx;
        // 
		public Map<String, string[]> childObjectMap { get {
				if (childObjectMapx == null) {
					getObjects();
				 
					childObjectMapx = new Map<String, string[]> { };
					for (Schema.ChildRelationship c : childRelations) {
						string sObjectName = c.getChildSObject().getDescribe().getName();
						if (mSObjPrefix.containsKey(sObjectName)) {
							if (!childObjectMapx.containsKey(sObjectName)) {
								childObjectMapx.put(sObjectName, new string[] { });
							}
							childObjectMapx.get(c.getChildSObject().getDescribe().getName())
							.add(c.getChildSObject().getDescribe().getName() + ' : ' + c.getField().getDescribe().getName());
							//cs.add(c.getField() + ':' + c.getRelationshipName() + ':' + c.getChildSObject());
						} else {
					//system.debug('Not Added :' + sObjectName) ;
						}
					}
					system.debug('for '+ sObjName +': # Related Items found:' + childObjectMapx.size());
				}

				return childObjectMapx;
			} }
 
	}
	/**
	 * @description sObject field schema class
	 */
	public class RdField {
		public RdField() { System.debug('create'); }
		public RdField(schema.sObjectField fld) {
			fieldName = fld.getDescribe().getName();
			fieldLabel = fld.getDescribe().getLabel();
			fieldType = fld.getDescribe().getType().Name();
			ddType = fld.getDescribe().getType(); 
			isUpdateable = fld.getDescribe().isUpdateable();
			isAccessible = fld.getDescribe().isAccessible();
			isExternalId = fld.getDescribe().isExternalId();
			isFilterable = fld.getDescribe().isFilterable();
			isIdLookup = fld.getDescribe().isIdLookup();
			if (fld.getDescribe().getReferenceTo() != null && fld.getDescribe().getReferenceTo().size() > 0) {
				ReferenceTo = fld.getDescribe().getReferenceTo() [0].getDescribe().getName();
				ReferenceToPrefix = fld.getDescribe().getReferenceTo() [0].getDescribe().getKeyPrefix();
			}

			if (fieldType == Schema.DisplayType.MultiPicklist.name() ||
			    fieldType == Schema.DisplayType.Picklist.name()) {
				PicklistEntrys = fld.getDescribe().getPicklistValues();
			}

			sType = fld.getDescribe().getType().ordinal();

			isCustom = fld.getDescribe().isCustom();
			isSelected = false;
			targetField = '';

			length = fld.getDescribe().getLength();
			sObjField = fld;

		} 

		public Schema.sObjectField sObjField { get; set; }
		@AuraEnabled
		public string fieldName { get; set; }
		@AuraEnabled
		public string fieldLabel { get; set; }
		@AuraEnabled
		public string referenceTo { get; set; }
		@AuraEnabled
		public string referenceToPrefix { get; set; }
		@AuraEnabled
		public string fieldType { get; set; }
		public Schema.DisplayType ddType { get; set; }
		@AuraEnabled
		public boolean isUpdateable { get; set; }
		@AuraEnabled
		public boolean isAccessible { get; set; }
		@AuraEnabled
		public boolean isExternalId { get; set; }
		@AuraEnabled
		public boolean isFilterable { get; set; }
		@AuraEnabled
		public boolean isIdLookup { get; set; }
		@AuraEnabled
		public integer sType { get; set; }
		@AuraEnabled
		public boolean isSelected { get; set; }
		@AuraEnabled
		public boolean isCustom { get; set; }
		@AuraEnabled
		public string targetField { get; set; }

		public PicklistEntry[] picklistEntrys { get; set; }
		@AuraEnabled
		public rdLabelValue[] picklistValues { get {
				rdLabelValue[] strs = new rdLabelValue[] { };
				if (PicklistEntrys != null) {
					for (PicklistEntry p : PicklistEntrys) {
						strs.add(new rdLabelValue(p.getValue()));
					}
				}
				return strs;
			} }


		public integer length { get; set; }

		@AuraEnabled
		public string fieldData { get {
				string str = '';
				str += 'Name:' + fieldLabel;
				str += '\nAPIName:' + fieldName;

				str += '\nsType :' + sType;
				str += '\nisExternalId:' + isExternalId;
				str += '\nisIdLookup:' + isIdLookup;
				str += '\nisSelected:' + isSelected;
				str += '\nisUpdateable:' + isUpdateable;
				str += '\nisCustom:' + isCustom;
				str += '\nisCustom:' + referenceTo;
				return str;

			} }
	}

	/**
	 * @description label/value for picklists and selects in aura components
	 */
	public class rdLabelValue {
		public rdLabelValue() { System.debug('create'); }
		public rdLabelValue(string val) {
			Label = val;
			value = val;
		}
		@AuraEnabled
		public string label { get; set; }
		@AuraEnabled
		public string value { get; set; }

	}

	public set<string> rdFieldsUpdateableSet { get {
			set<string> u = new set<string> ();
			for (RdField r : RdFields) {
				if (r.isUpdateable) {
					u.add(r.fieldName);
				}
			}
			return u;
		} }
	public RdField[] rdFieldsUpdateable { get {
			RdField[] u = new RdField[] { };
			for (RdField r : RdFields) {
				if (r.isUpdateable) {
					u.add(r);
				}
			}
			return u;
		} }

	public RdField[] rdFieldsCustom { get {
			RdField[] u = new RdField[] { };
			for (RdField r : RdFields) {
				if (r.isCustom) {
					u.add(r);
				}
			}
			return u;
		} }
		// Returns the Name field for the object 
		// not all std objects use "Name" ,
		// exmp OrderItem name field is "OrderItemNumber"
		public RdField[] rdIdNameField { get {
			RdField[] u = new RdField[] { };
			for (RdField r : RdFields) {
				if (r.isIdLookup && r.fieldName !='Id' )  {
					u.add(r);
				}
			}
			return u;
		} }



	public string[] strFieldNames { get {
			string[] u = new string[] { };
			for (RdField r : RdFields) {
				u.add(r.fieldName);
			}
			return u;
		} }

 
	// setup schema 
	void setup() {
		try {
			Schema.getGlobalDescribe().get(sObjectAPIName.trim());
		} catch(Exception ex) {
			throw new MI_Exception('Error on GetDescribe for Object:' + sObjectAPIName,ex);
		}
	 		
        string []types = new string[] {sObjectAPIName};
		system.debug('describeSObjects :' +types );
        Schema.DescribeSObjectResult r =  Schema.describeSObjects(types)[0]; 
		system.debug('describeSObjects r:' + r );
		 
		/// Schema.getGlobalDescribe().get(sObjectAPIName).getDescribe();
		rdObject = new rdObject(r.getSObjectType());
		List<String> flds = new list<String> ();
		for (string apiName : r.fields.getMap().keySet()) {
			Schema.sObjectField obf = r.fields.getMap().get(apiName);
			RdField rd = new RdField(obf);
			RdFields.add(rd);
		}

	}

	public static map<String, string> mSObjPrefix = new map<String, string> ();

	// do not run this if there are hundreds of objects in the ors
	public static void getObjects() {
		if(mSObjPrefix.keySet().size() > 0) {
			return;
		}
		Map<String, Schema.SObjectType> gds = Schema.getGlobalDescribe();
		rdObject[] sObjs = new rdObject[] { };
		for (Schema.SObjectType t : gds.values()) {
			if (t.getDescribe().isQueryable() &&
			    !t.getDescribe().isCustomSetting() &&
			    t.getDescribe().isAccessible() &&
			  //  t.getDescribe().isSearchable() &&
			    t.getDescribe().isCreateable() &&
			    !t.getDescribe().getName().contains('__kav') 
		 

			) {
				mSObjPrefix.put(t.getDescribe().getName(), t.getDescribe().getKeyPrefix());
			}
		}
		system.debug( '\n'+'System Object Found:' + mSObjPrefix.keySet().size());
//		return sObjs;
	}

	/**
	 * @description Check writeability of field
	 * @param sobj  Object to check
	 * @param fieldName Name of Field
	 * @param throwError  throw an error if not writable
	 * @return 
	 */
	public static boolean fieldWriteSecurityCheck(string sobj, string fieldName, boolean throwError) {
		if (getsObjSchema(sobj).RdFieldsUpdateableSet.contains(fieldName)) {
			return true;
		}
		if (throwError) {
			MI_Exception ex = new MI_Exception('You do not have permissions to update ' + sobj + ' Field ' + fieldName);
			ex.isFieldReadSecurityError = true;
			throw ex;
		}
		return false;

	}
// determins if the field does not exist on the sObj, at least for the user
	public string[] getInvalidFields(string[] fieldsToTest) {
		string[] badFlds = new string[] { };
		for (string f : fieldsToTest) {
			if (!RdFieldMapLC.containsKey(f.toLowerCase())) {
				badFlds.add(f);
			}
		}
		return badFlds;

	}
	Map<String, RdField> rdFieldMapx;
	@AuraEnabled
	public Map<String, RdField> rdFieldMap { get {
			if (rdFieldMapx == null) {
				rdFieldMapx = new Map<String, RdField> ();
				for (RdField f : RdFields) {
					rdFieldMapx.put(f.fieldName, f);
				}
			}
			return rdFieldMapx;
		} }

	/**
	 * @description lowercase fieldKeys 
	 * User may enter field with any char case, this always work using a loer case Lookup 
	 */
	Map<String, RdField> rdFieldMapxLCx;
	@AuraEnabled
	public Map<String, RdField> rdFieldMapLC { get {
			if (rdFieldMapxLCx == null) {
				rdFieldMapxLCx = new Map<String, RdField> ();
				for (RdField f : RdFields) {
					rdFieldMapxLCx.put(f.fieldName.toLowerCase(), f);
				}
			}
			return rdFieldMapxLCx;
		} }
		Map<String, String> rdFieldNameLabelx;
		@AuraEnabled
		public Map<String, String> rdFieldNameLabel { get {
				if (rdFieldNameLabelx == null) {
					rdFieldNameLabelx = new Map<String, String> ();
					for (RdField f : RdFields) {
						rdFieldNameLabelx.put(f.fieldName, f.fieldLabel);
					}
				}
				return rdFieldNameLabelx;
			} }

}