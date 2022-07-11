({
    /**
	* doInit
	* lấy danh sách lớp
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    doInit: function(component, event, helper){
        helper.getClassPicklist(component, event);
    },

    /**
	* createStudent
	* Tạo mới học sinh bằng dữ liệu đã nhập vào
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    handleCreateStudent: function(component, event, helper) {
        helper.saveData(component, event);
    },

    /**
	* handleClassOnChange
	* Thay đổi Id Class khi thay đổi lớp
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    handleClassOnChange: function(component, event, helper){
        helper.changeClass(component, event);
    }

})
