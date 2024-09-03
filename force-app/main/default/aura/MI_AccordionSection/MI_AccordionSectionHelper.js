({
    open: function (cmp, event) {
        cmp.set("v.isOpen", true);
      cmp.set("v.sectionBodyclass", "slds-show");

},
    close: function (cmp, event) {
    cmp.set("v.isOpen", false);
    cmp.set("v.sectionBodyclass", "slds-hide");
},	
toggleState: function (cmp, event) {
  let vis = cmp.get("v.isOpen")
    cmp.set("v.isOpen", !vis);
    cmp.set("v.sectionBodyclass", (!vis ? "slds-show" : "slds-hide"));
}
})