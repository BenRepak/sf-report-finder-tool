import { LightningElement } from 'lwc';
import refreshReports from '@salesforce/apex/ReportFinderController.refreshReports';


export default class ReportFinderContainer extends LightningElement {

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


    updateReports(){
      refreshReports({filters: this.filters, pageNumber: this.pageNumber }) 
          .then(result => {
              console.log('update result --> ' + JSON.stringify(result));
              this.reports = result;
              this.error = undefined;
          })
          .catch(error => {
            console.log('error');
              this.error = JSON.stringify(error);
              this.reports = undefined;
          });
    }
    

    filteredEvent(event){
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
        this.pageNumber = this.pageNumber - 1;
        this.updateReports();


    }

    handleNextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.updateReports();


    }

}