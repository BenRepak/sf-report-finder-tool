import { LightningElement, api } from 'lwc';
import REPORT_FINDER_ASSETS from '@salesforce/resourceUrl/report_finder_assets';

export default class ReportFinderListItemThumbnail extends LightningElement {
    @api
    report;

    get reportType(){
        return this.report.type;
    }

    get thumbnail(){
        return this.report.thumbnail;
    }

    resolvedThumbnail = '';


    get thumbnailPhoto(){
        console.log('checking thumbnail --> ' + this.thumbnail);
        this.resolvedThumbnail = `${REPORT_FINDER_ASSETS}/`;
        if(this.thumbnail != undefined && this.thumbnail.length > 0){
            this.resolvedThumbnail =  this.thumbnail;
            console.log('thumbnail1 --> ' + this.resolvedThumbnail);
        } else if(this.reportType.includes('Tableau') ) {
            this.resolvedThumbnail = this.resolvedThumbnail + 'thumbnail_tableau.png';
            console.log('thumbnail2 --> ' + this.resolvedThumbnail);

        } else {
            this.resolvedThumbnail = this.resolvedThumbnail + 'thumbnail_salesforce_report.png';
            console.log('thumbnail3 --> ' + this.resolvedThumbnail);

        }
        return this.resolvedThumbnail;
    }
}