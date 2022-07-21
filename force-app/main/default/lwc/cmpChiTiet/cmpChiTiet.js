import { LightningElement, wire, api, track } from 'lwc';
import getDataStudent from '@salesforce/apex/AR_Student_Controller.getDataStudent';

/**
 * ClassName: ModalChiTiet
 * ClassDetail:
 * @Create: 2022/07/19 Phan Duy Tân
 * @Modify:
 */
export default class ModalChiTiet extends LightningElement {
    @track student; //Object chứa thông tin học sinh

    @track studentId; //Chứa Id học sinh từ cmpTimKiem

    /**
	* getIdStudent
	* Gắn Id từ cmpTimKiem vào studentId
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified:
	**/
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

    /**
	* convertSex
	* Chuyển true thành Nam, false thành Nữ cho Object Student__c
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified:
	**/
    convertSex(student) {
        if (student.Sex__c) {
            student.Sex__c = 'Nam'
        } else {
            student.Sex__c = 'Nữ'
        }
    }
}