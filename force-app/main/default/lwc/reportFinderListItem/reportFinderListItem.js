import { LightningElement, api } from 'lwc';

export default class ReportFinderListItem extends LightningElement {
    

    @api
    report;


    handleReportSelected() {
        console.log('handleReportSelected in reportFinderListItem');
        const selectedReportEvent = new CustomEvent('reportselected', {
            detail: this.report
        });
        this.dispatchEvent(selectedReportEvent);
    }
}