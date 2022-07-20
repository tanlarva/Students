import { LightningElement, wire, api, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import deleteStudent from '@salesforce/apex/AR_TimKiem_Controller.deleteStudent';

export default class ModalComfirm extends LightningElement {
    @track showModal = false;
    @track loading = false;
    @api getListStudent;
    setListStudent = [];
    check = false;

    @api show() {
        this.showModal = true;
        this.loading = false;
        this.check = false;
    }

    @api show1Student(student) {
        this.check = true;
        this.loading = false;
        this.setListStudent.push(student);
        this.showModal = true;
        console.log('aaa'+ JSON.stringify(this.setListStudent));
    }

    handleClose() {
        this.showModal = false;
    }

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