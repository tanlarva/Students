({
    getDataStudent : function(component, event){
        var action = component.get('c.getDataStudent');
        var student = component.get('v.recordId');
        action.setParams({
            id : student
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS'){
                component.set('v.dataStudent', response.getReturnValue());
            }else if (state === 'ERROR'){
                var error = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                if (error){
                    toastEvent.setParams({
                        "title": "Error!",
                        "variant": "error", 
                        "message": error[0].message
                        });
                }else{
                    toastEvent.setParams({
                        "title": "Error!",
                        "variant": "error", 
                        "message": "Đã có lỗi xảy ra"
                        });
                }
                toastEvent.fire();
            }else if (state === 'INCOMPLETE'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "variant": "warning",
                    "message": "Lỗi đường truyền"
                })
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action);
    }
})
