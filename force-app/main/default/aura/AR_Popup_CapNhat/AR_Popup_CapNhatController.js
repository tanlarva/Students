({
    doInit : function(component, event, helper) {
        helper.checkIdReady(component, event, helper);
    },

    handleSaveStudent: function(component, event, helper) {
        helper.saveData(component, event);
    },

    handleClassOnChange: function(component, event, helper){
        helper.changeClass(component, event);
    }


})
