import { LightningElement, api } from 'lwc';
import refreshReports from '@salesforce/apex/ReportFinderController.refreshReports';


export default class ReportFinderContainer extends LightningElement {

    /** Spinner loading status */
    @api isLoaded = false;


    /** Current page in the product list. */
    pageNumber = 1;
    
    /** The number of items on a page. */
    pageSize;
    
    /** The total number of items matching the selection. */
    totalItemCount = 0;
    
    /** JSON.stringified version of filters to pass to apex */
    filters;
    
    reports;
    error;

    selectedReport;
    

    connectedCallback(){
        console.log('connectedCallback');
        this.updateReports();
    }


    toggleSpinner() {
        this.isLoaded = !this.isLoaded;
    }


    updateReports(){
      refreshReports({filters: this.filters, pageNumber: this.pageNumber }) 
          .then(result => {
              console.log('update result --> ' + JSON.stringify(result));
              this.reports = result;
              this.error = undefined;
              this.isLoaded = true;
          })
          .catch(error => {
            console.log('error');
              this.error = JSON.stringify(error);
              this.reports = undefined;
              this.isLoaded = true;

          });
    }
    

    filteredEvent(event){
        this.isLoaded = false;
        this.pageNumber = 1;


        console.log('filteredEvent');
        this.filters = event.detail;
        console.log('this.filters --> ' + JSON.stringify(this.filters));
        this.updateReports();
    }

    selectedEvent(event){
        console.log('selectedEvent in contatiner');
        this.selectedReport = event.detail;
        // console.log(JSON.stringify(this.selectedReport));  
        const modalComp =  this.template.querySelector('c-report-finder-selected-item-modal');
        modalComp.showModal();
        
    }


    handlePreviousPage() {
        this.isLoaded = false;
        this.pageNumber = this.pageNumber - 1;
        this.updateReports();


    }

    handleNextPage() {
        this.isLoaded = false;
        this.pageNumber = this.pageNumber + 1;
        this.updateReports();


    }

}