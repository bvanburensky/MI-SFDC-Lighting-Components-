/*
     Menorah IC 03/01/2023
    // used to display related objects for selection at design time
*/

global class MI_FieldHighlightDesign extends VisualEditor.DynamicPickList {

    VisualEditor.DesignTimePageContext ctx;

    // used to display related objects for selection at design time
    global MI_FieldHighlightDesign(VisualEditor.DesignTimePageContext context) {
         this.ctx = context;
    }

    /** 
     * @description 
     */
    global override VisualEditor.DataRow getDefaultValue() {
         system.debug('MI_FieldHighlightDesign Design Mode');
         VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('', '');
         try {

              defaultValue = new VisualEditor.DataRow('Name', 'Name', true);

         }
         catch(Exception ex) {
         }
         System.debug('get Default Value' + defaultValue);
         return defaultValue;

    } 
    global override VisualEditor.DynamicPickListRows getValues() {
         system.debug('MI_FieldHighlightDesign Design Mode');

         VisualEditor.DynamicPickListRows vals = new VisualEditor.DynamicPickListRows();
         try {
              string sObj = ctx.entityName;
              Map<String, String> rdFieldMap = MI_Utility.getSObjectFieldsAndLabels(sObj);
              for (string s : rdFieldMap.keySet()) {
                   vals.addRow(new VisualEditor.DataRow(rdFieldMap.get(s),s));
              }
         }
         catch(Exception ex) {
              return null;
         }
         return vals;
    }
}