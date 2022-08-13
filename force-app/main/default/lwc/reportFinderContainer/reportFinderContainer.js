import { LightningElement, api } from 'lwc';
import refreshReports from '@salesforce/apex/ReportFinderController.refreshReports';
import updateBookmark from '@salesforce/apex/ReportBookmarkController.updateBookmark';



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
              // console.log('update result --> ' + JSON.stringify(result));
              this.reports = result;
              this.error = undefined;
              this.isLoaded = true;
              if(this.selectedReport){
                console.log('entered');

                let selectedReportUpdated = this.reports.records.find(r => r.id === this.selectedReport.id);
                console.log('SHOW ID this.selectedReport.id -->' + JSON.stringify(this.selectedReport.id));
                console.log('SHOW ID selectedReportUpdated.id -->' + JSON.stringify(selectedReportUpdated.id));

                console.log('SHOW REPORT selectedReportUpdated -->' + JSON.stringify(selectedReportUpdated));
                console.log('SHOW REPORT  this.selectedReport after2 -->' + JSON.stringify(this.selectedReport));


                this.selectedReport = selectedReportUpdated;
              }
             
          })
          .catch(error => {
            console.log('error');
            console.log(error);
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



    handleBookmarkChange(event){
        console.log('handleBookmarkChange in container');
        console.log('event.detail.addBookmark --> ' + event.detail.addBookmark);

        let addBookmark = event.detail.addBookmark;
        let reportId = event.detail.report.id;
        updateBookmark({reportId : reportId, isAdd : addBookmark }) 
            .then(result => {
                // this.dispatchEvent(
                //     new ShowToastEvent({
                //         title: 'Success',
                //         message: this.toastMessage,
                //         variant: 'success',
                //     }),
                // );
                // this.isBookmarked = this.createBookmark;

                

                this.updateReports();
                const modalComp =  this.template.querySelector('c-report-finder-selected-item-modal');
                modalComp.closeSpinner();
               



            })
            .catch(error => {
               console.log('error --> ' + JSON.stringify(error));
               console.log('error --> ' + error);

            });
    }

}