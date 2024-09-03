({
    // data table columns
  
    actions: [
      { label: "View", name: "view" },
      { label: "Edit", name: "edit", disabled: true },
      { label: "debug", name: "debug" }
    ],
    // ini columns
    columns: [{ label: "DefaultName", type: "text", fieldName: "Name" }],
    columnse: [{ label: "E", type: "button", fieldName: "Id" }],
    urlType: { label: "Name", target: "_parent" },
    data: [{ name: "Jack Rabbit" }],

    load: function (cmp, event) {
      let mod = cmp.get("v.acMod");
      this.MI_Debug("Mod ", mod, this);
      if (mod) {
        cmp.set("v.gbId", mod.globalId);
        if (mod.sObjs) {
          this.data = mod.sObjs.rows;
        }
  
        if (mod.dtColumns.columns && mod.dtColumns.columns.length > 0) {
          this.columns = mod.dtColumns.columns;
        }
  
        cmp.set("v.acColumns", this.columns);
        cmp.set("v.keyField", "id");
  
        cmp.set("v.acData", this.data);
        this.MI_Debug("Columns", this.columns, this);
        this.MI_Debug("Data", this.data, this);
      }
    },
  
    handleRowSelection: function (cmp, event) {
      let selectedRows = event.getParam("selectedRows");
      let MI_Evt = this.MI_EventGet();
      MI_Evt.setParam("command", "MI_DataTable.handleRowSelection");
      MI_Evt.setParam("selectedRows", selectedRows);
      MI_Evt.fire();
    },
    handleRowAction: function (cmp, event) {
      try {
        let base = this;
        let mod = cmp.get("v.acMod");
        let action = event.getParam("action");
        let row = event.getParam("row");
        let val = event.getParam("value");
        let parms = event.getParams();
        this.MI_Debug("handleRowAction", parms, this);
        let rowId = row.id;
        let actionFieldUpdates = null;
        if (mod.actionFieldUpdates) {
          try {
            actionFieldUpdates = JSON.parse(mod.actionFieldUpdates);
          } catch (e) {
            this.MI_Error(e);
            //cmp.set("v.errors", error);
          }
        }
  
        switch (action.name) {
          case "view":
            this.view(row);
            return;
            break;
          case "edit":
            this.edit(row);
            return;
            break;
            case "create":
              this.create(row,mod.dRecordId);
              return;
              break;            
          case "debug":
            let dId = "RecordId:" + rowId;
            let dDetails = "*********Row:" + JSON.stringify(row) + "\n";
            let dColumns = "Columns:" + JSON.stringify(this.columns);
            for (let col of this.columns) {
              console.log(JSON.stringify(col));
            }
            //	console.log(dId);
            console.log(dDetails);
            //	console.log(dColumns);
            ///	alert('Showing Details' + dId + dDetails + ' ' + dColumns);
            return;
            break;
        }
  
        if (actionFieldUpdates) {
          actionFieldUpdates.forEach(function (afu, i) {
            if (afu.action == action.name) {
              base.customAction(cmp, row, afu);
            }
          });
        }
      } catch (e) {
        this.MI_Error(e);
        //cmp.set("v.errors", error);
      }
    },
    //TODO: options for click behavior
    view: function (row) {
      var recordId = row.id;
      var evt = $A.get("e.force:navigateToSObject");
      evt.setParams({
        recordId: recordId
      });
      evt.fire();
      //console.log(selectedEvent);
    },
    edit: function (row) {
      var recordId = row.id;
      var evt = $A.get("e.force:editRecord");
      evt.setParams({
        recordId: recordId
      });
      evt.fire();
      //console.log(selectedEvent);
    },
    create: function (row,parentRecordId) {
      var recordId = row.id;
      var evt = $A.get("e.force:createRecord");
      evt.setParams({
        "entityApiName": "Address__c",
        "defaultFieldValues": {
        'Account__c' : parentRecordId
       }
 
      });
      evt.fire();
      //console.log(selectedEvent);
    },    
    zcreateRecord : function (row) {
      var createRecordEvent = $A.get("e.force:createRecord");
      createRecordEvent.setParams({
          "entityApiName": "Contact"
      });
      createRecordEvent.fire();
   },
    // custom action from Row Actions(s)
    customAction: function (cmp, row, afu) {
      var rows = cmp.get("v.acData");
      let afus = [];
      // process only one row
      if (!afu.all) {
        var rowIndex = rows.indexOf(row);
        rows[rowIndex][afu.field] = afu.value;
        afu.id = rows[rowIndex]["id"];
        afu[afu.field] = afu.value;
        afus.push(afu);
      }
      // process all rows
      if (afu.all) {
        for (let row of rows) {
          let afuT={};
          row[afu.field] = afu.value;
          afuT.value = afu.value;
          afuT[afu.field] = afu.value;
      
          afuT.field = afu.field;
          afuT.id = row["id"];
          afus.push(afuT);
        }
      }
      cmp.set("v.acData", rows);
      this.acEventFire(
        "saveList",
        "x",
        "Objects",
        afus,
        "globalId",
        cmp.get("v.gbId")
      );
    },
    onSave: function (cmp, event) {
      this.acEventFire(
        "saveList",
        "x",
        "Objects",
        event.getParam("draftValues"),
        "globalId",
        cmp.get("v.gbId")
      );
    },
    onsort: function (cmp, event) {
      let fieldName = event.getParam("fieldName");
      let sortDirection = event.getParam("sortDirection");
  
      let oldFieldName = cmp.get("v.sortedBy");
      let olddir = cmp.get("v.sortedDirection");
      sortDirection = !sortDirection ? "asc" : sortDirection;
      sortDirection == "asc" ? "asc" : "desc";
      if (fieldName == oldFieldName && sortDirection == olddir) {
        sortDirection = sortDirection == "asc" ? "desc" : "asc";
      }
  
      cmp.set("v.sortedBy", fieldName);
      cmp.set("v.sortedDirection", sortDirection);
      this.sortData(cmp, fieldName, sortDirection);
    },
    sortData: function (cmp, fieldName, sortDirection) {
      this.MI_Debug("sortData", fieldName + " " + sortDirection, this);
      let ddata = cmp.get("v.acData");
      if (ddata.length == 0) {
        return;
      }
      let hasSortCol = fieldName + "_sort" in ddata[0];
      if (hasSortCol) {
        fieldName = fieldName + "_sort";
      }
      var reverse = sortDirection !== "asc";
  
      ddata.sort(this.sortBy(fieldName, reverse));
      cmp.set("v.acData", ddata);
      //this.data = ddata	;
    }
  });