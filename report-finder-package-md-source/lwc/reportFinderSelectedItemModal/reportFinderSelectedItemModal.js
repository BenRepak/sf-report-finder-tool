import { LightningElement, api } from 'lwc';

export default class ReportFinderSelectedItemModal extends LightningElement {
    // variable passed from parent component
    @api
    report; 
    
    openModal = false; // shows or hides modal
    isLoaded = false; // shows or hides loading spinner
    
    // function called from parent component (reportFinderContainer) when a report item is selected
    // reportFinderListItem --> reportFinderList --> reportFinderContainer --> reportFinderSelectedItemModal
    @api
    showModal() {
        // console.log('show modal');
        this.openModal = true;
        this.isLoaded = true;
    }

    // function called from parent component (reportFinderContainer) after a bookmark event has been saved
    @api
    closeSpinner(){
        this.isLoaded = true;
    }

    // closes the modal when the X is clicked in the top right of the header
    closeModal() {
        // console.log('close modal');
        this.openModal = false;
    }

    // sends changebookmark event to reportFinderContainer where apex is executed
    // originally called from reportFinderBookmarker --> reportFinderListItemCard
    handleBookmarkChange(event){
        this.isLoaded = false;
        // console.log('handleBookmarkChange in itemModal');
        // console.log('event.detail.addBookmark --> ' + event.detail.addBookmark);
        const updatedBookmarkEvent = new CustomEvent('changebookmark', {detail : event.detail});
        this.dispatchEvent(updatedBookmarkEvent);

    }

    // sends openreport event to reportFinderContainer where apex is executed
    // originally called from reportFinderListItemCard
    handleReportOpen(event){
        // console.log('handleReportOpen in itemModal');
        // console.log(JSON.stringify(event.detail));
        const openReportEvent = new CustomEvent('openreport', {detail : event.detail});
        this.dispatchEvent(openReportEvent);
    }

        
  



      

    



    
}