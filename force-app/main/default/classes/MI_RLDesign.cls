/* 
 Menorah IC 03/01/2023
      class serves up related lists to the base object 
	  	ie contacts for accouns
		  products for opportunity

    */


    global class MI_RLDesign extends VisualEditor.DynamicPickList {
    
        VisualEditor.DesignTimePageContext ctx;
    
        // used to display related objects for selection at design time
        global MI_RLDesign(VisualEditor.DesignTimePageContext context) {
            this.ctx = context;
        }
     
        global override VisualEditor.DataRow getDefaultValue() {
            VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('', '');
            try {
                string sObj = ctx.entityName;
                MI_Schema sch = MI_Schema.getsObjSchema(sObj);
                if (sch.rdObject.childObjectMap.size() > 0) {
                    string val = sch.rdObject.childObjectMap.values() [0] [0];
                    defaultValue = new VisualEditor.DataRow(val, val, true);
                }
            } 
            catch(Exception ex) {
            }
        //	System.debug('get Default Value' + defaultValue);
            return defaultValue;
    
        }
        global override VisualEditor.DynamicPickListRows getValues() {
    
            VisualEditor.DynamicPickListRows vals = new VisualEditor.DynamicPickListRows();
            try {
                string sObj = ctx.entityName;
                MI_Schema sch = MI_Schema.getsObjSchema(sObj);
                for (string s : sch.rdObject.childObjectMap.keySet()) {
                    for (string sf : sch.rdObject.childObjectMap.get(s)) {
                        vals.addRow(new VisualEditor.DataRow(sf, sf));
                    } }
            }
            catch(Exception ex) {
                return null;
            }
            return vals;
        }
    }