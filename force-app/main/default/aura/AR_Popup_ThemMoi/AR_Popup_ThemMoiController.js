({
    doInit: function(component, event, helper){
        helper.getClassPicklist(component, event);
    },

    handleCreateStudent: function(component, event, helper) {
        helper.saveData(component, event);
    },

    handleClassOnChange: function(component, event, helper){
        helper.changeClass(component, event);
    }

})
