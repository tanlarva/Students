({
    /**
	* checkIdReady
	* Check recordId nếu không có thì đi qua create
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    checkIdReady : function(component, event, helper) {
        component.set("v.loaded",!component.get("v.loaded"));
        var idRecord = component.get("v.recordId");
        
        if(idRecord==null){
            var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/lightning/o/Student__c/new"
                    });
            urlEvent.fire();
        }else{
            var action1 = component.get('c.getDataStudent');
            action1.setParams({
                id : idRecord
            });
            action1.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
                    component.set("v.dataStudent", response.getReturnValue());
                    helper.getClassPicklist(component, event);
                    component.set("v.loaded",!component.get("v.loaded"));
                }else if(state === 'ERROR'){
                    component.set("v.loaded",!component.get("v.loaded"));
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
                    component.set("v.loaded",!component.get("v.loaded"));
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Warning!",
                        "message": "Không phản hồi từ phía sever."
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action1);
            
        }
    },

    /**
	* saveData
	* Lưu dữ liệu sau khi thay đổi trong form
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    saveData : function(component, event, helper){
        var action = component.get('c.updateStudent');
        var dataStudent = component.get("v.dataStudent");
        component.set("v.loaded",!component.get("v.loaded")); //Mở loading
        action.setParams({
            dataStudent : dataStudent
        })

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.find('notifLib').showToast({
                    "variant": "success",
                    "title": "Hoàn Tất",
                    "message": "Cập nhật thành công !!"
                });
                setTimeout(function(){
                    if(component.get('v.isPopup')){
                        component.find("overlayPopupCapNhat").notifyClose();
                    }else{
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": "lightning/r/Student__c/"+dataStudent.Id+"/view"
                        });
                        urlEvent.fire();  
                    } 
                },1500);
            }else if(state === 'ERROR'){
                component.set("v.loaded",!component.get("v.loaded"));
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
                component.set("v.loaded",!component.get("v.loaded"));
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

    /**
	* getClassPickList
	* Lấy danh sách lớp cho selection
	* @param: 
	* @return: Map<String, String>
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    getClassPicklist : function(component, event, selected){
        var action = component.get('c.getListClass');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                var classMap = [];
                for(var key in result){
                    if(key == component.get('v.dataStudent.Class__c')){
                        classMap.push({key: key, value: result[key], selected: true});
                    }else{
                        classMap.push({key: key, value: result[key], selected: false});
                    }
                }
                component.set('v.options', classMap);
            }
        });
        $A.enqueueAction(action);
    },  

    /**
	* changeClass
	* Thay đổi Id Class khi thay đổi lựa chọn
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    changeClass: function(component, event){
        var temp = component.find('classPicklist').get('v.value');
        component.set('v.dataStudent.Class__c', temp);
    }


})
