import { LightningElement, wire, api, track } from 'lwc';
import getListClass from '@salesforce/apex/AR_Student_Controller.getListClass';

export default class LWC_TimKiem extends LightningElement {
    @track listClass;
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
    get listClass() {
        return this.listClass;
    }
    handleChangeClass(event) {
        this.chooseClass= event.detail.value;
    }
}