({
    /**
	* handleCancel
	* Nhấn nút cancel thì tắt modal
	* @param: 
	* @return: 
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    handleCancel : function(component, event, helper) {
        //closes the modal or popover from the component
        component.find("overlayLib").notifyClose();
    },

    /**
	* handleOK
	* Đồng ý thì sẽ xóa danh sách học sinh được gửi qua
	* @param: 
	* @return: Modal
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    handleOK : function(component, event, helper) {
        var idStudent = component.get("v.listDelete");
        helper.deleteStudent(component, event, helper, idStudent);
    }
})
