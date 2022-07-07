({
    getClassPicklist : function(component, event){
        var action = component.get('c.getListClass');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                var classMap = [];
                classMap.push({key: '', value: 'Tất Cả', selected: true});
                for(var key in result){
                    classMap.push({key: key, value: result[key]});
                }
                component.set('v.options', classMap);
            }
        });
        $A.enqueueAction(action);
    },

    changeClass: function(component, event){
        var temp = component.find('classPicklist').get('v.value');
        component.set('v.dataSearch.idClass', temp);
    },

    createTable: function(component, event, helper){
        var actions = [
            { label: 'Cập nhật', name: 'update' },
            { label: 'Xóa', name: 'delete' }
        ];
        
        component.set('v.columns', [
            { label: 'Họ', fieldName: 'firstName__c', type: 'text', sortable:true },
            { label: 'Tên', fieldName: 'lastName__c', type: 'text', sortable:true },
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
                component.set('v.listStudent', result);
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

    fetchAllData: function(component, event, helper){
        helper.createTable(component, event, helper);
        var action = component.get('c.getAllStudent');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set('v.listStudent', result);
                //Phân trang
                helper.preparePagination(component, result);
            }
        });
        $A.enqueueAction(action);
    },

    preparePagination: function (component, records) {
        let countTotalPage = Math.ceil(records.length / component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        component.set("v.totalRecords", records.length);
        this.setPaginateData(component);
    },
     
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

    createStudent: function(component){
        $A.createComponent('c:AR_Popup_ThemMoi',
                            {isPopup: true},
                            function(result,state){
                                if(state === 'SUCCESS'){
                                    component.find('overlayPopup').showCustomModal({
                                        body : result,
                                        showCloseButton : true,
                                    })
                                }
                            })
    },

    updateStudent: function(component, event, helper, student){
        $A.createComponent('c:AR_Popup_CapNhat',
                            { recordId : student.Id,
                                isPopup : true},
                            function(result,state){
                                if(state === 'SUCCESS'){
                                    component.find('overlayPopup').showCustomModal({
                                        body : result,
                                        showCloseButton : true,
                                    })
                                }
                            })
    },

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
                                            this.fetchDataSearch(component, event, helper);
                                        }
                                    })
                                }
                            })
    },

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
                                            this.fetchDataSearch(component, event, helper);
                                        }
                                    })
                                }
                            })
    }
})
