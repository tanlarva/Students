import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getListClass from '@salesforce/apex/AR_TimKiem_Controller.getListClass';
import createStudent from '@salesforce/apex/AR_Student_Controller.createStudent';

export default class LWC_ThemMoi extends LightningElement {
    showModal = false;
    loading = false;
    @track student = {
        firstName__c : '',
        lastName__c : '',
        Sex__c : true,
        dayOfBirth__c : '',
        Class__c : '',
        Diem1__c : '',
        Diem2__c : '',
        Diem3__c : '',
    }
    @track listClass;

    @api show() {
        this.showModal = true;
    }

    handleDialogClose() {
        this.showModal = false;
    }

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

    fnameChangedHandler(event) {
        this.student.firstName__c = event.detail.value;
    };
    lnameChangedHandler(event) {
        this.student.lastName__c = event.detail.value;
    };
    birthChangedHandler(event) {
        this.student.dayOfBirth__c = event.detail.value;
    };
    handleChangeClass(event) {
        this.student.Class__c = event.detail.value;
    };
    diem1ChangedHandler(event) {
        this.student.Diem1__c = event.detail.value;
    };
    diem2ChangedHandler(event) {
        this.student.Diem2__c = event.detail.value;
    };
    diem3ChangedHandler(event) {
        this.student.Diem3__c = event.detail.value;
    };

    handleCreateStudent() {
        this.loading = true;
        createStudent({dataStudent: this.student})
        .then ( ok => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Học sinh tạo thành công',
                    variant: 'success',
                }),
            );
            setTimeout(function(){
                this.showModal = false;
            },1500);
        })
        .catch ( error => {
            //console.log('error'+JSON.stringify(error))
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating',
                    message: error.body.message,
                    variant: 'error',
                }),
            );
            setTimeout(function(){
                this.showModal = false;
            },1500);
        })
    }

    get optionsSex() {
        return [
            { label: 'Nam', value: true },
            { label: 'Nữ', value: false },
        ];
    }
}