import { LightningElement, api } from 'lwc';

export default class ReportFinderListItem extends LightningElement {
    
    // variable passed from parent (reportFinderList)
    @api
    report;

    // sends reportselected event to parent component to eventually open modal 
    // reportFinderListeItem --> reportFinderList --> reportFinderContainer --> reportFinderSelectedItemModal
    handleReportSelected() {
        // console.log('handleReportSelected in reportFinderListItem');
        const selectedReportEvent = new CustomEvent('reportselected', {
            detail: this.report
        });
        this.dispatchEvent(selectedReportEvent);
    }
}