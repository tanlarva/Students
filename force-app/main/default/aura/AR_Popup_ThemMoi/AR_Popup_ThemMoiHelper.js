({
    saveData : function(cmp){
        var action = cmp.get('c.newStudent');
        // var dataStudent = cmp.get('v.dataStudent');
        action.setParams({
            'dataStudent': cmp.get('v.dataStudent')
        })

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Tạo mới thành công."
                });
                toastEvent.fire(); 
            }else if(state === 'ERROR'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": errors[0].message
                        });
                        toastEvent.fire();
                    }
                } else {
                    console.log("Unknown error");
                }
            }else if(state === 'INCOMPLETE'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Warning!",
                    "message": "Không phản hồi từ phía sever."
                });
                toastEvent.fire();
            }
        })

        $A.enqueueAction(action);
    },

    getClassPicklist : function(component, event){
        var action = component.get('c.getListClass');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                var classMap = [];
                for(var key in result){
                    classMap.push({key: key, value: result[key]});
                }
                component.set('v.classMap', classMap);
            }
        });
        $A.enqueueAction(action);
    },
})