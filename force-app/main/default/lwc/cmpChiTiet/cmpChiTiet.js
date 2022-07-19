import { LightningElement, wire, api, track } from 'lwc';
import getDataStudent from '@salesforce/apex/AR_Student_Controller.getDataStudent';

export default class ModalChiTiet extends LightningElement {
    @track student;

    @track studentId;

    @api getIdStudent(id) {
        console.log('Id: '+ id);
        this.studentId = id;
        getDataStudent({id : this.studentId})
        .then(data => {
            this.student = JSON.parse(JSON.stringify(data));
            this.convertSex(this.student);
            console.log(JSON.stringify(this.student));
        })
        .catch(error => {
            console.log('NULL')
        })
    }

    convertSex(student) {
        if (student.Sex__c) {
            student.Sex__c = 'Nam'
        } else {
            student.Sex__c = 'Nữ'
        }
    }
}