import { api, LightningElement } from 'lwc';

export default class ReportFinderList extends LightningElement {

    @api
    reports;

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