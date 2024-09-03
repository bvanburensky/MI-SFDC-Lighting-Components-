({
    refreshData: function (cmp, event, helper) {
      if (helper.allowRefresh) {
        cmp.set("v.isRefresh", "spin");
        helper.query(cmp);
      }
    },
  
    doInit: function (cmp, event, helper) {
      let oParentName = cmp.get("v.parentObjectName");  
      if (oParentName && oParentName.split(":").length >1) {
        let  recField = oParentName.split(":")[0];
        let  recObject = oParentName.split(":")[1];
        if(recObject != 'ID') {
          cmp.set("v.sObjectName",recObject);
          
        }
      }
      helper.debug = cmp.get("v.debug");
      let oName = cmp.get("v.objectName");
      let displayHeader = cmp.get("v.displayHeader");
      let accordion = cmp.get("v.accordion");
      if (!accordion) {
        cmp.set("v.displayHeader", true);
      }
  
      if (oName) {
        let oLabel = oName.split(":")[0].replace("__c", "").replace("SBQQ__", "");
        cmp.set("v.sObjectType", oName.split(":")[0]);
        cmp.set("v.sObjLabel", oLabel);
      }

      helper.query(cmp);
      cmp.set("v.MI_EventRefreshCommand", "refresh-" + cmp.get("v.globalId"));
      //create placeholder record with only the lookup populated
      helper.setStyle(cmp);
      window.setTimeout(
        $A.getCallback(function () {
          helper.doInject(cmp, helper);
        }),
        2000
      );
    },
    refresh: function (cmp, event, helper) {
      cmp.set("v.isRefresh", "spin");
      helper.query(cmp);
    },
    filter: function (cmp, event, helper) {
      helper.filter(cmp);
    },
  
    MI_EventHandler: function (cmp, event, helper) {
      let MI_EventRefreshCommand = cmp.get("v.MI_EventRefreshCommand");
      let cmd = event.getParam("command");
      let gIde = event.getParam("globalId");
      let gId = cmp.get("v.globalId"); 
      let AutoRefresh = cmp.get("v.refreshOnSiblingRefresh"); 
      if (cmd == MI_EventRefreshCommand || 
         (AutoRefresh && cmd.startsWith("refresh") )
        ) {
        helper.query(cmp);
      }
      if (cmd == "saveList" && gId == gIde) {
        helper.saveList(cmp, event);
      }
      if (cmd == "saveRow" && gId == gIde) {
        helper.saveRow(cmp, event);
      }
    },
  
    handleSelect: function (cmp, event) {
      //Here, I want to navigate to the record
      //console.log("event");
      //console.log(event);
      var navEvt = $A.get("e.force:navigateToSObject");
      navEvt.setParams({
        recordId: event.getParam("recordId")
      });
      navEvt.fire();
    },
    // Handle quick action call
    doButtonAction: function (cmp, event,helper) {

      let action = event.getSource()
      helper.doButtonActions(cmp,action);
   
    }    ,
    doQuickAction: function (cmp, event) {
      let quickActionAPI = cmp.find("quickActionAPI");
      let action = event.getSource().get("v.name");
      let args = { actionName: action };
      quickActionAPI
        .selectAction(args)
        .then(function (result) {
          console.log(result);
        })
        .catch(function (e) {
          if (e.errors) {
            console.log(e.errors);
  
            // If the specified action isn't found on the page,
            // show an error message in the my component
          }
        });
    }
  });