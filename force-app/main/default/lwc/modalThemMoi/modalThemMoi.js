import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getListClass from '@salesforce/apex/AR_TimKiem_Controller.getListClass';
import createStudent from '@salesforce/apex/AR_Student_Controller.createStudent';

/**
 * ClassName: ModalThemMoi
 * ClassDetail:
 * @Create: 2022/07/19 Phan Duy Tân
 * @Modify:
 */
export default class ModalThemMoi extends LightningElement {
    @track showModal = false;
    @track loading = false;
    @track listClass;
    @track student = {
        firstName__c : '',
        lastName__c : '',
        Sex__c : true,
        dayOfBirth__c : '',
        Class__c : '',
        Diem1__c : '',
        Diem2__c : '',
        Diem3__c : '',
    };

    /**
	* show
	* Dùng để mở Modal và tạo object student
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 2022/07/20 Phan Duy Tân
	**/
    @api show() {
        this.showModal = true;
        this.loading = false;
        this.student = {
            firstName__c : '',
            lastName__c : '',
            Sex__c : true,
            dayOfBirth__c : '',
            Class__c : '',
            Diem1__c : '',
            Diem2__c : '',
            Diem3__c : '',
        }
    };

    /**
	* handleDialogClose
	* Dùng để đóng Modal
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 2022/07/20 Phan Duy Tân
	**/
    handleDialogClose() {
        this.showModal = false;
    };

    //Lấy danh sách lớp
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

    //Đổi giá trị trong student khi nhập Họ
    fnameChangedHandler(event) {
        this.student.firstName__c = event.detail.value;
    };

    //Đổi giá trị trong student khi nhập Tên
    lnameChangedHandler(event) {
        this.student.lastName__c = event.detail.value;
    };

    //Đổi giá trị trong student khi nhập Ngày sinh
    birthChangedHandler(event) {
        this.student.dayOfBirth__c = event.detail.value;
    };

    //Đổi giá trị trong student khi thay đổi lớp
    handleChangeClass(event) {
        this.student.Class__c = event.detail.value;
    };

    //Đổi giá trị trong student khi nhập điểm Hóa
    diem1ChangedHandler(event) {
        this.student.Diem1__c = event.detail.value;
    };

    //Đổi giá trị trong student khi nhập điểm Toán
    diem2ChangedHandler(event) {
        this.student.Diem2__c = event.detail.value;
    };

    //Đổi giá trị trong student khi nhập điểm Lý
    diem3ChangedHandler(event) {
        this.student.Diem3__c = event.detail.value;
    };

    /**
	* handleCreateStudent
	* Sự kiện khi ấn nút Tạo mới
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 2022/07/20 Phan Duy Tân
	**/
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
            const reset = new CustomEvent('resettable',{detail: true});
            this.dispatchEvent(reset);
            this.showModal = false;
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
            this.showModal = false;
        })
    };

    //Đổi giá trị trong student khi thay đổi giới tính
    handleChangeSex(event) {
        this.student.Sex__c = event.detail.value;
    };

    //Gắn giá trị cho radio-group
    get optionsSex() {
        return [
            { label: 'Nam', value: true },
            { label: 'Nữ', value: false },
        ];
    };
}