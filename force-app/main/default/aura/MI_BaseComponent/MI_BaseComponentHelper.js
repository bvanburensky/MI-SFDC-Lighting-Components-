({

 
  toast: function (title, message) {
    try {
      let resultsToast = $A.get("e.force:showToast");
      resultsToast.setParams({
        title: title,
        message: message,
      });
      resultsToast.fire();
    } catch (ex) {
      alert(title + " :" + message);
    }
  },
  
  doRedirect: function (cmp, event, sObjTab) {
    var navService = cmp.find("navService");
    // Sets the route to /lightning/o/Account/home
    let pageReference = {
      type: "standard__objectPage",
      attributes: {
        objectApiName: sObjTab,
        actionName: "home",
      },
    };
    cmp.set("v.pageReference", pageReference);
    // Set the URL on the link or use the default if there's an error

    // event.preventDefault();
    window.setTimeout(
      $A.getCallback(function () {
        navService.navigate(pageReference);
      }),
      1000
    );
  },
  sortBy: function (field, reverse, primer) {
    let key = primer
      ? function (x) {
          return primer(x[field]);
        }
      : function (x) {
          return x[field];
        };
    reverse = !reverse ? 1 : -1;
    return function (a, b) {
      return (
        (a = key(a) ? key(a) : ""),
        (b = key(b) ? key(b) : ""),
        reverse * ((a > b) - (b > a))
      );
    };
  },
  mp: null,
  idTraceColumns: [
    { label: "#", fieldName: "lineNo", type: "text", initialWidth: "50px" },
    {
      label: "Line",
      fieldName: "traceLine",
      type: "text",
      initialWidth: "50px",
    },
  ],

  diColumns: [
    { label: "Log", fieldName: "Name", type: "text", initialWidth: "50px" },
    {
      label: "Type",
      fieldName: "roxdog01__ActivityType__c",
      type: "text",
      initialWidth: "50px",
    },
    {
      label: "Scan Object",
      fieldName: "roxdog01__ScannedObject__c",
      type: "text",
      initialWidth: "100px",
    },
    {
      label: "Start",
      fieldName: "roxdog01__StartTime__c",
      type: "datetime",
      initialWidth: "100px",
    },
    {
      label: "End",
      fieldName: "roxdog01__EndTime__c",
      type: "datetime",
      initialWidth: "100px",
    },
    {
      label: "Records",
      fieldName: "roxdog01__TotalNumberOfRecords__c",
      type: "number",
      initialWidth: "100px",
    },
    {
      label: "error",
      fieldName: "roxdog01__ErrorMessage__c",
      type: "text",
      initialWidth: "100px",
    },
  ],

  showTrace: true,
  MI_Error: function (error) {
    this.MI_ErrorConsole(error);
  },
  MI_ErrorConsole: function (message, show) {
    if (show) {
      console.log(message);
    }
  },
  MI_ErrorConsole: function (error1) {
    try {
      console.log("-- DI Error -- ");
      if (error1.length) {
        for (let x of error1) {
          if (x && x.status) {
            console.log("-- " + x.status + " " + x.message);
          } else {
            console.log("-- " + x);
          }
          return;
        }
      }
      if (error1.name) {
        console.log("Name: " + error1.component);
        console.log("Component: " + error1.component);
        console.log("Stack: " + error1.componentStack);
        console.log("message: " + error1.message);
        console.log(error1);
        return;
      }
      console.log(error1);
    } catch (ex) {
      console.log("-- " + ex);
    }
  },
  parseErrors: function (cmp, errors) {
    let err = "";
    if (errors && errors.length == 0) {
      err += errors;
    }
    if (errors.length > 0) {
      if (errors[0]) {
        err += errors[0];
      }
      if (errors[0].message) {
        err += errors[0].message;
      }
      if (errors[0].stackTrace) {
        err += " ----" + errors[0].stackTrace;
      }
      if (errors[0].pageErrors && errors[0].pageErrors.length > 0) {
        err += errors[0].pageErrors[0].message;
      }
      if (errors[0].fieldErrors && errors[0].fieldErrors.length > 0) {
        err += errors[0].fieldErrors[0].message;
      }
      cmp.set("v.errors", err);
      return err.length == 0 ? 0 : 1;
    }
  },
  debug: false,
  pageRecordId:'test',
  MI_Debug: function (title, data, thatThis) {
    if (this.debug) {
      console.log(title + " " + data); //+ (thatThis ? thatThis :'' ) ) ;
    }
  },

  acEventGet: function (cmd, recId) {
    let dEvt = $A.get("e.c:MI_Event");
    return dEvt;
  },

  // cmd , recordId,
  acEventFire: function (cmd, recId, key1, val1, key2, val2) {
    let dEvt = $A.get("e.c:MI_Event");
    if (cmd) {
      dEvt.setParam("command", cmd);
    }
    if (recId) {
      dEvt.setParam("recordId", recId);
    }
    if (key1 && val1) {
      dEvt.setParam(key1, val1);
    }
    if (key2 && val2) {
      dEvt.setParam(key2, val2);
    }
    dEvt.fire();
  },

  injectComponent: function (components, target) {
    let xbase = this;
    $A.createComponents(
      components,
      function (contentComponents, status, error) {
        if (status === "SUCCESS") {
          for (let cCmp of contentComponents) {
            let bod = target.get("v.body");
            bod.push(cCmp);
            target.set("v.body", bod);
          }
        } else {
          xbase.rdError(error);
        }
      }
    );
    return true;
  },
  debugObject: function (obj, level) {
    let str = "";
    if (!level) {
      level = "";
    }
    for (var propertyName in obj) {
      if (typeof obj[propertyName] != "object") {
        str += level + propertyName + ": " + obj[propertyName] + "</br> ";
      } else {
        str += this.debugObject(obj[propertyName], level + propertyName + ".");
      }
    }
    return str;
  },
});