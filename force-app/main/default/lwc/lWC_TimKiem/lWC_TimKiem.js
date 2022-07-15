import { LightningElement, wire, api, track } from 'lwc';
import getListClass from '@salesforce/apex/AR_TimKiem_Controller.getListClass';
import getAllStudent from '@salesforce/apex/AR_TimKiem_Controller.getAllStudent';

const actions = [
    { label: 'Cập nhật', name: 'update' },
    { label: 'Xóa', name: 'delete' }
];

const columns = [
    { label: 'Họ', fieldName: 'firstName__c', type: 'text' },
    { label: 'Tên', fieldName: 'lastName__c', type: 'url' },
    { label: 'Giới Tính', fieldName: 'Sex__c', type: 'text'},
    { label: 'Ngày Sinh', fieldName: 'dayOfBirth__c'},
    { label: 'Điểm Hóa', fieldName: 'Diem1__c', type: 'text'},
    { label: 'Điểm Toán', fieldName: 'Diem2__c', type: 'text'},
    { label: 'Điểm Lý', fieldName: 'Diem3__c', type: 'text'},
    { label: 'Điểm Trung Bình', fieldName: 'GPA__c', type: 'text'},
    { label: 'Tình Trạng', fieldName: 'Status__c', type: 'text'},
    { type: 'action', typeAttributes: { rowActions: actions } }
];

export default class LWC_TimKiem extends LightningElement {
    @track listClass;
    @track dataStudent;
    @wire(getListClass)
    wiredClass({error, data}) {
        if (data) {
            this.listClass = Object.entries(data).map(([value, label]) => ({value, label}));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    };
    @wire(getAllStudent)
    wiredStudent({error, data}) {
        if (data) {
            console.log('data:', JSON.stringify(data));
            console.log('typeof:', typeof data);
            this.dataStudent = Object.values(data);
            console.log('this.dataStudent:', JSON.stringify(this.dataStudent));
            console.log('typeof:', typeof this.dataStudent);
            this.error = undefined;
        } else if (error) {
            console.log('error:', error);
            this.error = error;
            this.contacts = undefined;
        }
    };

    

    // get dataStudent() {
    //     return this.dataStudent;
    // }

    // get listClass() {
    //     return this.listClass;
    // }
    handleChangeClass(event) {
        this.chooseClass= event.detail.value;
    }
}