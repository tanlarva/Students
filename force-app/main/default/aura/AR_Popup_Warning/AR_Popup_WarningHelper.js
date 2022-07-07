({
    deleteStudent : function(component, event, helper, idStudent) {
        component.set('v.loaded', !component.get('v.loaded'));
        var action = component.get('c.deleteStudent');
        action.setParams({
            deleteStudent : idStudent
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS'){
                component.set('v.loaded', !component.get('v.loaded'));
                component.find('notifLib').showToast({
                    "variant": "success",
                    "title": "Hoàn Tất",
                    "message": "Xóa thành công."
                });
                setTimeout(function(){
                    component.find("overlayLib").notifyClose();
                },1500);
            }else if(state === 'ERROR'){
                var error = response.getError();
                if (error){
                    component.find('notifLib').showToast({
                        "variant": "error",
                        "title": "Không thành công",
                        "message": error[0].message
                    });
                }
                setTimeout(function(){
                    component.find("overlayLib").notifyClose();
                },1500);
            }
        });
        $A.enqueueAction(action);
    }
})
