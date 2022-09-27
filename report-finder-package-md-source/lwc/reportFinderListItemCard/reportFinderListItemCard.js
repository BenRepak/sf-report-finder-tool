import { LightningElement, api } from 'lwc';

export default class ReportFinderListItemCard extends LightningElement {
    // variable passed from the parent component
    @api
    report;

    // only shows card if a report is selected
    get hasSelectedReport(){
        console.log('report');
        if(this.report != undefined) {
            return true;
        } else {
            return false;
        }
    }

    // dynamically returns accessUrl
    get reportUrl(){
        return this.report.accessUrl;
    }

    // dynamically returns name
    get reportName(){
        return this.report.name;
    }

    // dynamically returns long descriptoin
    get reportDescriptionLong() {
        return this.report.longDescription;
    }

    // dynamically returns report type
    get reportType(){
        return this.report.type;
    }

    // handles event sent from reportFinderBookmarker
    // passes to reportFinderSelectedItemModal --> reportFinderContainer
    handleBookmarkChange(event){
        console.log('handleBookmarkChange in listItemCard');
        const updatedBookmarkEvent = new CustomEvent('changebookmark', {detail : event.detail});
        this.dispatchEvent(updatedBookmarkEvent);
    }


    // opens accessURL in a new tab
    // dispatches openReportEvent to create a Report_Finder_Item_Usage__c record
    // event is sent to reportFinderSelectedItemModal --> reportFinderContainer
    handleReportOpen(){
        console.log('handleReportOpen in listItemCard');
        const openReportEvent = new CustomEvent('openreport', {detail: {report : this.report}});
        this.dispatchEvent(openReportEvent);
    }
}