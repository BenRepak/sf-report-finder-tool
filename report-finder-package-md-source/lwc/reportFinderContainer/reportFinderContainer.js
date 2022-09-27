import { LightningElement, api } from 'lwc';
import refreshReports from '@salesforce/apex/ReportFinderController.refreshReports';
import updateBookmark from '@salesforce/apex/ReportBookmarkController.updateBookmark'; 
import logItemUsage from '@salesforce/apex/ReportFinderUsageController.logItemUsage'; 


const DELAY = 350;
export default class ReportFinderContainer extends LightningElement {

    /** Spinner loading status */
    @api isLoaded = false;

    /** Configure hide/show filters from UI */
    // set in the config app builder
    // passed down to the reportFinderFilters component
    @api showJobFunctionFilter;
    @api showPurposeFilter;
    @api showFormatFilter;
    @api showBookmarkFilter;
    @api showSearchByNameFilter;

    /** Message to display when no reports are found when searching */
    // set in the config app builder
    @api noReportsMessage;


    /** Current page in the product list. */
    pageNumber = 1;
    
    /** JSON.stringified version of filters to pass to apex */
    filters;
    
    reports; // results returned from imperative apex call
    error; // errors returned from imperative apex call

    selectedReport; // used to pass selected report from reportFinderListItem --> reportFinderList --> reportFinderContainer --> reportFinderSelectedItemModal

    delayTimeout; // used to delay spinner
    

    // queries reports when the component is loaded
    connectedCallback(){
        console.log('connectedCallback');
        this.updateReports();
    }


    // retreives search results based on current page number and filters 
    updateReports(){
      refreshReports({filters: this.filters, pageNumber: this.pageNumber }) 
          .then(result => {
              // console.log('update result --> ' + JSON.stringify(result));
              this.reports = result;
              this.error = undefined;
              console.log('refreshReports');
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
    
    // handles the filter event from the reportFinderFilters lwc
    // executes apex search including filter values from child component
    // reportFinderFilters --> reportFinderContainer
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


    // opens the reportFinderSelectedItemModal lwc when a reportFinderListItem is clicked
    // reportFinderListItem --> reportFinderList --> reportFinderContainer --> reportFinderSelectedItemModal
    selectedEvent(event){
        console.log('selectedEvent in contatiner');
        this.selectedReport = event.detail;
        // console.log(JSON.stringify(this.selectedReport));  
        const modalComp =  this.template.querySelector('c-report-finder-selected-item-modal');
        modalComp.showModal();
        
    }


    // handles the previous event from the reportFinderPaginator lwc
    // reportFinderPaginator --> reportFinderList --> reportFinderContainer
    // requeries data with an updated offset
    handlePreviousPage() {
        this.selectedReport = undefined;
        this.showSpinner();
        this.pageNumber = this.pageNumber - 1;
        this.updateReports();
    }

    // handles the next event from the reportFinderPaginator lwc
    // reportFinderPaginator --> reportFinderList --> reportFinderContainer
    // requeries data with an updated offset
    handleNextPage() {
        this.selectedReport = undefined;
        this.showSpinner();
        this.pageNumber = this.pageNumber + 1;
        this.updateReports();
    }



    // bookmarks report event from the reportFinderListeItemCard lwc
    // reportFinderListeItemCard --> reportFinderSelectedItemModal --> reportFinderContainer
    // when done, the report list is refreshed to show updated bookmarks (updateReports())
    // also when done, the selectedReport item is updated with a freshly queried report_finder_item__c record to include the updated isBookmarked boolean
    handleBookmarkChange(event){
        console.log('handleBookmarkChange in container');
        console.log('event.detail.addBookmark --> ' + event.detail.addBookmark);

        let addBookmark = event.detail.addBookmark;
        let reportId = event.detail.report.id;
        updateBookmark({reportId : reportId, isAdd : addBookmark }) 
            .then(result => {
                console.log('bookmark Result --> ' + JSON.stringify(result));
                this.selectedReport = result; // result selectedReport with updated data from apex 
                this.updateReports();
                const modalComp =  this.template.querySelector('c-report-finder-selected-item-modal');
                modalComp.closeSpinner();
            })
            .catch(error => {
               console.log('error --> ' + JSON.stringify(error));
               console.log('error --> ' + error);
            });
    }


    // logs report open event from the reportFinderListeItemCard lwc
    // reportFinderListeItemCard --> reportFinderSelectedItemModal --> reportFinderContainer
    handleReportOpen(event){
        console.log('handleReportOpen in container');
        // console.log(JSON.stringify(event.detail));
        let reportId = event.detail.report.id;
        logItemUsage({reportId : reportId }) 
            .then(result => {
                console.log('sucessfully logged report open');
            })
            .catch(error => {
               console.log('error --> ' + JSON.stringify(error));
               console.log('error --> ' + error);
            });
        
    }


    // shows loading spinner with a slight time delay
    showSpinner(){
        window.clearTimeout(this.delayTimeout);
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            this.isLoaded = false;
            console.log('showSpinner');
        }, DELAY);
    }


    // hides loading spinner and clears timeout
    hideSpinner(){
        this.isLoaded = true;
        clearTimeout(this.delayTimeout);  
    }







}