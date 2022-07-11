/**
 * HelperName: AR_Popup_ThemmoiHelper
 * Detail: Xử lí ẩn page Thêm mới
 * @created: 2022/05/07 Phan Duy Tân
 * @modified:
 */
({
    saveData : function(component, event){
        var action = component.get('c.createStudent');
        var dataStudent = component.get("v.dataStudent");
        component.set("v.loaded",!component.get("v.loaded"));
        action.setParams({
            dataStudent : dataStudent
        })

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success", 
                    "message": "Tạo mới thành công."
                });
                toastEvent.fire(); 
                setTimeout(function(){
                    if(component.get("v.isPopup")){
                        component.find("overlayLib").notifyClose();
                    }else{
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": "/lightning/o/Student__c/new"
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
                            "type": "error", 
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
                    "variant": "warning", 
                    "message": "Không phản hồi từ phía sever."
                });
                toastEvent.fire();
            }
        })

        $A.enqueueAction(action);
    },

    /**
	* getClassPickList
	* Lấy danh sách các lớp
	* @param: 
	* @return: Map<string, string>
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
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
                component.set('v.options', classMap);
                component.set('v.dataStudent.Class__c', classMap[0].key);
            }
        });
        $A.enqueueAction(action);
    },

    /**
	* changeClass
	* Thay đổi Id class khi thay đổi class
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
