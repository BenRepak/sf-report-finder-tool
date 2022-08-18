import { LightningElement, api } from 'lwc';

export default class ReportFinderListItemCard extends LightningElement {

    @api
    report;


    get reportUrl(){
        return this.report.accessUrl;
    }
    get reportName(){
        return this.report.name;
    }

    get reportDescriptionLong() {
        return this.report.longDescription;
    }

    get reportType(){
        return this.report.type;
    }

    get hasSelectedReport(){
        console.log('report');
        if(this.report != undefined) {
            return true;
        } else {
            return false;
        }
    }

    get thumbnail(){
        if(this.report.thumbnail != undefined){
            return this.report.thumbnail;
        } else {
            return '';
        }
    }


    handleBookmarkChange(event){
        console.log('handleBookmarkChange in listItemCard');
        const updatedBookmarkEvent = new CustomEvent('changebookmark', {detail : event.detail});
        this.dispatchEvent(updatedBookmarkEvent);
    }


    handleReportOpen(){
        console.log('handleReportOpen in listItemCard');
        const openReportEvent = new CustomEvent('openreport', {detail: {report : this.report}});
        this.dispatchEvent(openReportEvent);
    }
}