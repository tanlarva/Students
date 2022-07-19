import { LightningElement, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';


export default class PageSearchStudent extends LightningElement {
    showStudentId;
    handleShowStudent(evt) {
        //console.log('Page ' + JSON.stringify(evt.detail));
        this.showStudentId = evt.detail;
        this.template.querySelector('c-cmp-Chi-Tiet').getIdStudent(evt.detail);
    }
}