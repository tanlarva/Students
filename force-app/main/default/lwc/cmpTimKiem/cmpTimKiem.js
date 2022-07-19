import { LightningElement, wire, api, track } from 'lwc';
import getListClass from '@salesforce/apex/AR_TimKiem_Controller.getListClass';
import getAllStudent from '@salesforce/apex/AR_TimKiem_Controller.getAllStudent';
import searchStudent from '@salesforce/apex/AR_TimKiem_Controller.searchStudent';
import deleteStudent from '@salesforce/apex/AR_TimKiem_Controller.deleteStudent';

const actions = [
    { label: 'Cập nhật', name: 'update' },
    { label: 'Xóa', name: 'delete' }
];
const columns = [
    { label: 'Họ', fieldName: 'firstName__c', type: 'text', sortable:true, cellAttributes: { class: { fieldName: 'checkCSSClass' }} },
    { label: 'Tên', fieldName: 'lastName__c', type: 'button', typeAttributes: {label: {fieldName: 'lastName__c'}, variant: 'base', name: 'view'}, sortable:true,cellAttributes: { class: { fieldName: 'checkCSSClass' }} },
    { label: 'Giới Tính', fieldName: 'Sex__c', type: 'text',cellAttributes: { class: { fieldName: 'checkCSSClass' }} },
    { label: 'Ngày Sinh', fieldName: 'dayOfBirth__c', type: 'text',cellAttributes: { class: { fieldName: 'checkCSSClass' }} },
    { label: 'Điểm Hóa', fieldName: 'Diem1__c', type: 'text' , sortable:true,cellAttributes: { class: { fieldName: 'checkCSSClass' }}},
    { label: 'Điểm Toán', fieldName: 'Diem2__c', type: 'text', sortable:true,cellAttributes: { class: { fieldName: 'checkCSSClass' }} },
    { label: 'Điểm Lý', fieldName: 'Diem3__c', type: 'text', sortable:true,cellAttributes: { class: { fieldName: 'checkCSSClass' }} },
    { label: 'Điểm Trung Bình', fieldName: 'GPA__c', type: 'text', sortable:true,cellAttributes: { class: { fieldName: 'checkCSSClass' }} },
    { label: 'Tình Trạng', fieldName: 'Status__c', type: 'text',cellAttributes: { class: { fieldName: 'checkCSSClass' }} },
    { type: 'action', typeAttributes: { rowActions: actions, menuAlignment: 'right' } }
];

export default class LWC_TimKiem extends LightningElement {
    dataSearch = {
        nameStudent : '' ,
        idClass : '0000000000TOTAL' ,
        startDate : '',
        endDate : '',
        sortName : true
    }
    @track columns = columns;
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
    error;
    //
    selectedStudent = [];
    studentCount;
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
    @wire(getAllStudent)
    wiredStudent({error, data}) {
        if (data) {
            this.dataStudent = JSON.parse(JSON.stringify(data));
            this.convertSex(this.dataStudent);
            this.checkCSSClass(this.dataStudent);
            this.totalRecountCount = this.dataStudent.length;
            this.endingRecord = this.dataStudent.length;
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
            this.currentPageSize = this.endingRecord - this.startingRecord + 1;
            this.dataStudentShow = this.dataStudent.slice(0, this.pageSize);
            //console.log('this.dataStudent:', JSON.stringify(this.dataStudentShow));
            this.error = undefined;
        } else if (error) {
            console.log('error:', error);
            this.error = error;
        }
    };

    previousHandler() {
        if (this.page > 1) {
            this.page = this.page - 1;
            this.displayRecordPerPage(this.page);
        }
    }

    nextHandler() {
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);            
        }             
    }
 
    get isPreviousDisable(){
        return (this.page == 1 ? true : false);
    }
 
    get isNextDisable(){
        return (this.page === this.totalPage || (this.page > this.totalPage)) ? true : false;
    }

    displayRecordPerPage(page){
        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);
 
        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 
 
        this.dataStudentShow = this.dataStudent.slice(this.startingRecord, this.endingRecord);
 
        this.startingRecord = this.startingRecord + 1;
 
        this.currentPageSize = this.endingRecord - this.startingRecord + 1;
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'delete':
                // this.deleteRow(row);
                console.log(JSON.stringify(row));
                break;
            case 'update':
                // this.showRowDetails(row);
                console.log(JSON.stringify(row));
                break;  
            case 'view':
                //console.log('row' + JSON.stringify(row));
                const event = new CustomEvent('selectedstudent', { detail: row.Id });
                this.dispatchEvent(event);
                break;
            default:
        }
    }

    handleChangeClass(event) {
        this.dataSearch.idClass = event.detail.value;
    }

    handleChangeName(event) {
        this.dataSearch.nameStudent = event.detail.value;
    }

    handleChangeDate1(event) {
        this.dataSearch.startDate = event.detail.value;
    }

    handleChangeDate2(event) {
        this.dataSearch.endDate = event.detail.value;
    }

    convertSex(dataStudent) {
        for(var x of dataStudent) {
            if (x.Sex__c) {
                x.Sex__c = 'Nam'
            } else {
                x.Sex__c = 'Nữ'
            }
        }
    }

    checkCSSClass(dataStudent) {
        for(var x of dataStudent){
            if(x.Status__c == 'Rớt'){
                x.checkCSSClass = 'false';
            }
        }
    }

    handleShowModalAdd() {
        const modal = this.template.querySelector("c-modal-Them-Moi");
        modal.show();
    }

    handleBtnSearch(event) {
        this.resetData();
        searchStudent({dataInput : this.dataSearch})
        .then (data => {
            console.log('Datasearch: '+ JSON.stringify(data))
            this.dataStudent = JSON.parse(JSON.stringify(data));
            this.convertSex(this.dataStudent);
            this.checkCSSClass(this.dataStudent);
            this.totalRecountCount = this.dataStudent.length;
            this.endingRecord = this.dataStudent.length;
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
            this.currentPageSize = this.endingRecord - this.startingRecord + 1;
            this.dataStudentShow = this.dataStudent.slice(0, this.pageSize);
            this.error = undefined;
        })
        .catch (error => {
            console.error(error);
            this.error = error;
        })
    }

    resetData() {
        this.dataStudent = null;
        this.page = 1;
        this.currentPageSize = 0;
        this.totalRecountCount = 0;
        this.totalPage = 0;
        this.startingRecord = 1; 
        this.endingRecord = 0;
        this.dataStudentShow = null;
    }

    getSelectedStudent(event) {        
        const selectedRows = event.detail.selectedRows;
        this.studentCount = event.detail.selectedRows.length;
        this.selectedStudent = event.detail.selectedRows;
    }

    handleBtnDelete(event) {
        deleteStudent()
    }
}