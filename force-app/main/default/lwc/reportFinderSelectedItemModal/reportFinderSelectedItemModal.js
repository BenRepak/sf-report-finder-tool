import { LightningElement, api } from 'lwc';

export default class ReportFinderSelectedItemModal extends LightningElement {

    @api
    report; 
    
    openModal = false;
    
    @api
    showModal() {
        console.log('show modal');
        this.openModal = true;
    }
    closeModal() {
        console.log('close modal');
        this.openModal = false;
       
    }


    



    
}