({
    doInit: function(component, event, helper){
        helper.getClassPicklist(component, event);
    },

    handleCreateStudent: function(component, event, helper) {
        helper.saveData(component);
    },

    handleClassOnChange: function(component, event, helper){
        var class = component.get('v.student.Class');
        alert(class);
    },

})
