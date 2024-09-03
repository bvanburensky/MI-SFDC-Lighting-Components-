({
    doInit: function (cmp, event, helper) {
      helper.debug = cmp.get("v.debug");
      helper.load(cmp, event);
    },
    doRefresh: function (cmp, event, helper) {
      helper.load(cmp, event);
    },
    handleRowAction: function (cmp, event, helper) {
      helper.handleRowAction(cmp, event);
    },
    handleRowSelection: function (cmp, event, helper) {
      helper.handleRowSelection(cmp, event);
    },
    onsort: function (cmp, event, helper) {
      let sortable = cmp.get("v.sortable");
      if (sortable) {
        helper.onsort(cmp, event);
      }
    },
    onSave: function (cmp, event, helper) {
      helper.onSave(cmp, event);
    }
  });