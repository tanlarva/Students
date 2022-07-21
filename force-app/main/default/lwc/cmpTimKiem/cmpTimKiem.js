import { LightningElement, wire, api, track } from 'lwc';
import getListClass from '@salesforce/apex/AR_TimKiem_Controller.getListClass';
import getAllStudent from '@salesforce/apex/AR_TimKiem_Controller.getAllStudent';
import searchStudent from '@salesforce/apex/AR_TimKiem_Controller.searchStudentLWC';

//Tạo cho Actions
const ACTIONS = [
    { label : 'Cập nhật', name : 'update' },
    { label : 'Xóa', name : 'delete' }
];

//Tạo form cho bảng
const COLUMNS = [
    {label : 'Họ', fieldName : 'firstName__c', type : 'text', sortable : true, cellAttributes : {class : {fieldName : 'checkCSSClass'}}},
    {label : 'Tên', fieldName : 'lastName__c', type : 'button', typeAttributes : {label : {fieldName : 'lastName__c'}, variant : 'base', name : 'view'}, sortable : true, cellAttributes : { class : { fieldName: 'checkCSSClass' }}},
    {label : 'Giới Tính', fieldName : 'Sex__c', type : 'text', cellAttributes : { class: { fieldName : 'checkCSSClass' }}},
    {label : 'Ngày Sinh', fieldName : 'dayOfBirth__c', type : 'text', cellAttributes : {class : {fieldName : 'checkCSSClass'}}},
    {label : 'Điểm Hóa', fieldName : 'Diem1__c', type : 'text' , sortable : true, cellAttributes : {class : {fieldName : 'checkCSSClass'}}},
    {label : 'Điểm Toán', fieldName : 'Diem2__c', type : 'text', sortable : true, cellAttributes : {class : {fieldName : 'checkCSSClass'}}},
    {label : 'Điểm Lý', fieldName : 'Diem3__c', type : 'text', sortable : true, cellAttributes : {class : {fieldName : 'checkCSSClass'}}},
    {label : 'Điểm Trung Bình', fieldName : 'GPA__c', type : 'text', sortable : true, cellAttributes : {class : {fieldName : 'checkCSSClass'}}},
    {label : 'Tình Trạng', fieldName : 'Status__c', type : 'text', cellAttributes : {class : {fieldName : 'checkCSSClass'}}},
    {type : 'action', typeAttributes : {rowActions : ACTIONS, menuAlignment : 'right' }}
];

/**
 * ClassName: cmpTimKiem
 * ClassDetail:
 * @Create: 2022/07/19 Phan Duy Tân
 * @Modify:
 */
export default class cmpTimKiem extends LightningElement {
    dataSearch = {
        nameStudent : '' ,
        idClass : '0000000000TOTAL' ,
        startDate : '',
        endDate : '',
        sortName : true
    }

    columns = COLUMNS;
    @track page = 1; //initialize 1st page
    @track currentPageSize = 0;
    @track pageSize = 5; //default value we are assigning
    @track totalRecountCount = 0; //total record count received from all retrieved records
    @track totalPage = 0;
    @track startingRecord = 1; //start record position per page
    @track endingRecord = 0; //end record position per page
    @track listClass;
    @track dataStudent;
    @track dataStudentShow;
    @track sortBy;
    @track sortDirection;
    error;
    selectedStudent = [];
    countStudent;
    loading = false;

    /**
	* connectedCallBack()
	* Gắn CSS vào Style 
	* @param: 
	* @return: 
	* @created: 2022/07/21 Phan Duy Tân
	* @modified:
	**/
    connectedCallback() {
        const cssStyle= document.createElement("style");
        cssStyle.innerText = ".not-pass {background: orange;}";
        document.body.appendChild(cssStyle);
    }

    //Lấy data lớp
    @wire(getListClass)
    wiredClass({error, data}) {
        if (data) {
            this.listClass = Object.entries(data).map(([value, label]) => ({value, label}));
            this.listClass.push({
                label: 'Tất Cả', 
                value: '0000000000TOTAL'
            });
            //console.log(JSON.stringify(this.listClass))
            this.error = undefined;
        } else if (error) {
            this.error = error;
        }
    };

    //Lấy data toàn bộ học sinh
    @wire(getAllStudent)
    wiredStudent({error, data}) {
        if (data) {
            this.loading = true;
            this.setupData(data);
            //console.log('this.dataStudent:', JSON.stringify(this.dataStudentShow));
            this.error = undefined;
        } else if (error) {
            console.log('error:', error);
            this.error = error;
        }
    };

    /**
	* setupData
	* Gắn dữ liệu và phần trang
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 2022/07/20 Phan Duy Tân
	**/
    setupData(data) {
        this.dataStudent = JSON.parse(JSON.stringify(data));
        this.countStudent = this.dataStudent.length;
        this.convertSex(this.dataStudent);
        this.checkCSSClass(this.dataStudent);
        this.totalRecountCount = this.dataStudent.length;
        this.endingRecord = this.dataStudent.length;
        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
        this.currentPageSize = this.endingRecord - this.startingRecord + 1;
        this.dataStudentShow = this.dataStudent.slice(0, this.pageSize);
        this.loading = false;
    };

    /**
	* setupDataSort
	* Gắn dữ liệu và phần trang sau khi sort
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 2022/07/20 Phan Duy Tân
	**/
    setupDataSort(data) {

        this.dataStudent = [...data]
        this.countStudent = this.dataStudent.length;
        this.totalRecountCount = this.dataStudent.length;
        this.endingRecord = this.dataStudent.length;
        this.displayRecordPerPage(this.page);
        this.loading = false;
        
    }

    /**
	* previousHandler
	* Trở về trang trước
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified:
	**/
    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }
    };

    /**
	* nextHandler
	* Đi tiếp trang tiếp theo
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified:
	**/
    nextHandler() {
        if ((this.page<this.totalPage) && this.page !== this.totalPage) {
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);            
        }
    };

    //Disable button previous khi wor trang 1
    get isPreviousDisable(){
        return (this.page == 1 ? true : false);
    };

    //Disable button next khi wor trang cuối
    get isNextDisable(){
        return (this.page === this.totalPage || (this.page > this.totalPage)) ? true : false;
    };

    /**
	* displayRecordPerPage
	* Gắn dữ liệu và phần trang
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified:
	**/
    displayRecordPerPage(page){
        this.startingRecord = ((page - 1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);
 
        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 
 
        this.dataStudentShow = this.dataStudent.slice(this.startingRecord, this.endingRecord);
 
        this.startingRecord = this.startingRecord + 1;
 
        this.currentPageSize = this.endingRecord - this.startingRecord + 1;
    };

    /**
	* handleRowAction
	* Sự kiện update view delete cho từng row
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 2022/07/20 Phan Duy Tân
	**/
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'delete':
                console.log(JSON.stringify(row));
                this.template.querySelector('c-modal-Confirm-Delete').show1Student(row);
                break;
            case 'update':
                // this.showRowDetails(row);
                console.log(JSON.stringify(row));
                this.template.querySelector('c-modal-Cap-Nhat').show(row);
                break;  
            case 'view':
                //console.log('row' + JSON.stringify(row));
                const event = new CustomEvent('selectedstudent', { detail: row.Id });
                this.dispatchEvent(event);
                break;
            default:
        }
    };

    //Đổi giá trị trong dataSearch khi đổi lớp
    handleChangeClass(event) {
        this.dataSearch.idClass = event.detail.value;
    };

    //Đổi giá trị trong dataSearch khi nhập tên
    handleChangeName(event) {
        this.dataSearch.nameStudent = event.detail.value;
    };

    //Đổi giá trị trong dataSearch khi nhập ngày bắt đầu
    handleChangeDate1(event) {
        this.dataSearch.startDate = event.detail.value;
    };

    //Đổi giá trị trong dataSearch khi nhập ngày kêt thúc
    handleChangeDate2(event) {
        this.dataSearch.endDate = event.detail.value;
    };

    /**
	* convertSex
	* Chuyển true thành Nam, false thành Nữ trong data trả về
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 
	**/
    convertSex(dataStudent) {
        for(var x of dataStudent) {
            if (x.Sex__c) {
                x.Sex__c = 'Nam'
            } else {
                x.Sex__c = 'Nữ'
            }
        }
    };

    /**
	* checkCSSClass
	* Đánh dấu học sinh rớt bằng màu class
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 
	**/
    checkCSSClass(dataStudent) {
        for(var x of dataStudent){
            if(x.Status__c == 'Rớt'){
                x.checkCSSClass = 'not-pass';
            }
        }
    };

    /**
	* handleShowModalAdd
	* Mở modal thêm mới
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified:
	**/
    handleShowModalAdd() {
        const modal = this.template.querySelector("c-modal-Them-Moi");
        modal.show();
    };

    /**
	* handleBtnSearch
	* Sự kiện khi nhân nút Tìm Kiếm
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified:
	**/
    handleBtnSearch(event) {
        this.loading = true;
        this.resetData();
        searchStudent({dataInput : this.dataSearch})
        .then (data => {
            //console.log('Datasearch: '+ JSON.stringify(data))
            this.setupData(data);
            this.error = undefined;
        })
        .catch (error => {
            console.error(error);
            this.error = error;
        })
    };

    /**
	* resetData
	* reset lại dữ liệu khi thay đổi dữ liệu
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 2022/07/20 Phan Duy Tân
	**/
    resetData() {
        this.dataStudent = null;
        this.page = 1;
        this.currentPageSize = 0;
        this.totalRecountCount = 0;
        this.totalPage = 0;
        this.startingRecord = 1; 
        this.endingRecord = 0;
        this.dataStudentShow = null;
        this.countStudent = 0;
    };

    /**
	* getSelectedStudent
	* Lấy danh sách học sinh được chọn
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 2022/07/20 Phan Duy Tân
	**/
    getSelectedStudent(event) {
        const selectedRows = event.detail.selectedRows;
        this.studentCount = event.detail.selectedRows.length;
        this.selectedStudent = event.detail.selectedRows;
    };

    /**
	* handleBtnDelete
	* Sự kiện khi ấn nút Xóa Hết
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 2022/07/20 Phan Duy Tân
	**/
    handleBtnDelete(event) {
        if (this.selectedStudent.length > 0) {
            this.template.querySelector('c-modal-Confirm-Delete').show();
        }
    };

    /**
	* handleSortStudent
	* sự kiện Sort Table
	* @param: 
	* @return: 
	* @created: 2022/07/20 Phan Duy Tân
	* @modified: 2022/07/21 Phan Duy Tân
	**/
    handleSortStudent(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortStudent(event.detail.fieldName, event.detail.sortDirection);
    }

    /**
	* setupData
	* Sắp xếp lại dữ liệu
	* @param: 
	* @return: 
	* @created: 2022/07/20 Phan Duy Tân
	* @modified: 2022/07/21 Phan Duy Tân
	**/
    sortStudent(fieldName, direction) {
        this.loading = true;
        let parseData = this.dataStudent;
        let keyValue = (a) => {
            return a[fieldName];
        };
        let isReverse = direction === 'asc' ? 1: -1;
        if (fieldName == 'Diem1__c' || fieldName == 'Diem2__c' || fieldName == 'Diem3__c' || fieldName == 'GPA__c') {
            parseData.sort((x, y) => {
                x = keyValue(x) ? keyValue(x) : ''; 
                y = keyValue(y) ? keyValue(y) : '';
                return isReverse * ((x > y) - (y > x));
            });
        } else {
            console.log('sort chart');
            parseData.sort((x, y) => {
                x = keyValue(x) ? keyValue(x) : ''; 
                y = keyValue(y) ? keyValue(y) : '';
                return isReverse * (x.toLowerCase().localeCompare(y.toLowerCase()) - y.toLowerCase().localeCompare(y.toLowerCase()));
            });
        }
        this.setupDataSort(parseData);
    }

}