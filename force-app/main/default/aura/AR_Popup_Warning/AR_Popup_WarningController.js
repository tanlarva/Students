({
    handleCancel : function(component, event, helper) {
        //closes the modal or popover from the component
        component.find("overlayLib").notifyClose();
    },
    handleOK : function(component, event, helper) {
        //do something
        var idStudent = component.get("v.listDelete");
        helper.deleteStudent(component, event, helper, idStudent);
    }
})
