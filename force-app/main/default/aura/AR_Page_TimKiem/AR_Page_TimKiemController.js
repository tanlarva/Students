({
    doInit : function(component, event, helper) {
        helper.getClassPicklist(component, event);
        helper.fetchAllData(component, event, helper);
    },

    handleClassOnChange : function(component, event, helper) {
        helper.changeClass(component, event);
    },

    handleCreateStudent : function(component, event, helper) {
        helper.createStudent(component, event);
    },

    handleSearchStudent : function(component, event, helper) {
        helper.fetchDataSearch(component, event, helper);
    },

    handleDeleteStudent : function(component, event, helper) {
        var student = component.get('v.selectedStudent');
        helper.deleteAllStudent(component, event, helper, student);
    },

    handleViewStudent : function(component, event, helper) {


    },

    handleRowAction : function(component, event, helper) {
        var action = event.getParam("action");
        var row = event.getParam("row");
        switch (action.name) {
            case 'update':
                helper.updateStudent(component, event, helper, row);
                break;
            case 'delete':
                helper.deleteStudent(component, event, helper, row);
                break;
        }
    },

    handleRowSelection : function(component, event, helper) {
        var selected = event.getParam("selectedRows");
        var setRows = [];
        for( var i = 0; i < selected.length; i++){
            setRows.push(selected[i]);
        }
        component.set('v.selectedStudent',setRows);
        alert(JSON.stringify(selected));
    },

    handleNext : function(component, event, helper){        
        component.set("v.currentPageNumber", component.get("v.currentPageNumber") + 1);
        helper.setPaginateData(component);
    },
     
    handlePrevious : function(component, event, helper){
       component.set("v.currentPageNumber", component.get("v.currentPageNumber") - 1);
       helper.setPaginateData(component);
    },
     
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.setPaginateData(component);
    },
     
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.setPaginateData(component);
    },

})
