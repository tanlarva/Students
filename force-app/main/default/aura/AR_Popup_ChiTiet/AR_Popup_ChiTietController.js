({
    /**
	* doInit
	* Lấy dữ liệu học sinh bằng Id
	* @param: 
	* @return: Modal
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    doInit : function(component, event, helper) {
        helper.getDataStudent(component, event);
    }
})
