({
    /**
	* getClassPickList
	* Lấy danh sách các lớp
	* @param: 
	* @return: Map<String, String>
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    getClassPicklist : function(component, event){
        var action = component.get('c.getListClass');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                var classMap = [];
                classMap.push({key: '0000000000TOTAL' , value: 'Tất Cả', selected: true});
                for(var key in result){
                    classMap.push({key: key, value: result[key]});
                }
                component.set('v.options', classMap);
            }
        });
        $A.enqueueAction(action);
    },

    /**
	* changeClass
	* Chuyển đổi Id lớp khi thay đổi
	* @param: 
	* @return: String
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    changeClass: function(component, event){
        var temp = component.find('classPicklist').get('v.value');
        component.set('v.dataSearch.idClass', temp);
    },

    /**
	* createTable
	* Tạo form Bảng chứa dữ liệu tìm kiếm
	* @param: 
	* @return: Table
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    createTable: function(component, event, helper){
        var actions = [
            { label: 'Cập nhật', name: 'update' },
            { label: 'Xóa', name: 'delete' }
        ];
        
        component.set('v.columns', [
            { label: 'Họ', fieldName: 'firstName__c', type: 'text', sortable:true },
            { label: 'Tên', fieldName: 'lastName__c', type: 'button', typeAttributes: {label: {fieldName: 'lastName__c'}, variant: 'base', name: 'view'}, sortable:true },
            { label: 'Giới Tính', fieldName: 'Sex__c', type: 'text' },
            { label: 'Ngày Sinh', fieldName: 'dayOfBirth__c', type: 'text' },
            { label: 'Điểm Hóa', fieldName: 'Diem1__c', type: 'text' , sortable:true},
            { label: 'Điểm Toán', fieldName: 'Diem2__c', type: 'text', sortable:true },
            { label: 'Điểm Lý', fieldName: 'Diem3__c', type: 'text', sortable:true },
            { label: 'Điểm Trung Bình', fieldName: 'GPA__c', type: 'text', sortable:true },
            { label: 'Tình Trạng', fieldName: 'Status__c', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
    },

    /**
	* fetchDataSearch
	* Load data sau khi seach lên
	* @param: 
	* @return: List
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    fetchDataSearch: function(component, event, helper){
        helper.createTable(component, event, helper);
        component.set("v.loaded", !component.get("v.loaded"));
        var dataInput = component.get("v.dataSearch");
        var action = component.get('c.searchStudent');
        action.setParams({ 
            dataInput: dataInput
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set("v.loaded", !component.get("v.loaded"));
                var result = response.getReturnValue();
                helper.convertSex(result);
                component.set('v.listStudent', result);
                component.set('v.countStudent', result.length)
                //Phân trang
                helper.preparePagination(component, result);
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
            }
        });
        $A.enqueueAction(action);
    },

    /**
	* fetchAllData
	* Load toàn bộ data học sinh
	* @param: 
	* @return: List
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    fetchAllData: function(component, event, helper){
        helper.createTable(component, event, helper);
        var action = component.get('c.getAllStudent');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                helper.convertSex(result);
                component.set('v.listStudent', result);
                //Phân trang
                component.set('v.countStudent', result.length)
                helper.preparePagination(component, result);
            }
        });
        $A.enqueueAction(action);
    },

    /**
	* preparePagination
	* Set phân trang đầu tiên và tính toán phân trang
	* @param: 
	* @return:
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    preparePagination: function (component, records) {
        let countTotalPage = Math.ceil(records.length / component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        component.set("v.totalRecords", records.length);
        this.setPaginateData(component);
    },

    /**
	* setPaginateData
	* Tạo List Show cho từng trang khi đi tới
	* @param: 
	* @return:
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    setPaginateData: function(component){
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let accountData = component.get('v.listStudent');
        let currentPageCount = 0;
        let x = (pageNumber - 1) * pageSize;
        currentPageCount = x;
        for (; x < (pageNumber) * pageSize; x++){
            if (accountData[x]) {
                data.push(accountData[x]);
                currentPageCount++;
            }
        }
        component.set("v.listStudentShow", data);
        component.set("v.currentPageRecords", currentPageCount);
    },

    /**
	* createStudent
	* Gửi dữ liệu sau khi điền và đưa đến AR_TimKiem_Controller
	* @param: 
	* @return: Modal
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    createStudent: function(component, event, helper){
        $A.createComponent('c:AR_Popup_ThemMoi',
                            {isPopup: true},
                            function(result,state){
                                if(state === 'SUCCESS'){
                                    component.find('overlayPopup').showCustomModal({
                                        body : result,
                                        showCloseButton : true,
                                        closeCallback: function () {
                                            helper.fetchDataSearch(component, event, helper);
                                        }
                                    })
                                }
                            })
    },

    /**
	* updateStudent
	* Đưa Id cảu từng record đi để mở form chỉnh sửa cho từng đối tượng
	* @param: 
	* @return: Modal
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    updateStudent: function(component, event, helper, student){
        $A.createComponent('c:AR_Popup_CapNhat',
                            { recordId : student.Id,
                                isPopup : true},
                            function(result,state){
                                if(state === 'SUCCESS'){
                                    component.find('overlayPopup').showCustomModal({
                                        body : result,
                                        showCloseButton : true,
                                        closeCallback: function () {
                                            helper.fetchDataSearch(component, event, helper);
                                            alert(JSON.stringify(component.get('v.listStudent')));
                                        }
                                    })
                                }
                            })
    },

    /**
	* deleteStudent
	* Đưa list học sinh đi đến modal Warning để xác nhận xóa
	* @param: 
	* @return: Modal
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    deleteStudent: function(component, event, helper, student){
        var listDelete = [];
        listDelete.push(student);
        $A.createComponent('c:AR_Popup_Warning',
                            { listDelete : listDelete},
                            function(result,state){
                                if(state === 'SUCCESS'){
                                    component.find('overlayPopup').showCustomModal({
                                        header : 'Bạn có chắc chắn muốn xóa không ?',
                                        body : result,
                                        showCloseButton : false,
                                        cssClass : 'center',
                                        closeCallback : function(){
                                            helper.fetchDataSearch(component, event, helper);
                                        }
                                    })
                                }
                            })
    },

    /**
	* deleteStudent
	* Đưa list học sinh đi đến modal Warning để xác nhận xóa
	* @param: 
	* @return: Modal
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    deleteAllStudent: function(component, event, helper, listStudent){
        $A.createComponent('c:AR_Popup_Warning',
                            { listDelete : listStudent},
                            function(result,state){
                                if(state === 'SUCCESS'){
                                    component.find('overlayPopup').showCustomModal({
                                        header : 'Bạn có chắc chắn muốn xóa không ?',
                                        body : result,
                                        showCloseButton : false,
                                        cssClass : 'center',
                                        closeCallback : function(){
                                            helper.fetchDataSearch(component, event, helper);
                                        }
                                    })
                                }
                            })
    },

    /**
	* viewStudent
	* Đưa Id học sinh đi để mở Form chi tiết học sinh
	* @param: 
	* @return: Modal
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    viewStudent: function(component, event, helper, student){
        $A.createComponent('c:AR_Popup_ChiTiet',
                            { recordId: student.Id},
                            function(result,state){
                                if(state === 'SUCCESS'){
                                    component.find('overlayPopup').showCustomModal({
                                        body : result,
                                        showCloseButton : true
                                    })
                                }
                            })
    },

    /**
	* convertSex
	* Chuyển đổi giới tính từ true:Nam - false:Nữ
	* @param: 
	* @return:
	* @created: 2022/07/08 Phan Duy Tân
	* @modified:
	**/
    convertSex: function (listStudent){
        for(var x of listStudent){
            if(x.Sex__c){
                x.Sex__c = 'Nam'
            }else{
                x.Sex__c = 'Nữ'
            }
        }
    }, 

    /**
	* sortStudent
	* Thay đổi các thông số và set name field cần sort
	* @param: 
	* @return: 
	* @created: 2022/07/11 Phan Duy Tân
	* @modified:
	**/
    sortStudent: function (component, event) {
        var sortedBy = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');

        var cloneData = component.get('v.listStudent');
        cloneData.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));

        component.set('v.listStudent', cloneData);
        component.set('v.sortDirection', sortDirection);
        component.set('v.sortedBy', sortedBy);
        this.preparePagination(component, cloneData);
    },

    /**
	* sortBy
	* Giải thuật sort tăng dần hay giảm dần
	* @param: 
	* @return:
	* @created: 2022/07/11 Phan Duy Tân
	* @modified:
	**/
    sortBy: function(field, reverse, primer){
        var key = primer
            ? function (x) {
                return primer(x[field]);
                }
            : function (x) {
                return x[field];
            };
        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }
})
