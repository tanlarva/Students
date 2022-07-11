({
    /**
	* doInit
	* lấy toàn bộ dữ liệu Học sinh và danh sách lớp
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    doInit : function(component, event, helper) {
        helper.getClassPicklist(component, event);
        helper.fetchAllData(component, event, helper);
    },

    /**
	* handleClassOnChange
	* Khi thay đổi lựa chọn lớp thì thay đổi giá trị chọn
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    handleClassOnChange : function(component, event, helper) {
        helper.changeClass(component, event);
    },

    /**
	* handleCreateStudent
	* Sự kiện khi ấn nút thì gọi modal tạo mới học sinh
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    handleCreateStudent : function(component, event, helper) {
        helper.createStudent(component, event, helper);
    },

    /**
	* handleSearchStudent
	* Sự kiện khi ấn nút search thực hiện tìm kiếm học sinh
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    handleSearchStudent : function(component, event, helper) {
        helper.fetchDataSearch(component, event, helper);
    },

    /**
	* handleDeleteStudent
	* Sự kiện khi ấn nút xóa hết
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
    handleDeleteStudent : function(component, event, helper) {
        var student = component.get('v.selectedStudent');
        helper.deleteAllStudent(component, event, helper, student);
    },

    /**
	* handleActionRow
	* các button trong bảng cho các sự kiện (update, delete, view) cho từng row
	* @param: 
	* @return: 
	* @created: 2022/07/06 Phan Duy Tân
	* @modified:
	**/
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
            case 'view':
                helper.viewStudent(component, event, helper, row);
                break;
        }
    },

    /**
	* handleSort
	* sắp xếp theo thứ tự tăng dần hay giảm dần của các đối tượng
	* @param: 
	* @return: 
	* @created: 2022/07/11 Phan Duy Tân
	* @modified:
	**/
    handleSort: function(component, event, helper){
        helper.sortStudent(component, event);
    },

    /**
	* handleRowSelection
	* khi ấn vào nút checkbox thì sẽ cặp nhật lại danh sách được chọn
	* @param: 
	* @return: 
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    handleRowSelection : function(component, event, helper) {
        var selected = event.getParam("selectedRows");
        var setRows = [];
        for( var i = 0; i < selected.length; i++){
            setRows.push(selected[i]);
        }
        component.set('v.selectedStudent',setRows);
    },

    /**
	* handleNext
	* Sự kiện nhấn nút next để chuyển trang
	* @param: 
	* @return: 
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    handleNext : function(component, event, helper){        
        component.set("v.currentPageNumber", component.get("v.currentPageNumber") + 1);
        helper.setPaginateData(component);
    },

    /**
	* handlePrevious
	* Sự kiện nhấn nút previous để lùi trang
	* @param: 
	* @return: 
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    handlePrevious : function(component, event, helper){
       component.set("v.currentPageNumber", component.get("v.currentPageNumber") - 1);
       helper.setPaginateData(component);
    },

/**
	* onFirst
	* Sự kiện nhấn nút First để đi đến trang đầu
	* @param: 
	* @return: 
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.setPaginateData(component);
    },

    /**
	* onFirst
	* Sự kiện nhấn nút End để đi đến trang cuối
	* @param: 
	* @return: 
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.setPaginateData(component);
    },

})
