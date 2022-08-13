import { LightningElement, api } from 'lwc';

export default class ReportFinderSelectedItemModal extends LightningElement {

    @api
    report; 
    
    openModal = false;
    isLoaded = false;
    
    @api
    showModal() {
        console.log('show modal');
        this.openModal = true;
        this.isLoaded = true;
    }
    closeModal() {
        console.log('close modal');
        this.openModal = false;
       
    }

    handleBookmarkChange(event){
        this.isLoaded = false;
        console.log('handleBookmarkChange in itemModal');
        console.log('event.detail.addBookmark --> ' + event.detail.addBookmark);
        const updatedBookmarkEvent = new CustomEvent('changebookmark', {detail : event.detail});
        this.dispatchEvent(updatedBookmarkEvent);

    }

    @api
    closeSpinner(){
        this.isLoaded = true;
    }



      

    



    
}