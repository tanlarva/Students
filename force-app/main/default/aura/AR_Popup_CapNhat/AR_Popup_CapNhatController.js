({
    /**
	* doInit
	* Check recordId nếu không có thì đi qua create
	* @param: 
	* @return:
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    doInit : function(component, event, helper) {
        helper.checkIdReady(component, event, helper);
    },

    /**
	* handleSaveStudent
	* Lưu lại thông tin học sinh sau khi thay đổi
	* @param: 
	* @return:
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    handleSaveStudent: function(component, event, helper) {
        helper.saveData(component, event);
    },

    /**
	* handleClassOnChange
	* Thay đổi Id Class khi thay đổi Class
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    handleClassOnChange: function(component, event, helper){
        helper.changeClass(component, event);
    }


})
