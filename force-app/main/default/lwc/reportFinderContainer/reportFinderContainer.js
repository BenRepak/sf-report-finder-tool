import { LightningElement, api } from 'lwc';
import refreshReports from '@salesforce/apex/ReportFinderController.refreshReports';
import updateBookmark from '@salesforce/apex/ReportBookmarkController.updateBookmark'; 
import logItemUsage from '@salesforce/apex/ReportFinderUsageController.logItemUsage'; 


const DELAY = 350;
export default class ReportFinderContainer extends LightningElement {

    /** Spinner loading status */
    @api isLoaded = false;

    /** Configure hide/show filters from UI */
    @api showJobFunctionFilter;
    @api showPurposeFilter;
    @api showFormatFilter;
    @api showBookmarkFilter;
    @api showSearchByNameFilter;

    /** Message to display when no reports are found when searching */
    @api noReportsMessage;


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

    delayTimeout;
    

    connectedCallback(){
        console.log('connectedCallback');
        this.updateReports();
    }



    updateReports(){
      refreshReports({filters: this.filters, pageNumber: this.pageNumber }) 
          .then(result => {
              // console.log('update result --> ' + JSON.stringify(result));
              this.reports = result;
              this.error = undefined;
              console.log('refreshReports');
            //   if(this.selectedReport !== undefined){
            //     console.log('entered');
            //     console.log('selectedReport --> ' + JSON.stringify(this.selectedReport));
            //     let selectedReportUpdated = this.reports.records.find(r => r.id === this.selectedReport.id);
            //     if(selectedReportUpdated === undefined){
            //         selectedReportUpdated = this.selectedReport;
            //     }
            //     console.log('SHOW ID selectedReportUpdated -->' + JSON.stringify(selectedReportUpdated));
            //     console.log('SHOW ID this.selectedReport.id -->' + JSON.stringify(this.selectedReport.id));
            //     console.log('SHOW ID selectedReportUpdated.id -->' + JSON.stringify(selectedReportUpdated.id));
            //     console.log('SHOW REPORT selectedReportUpdated -->' + JSON.stringify(selectedReportUpdated));
            //     console.log('SHOW REPORT  this.selectedReport after2 -->' + JSON.stringify(this.selectedReport));
            //     this.selectedReport = selectedReportUpdated;
            //   }
              this.hideSpinner();
          })
          .catch(error => {
            console.log('error');
            console.log(error);
            this.error = JSON.stringify(error);
            this.reports = undefined;
            this.hideSpinner();

          });
    }
    

    filteredEvent(event){
        this.pageNumber = 1;
        this.selectedReport = undefined;
        console.log('this.pageName --> ' + this.pageNumber);
        this.showSpinner();
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
        this.selectedReport = undefined;
        this.showSpinner();
        this.pageNumber = this.pageNumber - 1;
        this.updateReports();


    }

    handleNextPage() {
        this.selectedReport = undefined;
        this.showSpinner();
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
                console.log('bookmark Result --> ' + JSON.stringify(result));
                this.selectedReport = result;
                this.updateReports();
                const modalComp =  this.template.querySelector('c-report-finder-selected-item-modal');
                modalComp.closeSpinner();
            })
            .catch(error => {
               console.log('error --> ' + JSON.stringify(error));
               console.log('error --> ' + error);
            });
    }


    handleReportOpen(event){
        console.log('handleReportOpen in container');
        console.log(JSON.stringify(event.detail));
        let reportId = event.detail.report.id;
        logItemUsage({reportId : reportId }) 
            .then(result => {
                console.log('sucessfully loged report open');
            })
            .catch(error => {
               console.log('error --> ' + JSON.stringify(error));
               console.log('error --> ' + error);
            });
        
    }


    showSpinner(){
        window.clearTimeout(this.delayTimeout);
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {

            this.isLoaded = false;
            console.log('showSpinner');

        }, DELAY);
    }

    hideSpinner(){
        this.isLoaded = true;
        clearTimeout(this.delayTimeout);
        
    }







}