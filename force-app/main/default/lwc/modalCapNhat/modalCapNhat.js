import { LightningElement, wire, api, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getListClass from '@salesforce/apex/AR_TimKiem_Controller.getListClass';
import updateStudent from '@salesforce/apex/AR_Student_Controller.updateStudent';
import getDataStudent from '@salesforce/apex/AR_Student_Controller.getDataStudent';

/**
 * ClassName: ModalCapNhat
 * ClassDetail:
 * @Create: 2022/07/18 Phan Duy Tân
 * @Modify:
 */
export default class ModalCapNhat extends LightningElement {
    @track showModal = false;
    @track loading = false;
    @track listClass = false;
    @track student;
    getIdStudent;
    error;

    /**
	* show
	* Dùng để mở Modal và lấy id student
	* @param: 
	* @return: 
	* @created: 2022/07/18 Phan Duy Tân
	* @modified: 2022/07/20 Phan Duy Tân
	**/
    @api show(student) {
        this.loading = false;
        this.getIdStudent = student.Id;
        getDataStudent({id : this.getIdStudent})
        .then ( data => {
            this.student = JSON.parse(JSON.stringify(data));
            this.showModal = true;
            this.error = undefined;
        })
        .catch ( error => {
            this.error = error;
            this.contacts = undefined;
        })
        console.log(this.getIdStudent);
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

    //Đổi giá trị trong student khi thay đổi giới tính
    handleChangeSex(event) {
        this.student.Sex__c = event.detail.value;
    }

    //Gắn giá trị cho radio-group
    get optionsSex() {
        return [
            { label: 'Nam', value: true },
            { label: 'Nữ', value: false },
        ];
    }

    /**
	* handleUpdate
	* Sự kiện khi ấn nút cập nhật
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 2022/07/20 Phan Duy Tân
	**/
    handleUpdate(event) {
        this.loading = true;
        console.log('Update ' + JSON.stringify(this.student));
        updateStudent({dataStudent: this.student})
        .then ( ok => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Cập nhật thành công',
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
    }

    /**
	* handleDialogClose
	* Khi nhân nút Close
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 
	**/
    handleDialogClose() {
        this.showModal = false;
    }
}