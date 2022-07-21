import { LightningElement, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';


export default class PageSearchStudent extends LightningElement {
    showStudentId; // Chứa Id student cho cmpChiTiet

    /**
	* handleShowStudent
	* Đưa giá trị Id cho cmpChiTiet
	* @param: 
	* @return: 
	* @created: 2022/07/18 Phan Duy Tân
	* @modified: 2022/07/19 Phan Duy Tân
	**/
    handleShowStudent(evt) {
        //console.log('Page ' + JSON.stringify(evt.detail));
        this.showStudentId = evt.detail;
        this.template.querySelector('c-cmp-Chi-Tiet').getIdStudent(evt.detail);
    }
}