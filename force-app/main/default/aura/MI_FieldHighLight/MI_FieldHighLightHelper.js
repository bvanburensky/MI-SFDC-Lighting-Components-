({
	doInit: function(cmp, event) {
	   let f1 = cmp.get("v.fieldName1");
			   f1 += ""
			   cmp.set("v.fields", [f1])
			   let cssClass = cmp.get("v.colorSetting")
			   cssClass += ' ' + cmp.get("v.sizeSetting")
			   cmp.set("v.cssClass",cssClass);
 
			   cmp.find("sObjectRec").reloadRecord(true)

				
		},

	sObjUpdated: function(cmp, event) {
		  let f1 = cmp.get("v.fieldName1");
		  let fieldVal = "v.sObjectFields."   + f1
			cmp.set("v.field1Out", cmp.get(fieldVal) )

		}
})