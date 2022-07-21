import { LightningElement, wire, api, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import deleteStudent from '@salesforce/apex/AR_TimKiem_Controller.deleteStudent';
/**
 * ClassName: ModalConfirm
 * ClassDetail:
 * @Create: 2022/07/19 Phan Duy Tân
 * @Modify:
 */
export default class ModalConfirm extends LightningElement {
    @track showModal = false; //Dùng để mở modal
    @track loading = false; //Dùng để mở spinner loading
    @api getListStudent; //Dùng để chứa danh sách học sinh cần xóa
    setListStudent = []; //Dùng để chứa 1 học sinh cần xóa
    check = false; //Check khi náo xóa 1 hoặc nhiều

    /**
	* show
	* Dùng để mở Modal khi xóa nhiều đối tượng
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 2022/07/20 Phan Duy Tân
	**/
    @api show() {
        this.showModal = true;
        this.loading = false;
        this.check = false;
    }

    /**
	* show1Student
	* Dùng để mở Modal khi xóa một đối tượng
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 2022/07/20 Phan Duy Tân
	**/
    @api show1Student(student) {
        this.check = true;
        this.loading = false;
        this.setListStudent.push(student);
        this.showModal = true;
    }

    /**
	* handleClose
	* Sự kiện khi ấn nút Cancel
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 2022/07/20 Phan Duy Tân
	**/
    handleClose() {
        this.showModal = false;
    }

    /**
	* handleDelete
	* Sự kiện khi ấn nút xóa
	* @param: 
	* @return: 
	* @created: 2022/07/19 Phan Duy Tân
	* @modified: 2022/07/20 Phan Duy Tân
	**/
    handleDelete() {
        this.loading = true;
        if(this.check) {
            console.log('Xóa 1');
            deleteStudent({deleteStudent : this.setListStudent})
            .then ( ok => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Xóa thành công.',
                        variant: 'success',
                    }),
                );
                this.getListStudent = null;
                const reset = new CustomEvent('resettable',{detail: true});
                this.dispatchEvent(reset);
                this.showModal = false;
            })
            .catch ( error => {
                //console.log('error'+JSON.stringify(error))
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error Delete',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
                this.showModal = false;
            })
        } else {
            console.log('Xóa nhiều');
            deleteStudent({deleteStudent : this.getListStudent}) 
            .then ( ok => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Xóa thành công.',
                        variant: 'success',
                    }),
                );
                this.getListStudent = null;
                const reset = new CustomEvent('resettable',{detail: true});
                this.dispatchEvent(reset);
                this.showModal = false;
            })
            .catch ( error => {
                //console.log('error'+JSON.stringify(error))
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error Delete',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
                this.showModal = false;
            })
        }
    }
}