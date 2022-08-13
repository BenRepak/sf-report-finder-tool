import { api, LightningElement } from 'lwc';
import REPORT_FINDER_ASSETS from '@salesforce/resourceUrl/report_finder_assets';

export default class ReportFinderList extends LightningElement {

    @api
    reports;

    message = 'There are no reports matching your search criteria.'

    /** Url for UU logo. */
    logoUrl = `${REPORT_FINDER_ASSETS}/logo_BlockU_red-800px.png`;

    handleReportSelected(event) {
        console.log('handleReportSelected in reportFinderList');
       // console.log(JSON.stringify(event.detail));   
        console.log('report Id --> ' + event.detail.Id);
        const selectedReportEvent = new CustomEvent('reportselected', {
            detail: event.detail
        });
        this.dispatchEvent(selectedReportEvent);
        console.log('dispatched2');
     }
}