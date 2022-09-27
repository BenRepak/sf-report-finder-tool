import { api, LightningElement } from 'lwc';
import REPORT_FINDER_ASSETS from '@salesforce/resourceUrl/report_finder_assets';

export default class ReportFinderList extends LightningElement {

    // variable passed from parent (reportFinderContainer)
    @api
    reports;

    /** Current page in the product list. */
     pageNumber = 1;

    /** The number of items on a page. */
    // pageSize;
 
    // /** The total number of items matching the selection. */
    //  totalItemCount = 0;

    // variable passed from parent config file (reportFinderContainer)
    // can be set in the app builder
    @api
    message;

    /** Url for UU logo. */
    // set from static resource
    logoUrl = `${REPORT_FINDER_ASSETS}/logo_BlockU_red-800px.png`;

    // sends reportselected to parent (reportFinderContainer) to eventually open modal
    // originally called from the reportFinderListItem JS file
    // reportFinderListItem --> reportFinderList --> reportFinderContainer --> reportFinderSelectedItemModal
    handleReportSelected(event) {
        // console.log('handleReportSelected in reportFinderList');
        // console.log('report Id --> ' + event.detail.Id);
        const selectedReportEvent = new CustomEvent('reportselected', {
            detail: event.detail
        });
        this.dispatchEvent(selectedReportEvent);
        // console.log('dispatched2');
     }

    // sends previous event to parent (reportFinderContainer) to execute apex with offset
    // originally called from the reportFinderPaginator component
    // reportFinderPaginator --> reportFinderList --> reoprtFinderContainer
     handlePreviousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.dispatchEvent(new CustomEvent('previous',{detail: this.pageNumber}));
    }

    // sends next event to parent (reportFinderContainer) to execute apex with offset
    // originally called from the reportFinderPaginator component
    // reportFinderPaginator --> reportFinderList --> reoprtFinderContainer
    handleNextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.dispatchEvent(new CustomEvent('next',{detail: this.pageNumber}));
    }
}