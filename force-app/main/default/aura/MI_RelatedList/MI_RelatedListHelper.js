({
    allowRefresh: true,
    isTrue: "utility:check",
    isFalse: "utility:null",
    localAttribs: {
      icons: {
        isTrue: "utility:questions_and_answers",
        isFalse: "utility:invalid"
      }
    },
  
    setStyle: function (cmp, event) {
      var height = cmp.get("v.height");
      if (!height) {
        height = 30;
      }
      cmp.set("v.style", "min-height:5rem; max-height:" + height + "rem; ");
    },
  
    query: function (cmp) {
      let base = this;
      base.parentRecordId = cmp.get("v.recordId");
      cmp.set("v.errors", "");
      cmp.set("v.globalId", cmp.getGlobalId());
  
      var action = cmp.get("c.cQuery");
      /* Data Model --  See ACComponentModel  Apex Class*/
      let ACMod = {};
      ACMod.dRecordId = cmp.get("v.recordId");
      ACMod.dRelatedObj = cmp.get("v.objectName");
      ACMod.dDisplayFields = cmp.get("v.displayFields");
      ACMod.dEditableFields = cmp.get("v.editableFields");
      ACMod.dSortField = cmp.get("v.sortField");
      ACMod.dSortDescending = cmp.get("v.sortDescending");
      ACMod.dFilterSOQL = cmp.get("v.filterSOQL");
      ACMod.dSOQLLimit = cmp.get("v.SOQLLimit");
      ACMod.dLinkFields = cmp.get("v.linkFields");
      ACMod.dbuttonFields = cmp.get("v.buttonFields");
      ACMod.dDesignIcons = cmp.get("v.designIcons");
      ACMod.dIsBaseObject = cmp.get("v.isBaseObject");
      ACMod.dActions = cmp.get("v.actions");
      ACMod.dFixedWidth = cmp.get("v.fixedWidth");
      ACMod.dLabelOverrides = cmp.get("v.labelOverrides");
  
      let m = JSON.stringify(ACMod);
      action.setParams({ dModel: m });
      action.setCallback(self, function (response) {
        base.allowRefresh = true;
  
        try {
          let state = response.getState();
          let errors = response.getError();
          if (
            cmp.isValid() &&
            state === "SUCCESS" &&
            response.getReturnValue() != null
          ) {
            let ACMod = response.getReturnValue();
            ACMod.globalId = cmp.get("v.globalId");
            if (!ACMod.isError) {
              let cols = ACMod.dtColumns.columns;
              let rows = ACMod.sObjs.rows;
              for (let col of cols) {
                if(col.isRefOnly) {
                  continue;
                }
                for (let row of rows) {
                  base.setLables(col, row);
                  base.setSort(col, row);
                  base.setIcon(col, row);
                  base.setUrl(col, row);
                }
              }
              if (rows && rows.length > 0) {
                if (base.debug) {
                  console.log("Data Mod" + ACMod.sObjs.rows);
                }
              }
              cmp.set("v.acMod", ACMod);
              ACMod.actionFieldUpdates = cmp.get("v.actionFieldUpdates");
              cmp.set("v.sObjectType", ACMod.sObjName);
  
              cmp.set("v.rowCount", ACMod.rowCount);
              let wrk = cmp.get("v.title");
              wrk = wrk && wrk.length > 0 ? wrk : ACMod.sObjLabel;
              cmp.set("v.sObjLabel", wrk);
              wrk = cmp.get("v.iconName");
              wrk =
                wrk && wrk.length > 0 ? wrk : "standard:" +  (ACMod.sObjName ? ACMod.sObjName.toLowerCase() : "utility:person");
              cmp.set("v.iconNameOut", wrk);
  
              cmp.set("v.modelReady", true);
              cmp.set("v.ready", true);
              if (base.debug) {
                let msg = ACMod.trace + " ";
                cmp.set("v.errors", "Trace:" + msg);
              }
              cmp.set("v.modelReady", true);
              cmp.set("v.ready", true);
  
              //	return;
            }
            // ACMod.isError==true
            if (ACMod.message) {
              errors.push(ACMod.message);
            }
          }
          base.MI_Error(errors);
          base.parseErrors(cmp, errors);
        } catch (error) {
          base.MI_Error(error);
          cmp.set("v.errors", error);
        }
        cmp.set("v.isRefresh", "nospin");
      });
      $A.enqueueAction(action);
    },
    // inject dynamic components s
    doInject: function (cmp, helper) {
      let quickActions = cmp.get("v.quickActions");
      if (!quickActions) {
        return;
      }

      quickActions = quickActions.split(",");
       
      quickActions.forEach(function (ele, i) {
        let aAction = ele.split(":")[0];
        let aLab = aAction;
        if (ele.split(":").length > 1) {
          aLab = ele.split(":")[1];
        }
        helper.injectComponent(
          [
            [
              "lightning:button",
              {
                label: aLab,
                name: aAction,
                onclick: cmp.getReference("c.doButtonAction")
              }
            ]
          ],
          cmp.find("actionButtons")
        );
      });
    },

    doButtonActions: function(cmp,action) {
       let btnVals = {}
       btnVals.recordId = cmp.get("v.recordId") 
       btnVals.oName =cmp.get("v.objectName");
       btnVals.btnAction = action.get("v.name").toLowerCase();
       btnVals.sObj = btnVals.oName.split(':')[0].trim();
       if(btnVals.oName.split(':').length > 1) { 
        btnVals.sField = btnVals.oName.split(':')[1].trim();
       }


      switch (btnVals.btnAction) {
        case "view":
          this.view(btnVals);
          return;
          break;
        case "edit":
          this.edit(btnVals);
          return;
          break;
        case "new":
          this.create(btnVals);
          return;
          break;            
      }

    },
    create: function (btnVals) {
  
      
      let  evt = $A.get("e.force:createRecord");
      let defaultVals = {};
      defaultVals[btnVals.sField] =  btnVals.recordId ;
   
      evt.setParams({
        "entityApiName": btnVals.sObj,
        "defaultFieldValues": defaultVals
 
      });
      evt.fire();
      //console.log(selectedEvent);
    },  
    // reset l_label and cell attribute column
    setLables: function (col, row) {
      if (col.cellAttributes && col.cellAttributes.l_label) {
        col.cellAttributes.label = l_label;
      }
  
      if (col.type == "boolean") {
        row[col.fieldName] = row[col.fieldName] == "true" ? true : false;
      }
    },
    // force a sort row value for emails and urls
    setSort: function (col, row) {
      row[col.fieldName + "_sort"] = row[col.fieldName];
    },
    setIcon: function (col, row) {
      let tf = row[col.fieldName];
      if (
        col.cellAttributes &&
        col.cellAttributes.iconName &&
        col.cellAttributes.iconName.fieldName
      ) {
        // fieldName specified for icon but the field is not on the row
        let fldTest = col.cellAttributes.iconName.fieldName in row;
        if (!fldTest) {
          if (col.type == "boolean") {
            row[col.cellAttributes.iconName.fieldName] = tf
              ? col.cellAttributes.iconName.icon
              : "";
            row[col.fieldName] = "";
          }
        }
      }
    },
    setUrl: function (col, row) {
      if (col.type == "url") {
        if (col.typeAttributes && col.typeAttributes.linkId) {
          // is the field specified in the col attributes in the row
          let fldTest = col.typeAttributes.linkId in row;
          if (fldTest) {
            if (row[col.fieldName].length > 0) {
              row[col.fieldName + "_label"] = row[col.fieldName];
              row[col.fieldName] = "/" + row[col.typeAttributes.linkId];
            }
          }
        }
      }
    },
  
    filter: function (cmp) {
      var filter = cmp.get("v.filter");
      //console.log("in debounced function");
      //console.log(filter);
      if (!filter) {
        //console.log("no filter");
        cmp.set("v.filteredResults", cmp.get("v.results"));
      } else {
        //console.log("filter present: " + filter);
        var goodStuff = _.filter(cmp.get("v.results"), function (record) {
          var contains = false;
          _.forEach(record, function (value) {
            contains = contains || _.includes(_.toString(value), filter);
          });
          return contains;
        });
        cmp.set("v.filteredResults", goodStuff);
      }
      this.sort(cmp);
    },
  
    //sort always occurs after filter
    sort: function (cmp) {
      var sortState = cmp.get("v.sortState");
      if (!sortState) return; //if it's not sorted, just skip it
      var results = _.sortBy(cmp.get("v.filteredResults"), [sortState.field]);
      if (sortState.direction === "Descending") {
        _.reverse(results);
      }
      cmp.set("v.filteredResults", results);
    },
  
    // from save list event
    saveList: function (cmp, event) {
      try {
        let base = this;
        let action = cmp.get("c.cSaveList");
        let ACMod = {};
        ACMod.dRecordId = cmp.get("v.recordId");
        ACMod.dRelatedObj = cmp.get("v.objectName");
        ACMod.dObjects = event.getParam("Objects");
        ACMod.globalId = this.globalId;
        base.globalId = cmp.get("v.globalId");
        let m = JSON.stringify(ACMod);
        action.setParams({ dModel: m });
        action.setCallback(self, function (response) {
          base.allowRefresh = true;
  
          let ACMod = {};
          try {
            let state = response.getState();
            let errors = response.getError();
            if (
              cmp.isValid() &&
              state === "SUCCESS" &&
              response.getReturnValue() != null
            ) {
              ACMod = response.getReturnValue();
              if (ACMod.isError) {
                cmp.set("v.errors", ACMod.message);
                return;
              }
            }
            base.parseErrors(cmp, errors);
          } catch (error) {
            base.MI_Error(error);
            cmp.set("v.errors", error);
          }
          base.acEventFire("refresh-" + cmp.get("v.globalId"));
  
          //			cmp.set("v.isRefresh", "nospin");
        });
        $A.enqueueAction(action);
      } catch (error) {
        base.MI_Error(error);
        cmp.set("v.errors", error);
      }
    },
  
    /** for Testing */
    typeAttributes: {
      label: "",
      target: ""
    },
    cellAttributes: {
      iconName: { fieldName: "IsMainContact__c_chk" },
      iconPosition: "left"
    },
    sObjCols: [
      { fieldName: "Name", label: "Full Name", type: "text" },
      { fieldName: "Info__c", label: "Info", type: "text" },
      { fieldName: "Email", label: "Email", type: "email" },
      {
        fieldName: "IsMainContact__c",
        label: "IsMainContact",
        type: "boolean",
        cellAttributes: {
          iconName: { fieldName: "IsMainContact__c_chk" },
          iconPosition: "left"
        },
        local_attributes: {
          icons: {
            isTrue: "utility:questions_and_answers",
            isFalse: "utility:invalid"
          }
        }
      },
      {
        fieldName: "IsActive__c",
        label: "IsActive",
        type: "boolean",
        cellAttributes: {
          iconName: { fieldName: "IsActive__c_chk" },
          iconPosition: "left"
        }
      }
    ]
  });


        /*
      let quickActionAPI = cmp.find("quickActionAPI");
      let aa = quickActionAPI
        .getAvailableActions()
        .then(function (result) {
          base.MI_Error(result);
        })
        .catch(function (e) {
          if (e.errors) {
            //If the specified action isn't found on the page, show an error message in the my component
          }
        });
  
      quickActions = quickActions.split(",");
       
      quickActions.forEach(function (ele, i) {
        let aAction = ele.split(":")[0];
        let aLab = aAction;
        if (ele.split(":").length > 1) {
          aLab = ele.split(":")[1];
        }
        helper.injectComponent(
          [
            [
              "lightning:button",
              {
                label: aLab,
                name: aAction,
                onclick: cmp.getReference("c.doQuickAction")
              }
            ]
          ],
          cmp.find("actionButtons")
        );
      });
      */
  /*
        try {
              
         for (let col of ACMod.dataTable.columns) {
          if (col.fieldName == 'IsMainContact__c') {
           col.local_attributes = JSON.parse(JSON.stringify(base.localAttribs));
           col.local_attributes.icons.isTrue = "utility:questions_and_answers"
          }
          if (col.fieldName == 'IsActive__c') {
           col.local_attributes = JSON.parse(JSON.stringify(base.localAttribs));
           col.local_attributes.icons.isTrue = "utility:check"
           col.local_attributes.icons.isFalse = "utility:sentiment_negative"
          }
          if (col.fieldName == 'IsBillingContact__c') {
           col.local_attributes = JSON.parse(JSON.stringify(base.localAttribs));
           col.local_attributes.icons.isTrue = "utility:user_role"
          }
          if (col.fieldName == 'Title') {
           col.cellAttributes = JSON.parse(JSON.stringify(base.cellAttributes));
           col.cellAttributes.iconName.fieldName = col.fieldName + '_chk';
           col.cellAttributes.iconLabel = '';
           col.local_attributes = JSON.parse(JSON.stringify(base.localAttribs));
           col.local_attributes.icons.Principal = 'utility:puzzle';
           col.local_attributes.icons.VicePresident = 'utility:moneybag';
  
  
          }
         }
        }
        catch (error) { }
              */