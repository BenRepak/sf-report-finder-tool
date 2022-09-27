import { LightningElement, api } from 'lwc';
import REPORT_FINDER_ASSETS from '@salesforce/resourceUrl/report_finder_assets';

export default class ReportFinderListItemThumbnail extends LightningElement {
    // variable passed from the parent component
    @api
    report;

    // get thumbnail url base on report attributes
    // if there's no thumbnail url value, return an image from static resources based on report.type
    get thumbnailPhoto(){
        let resolvedThumbnail = '';
        resolvedThumbnail = `${REPORT_FINDER_ASSETS}/`;
        if(this.report.thumbnail != undefined && this.report.thumbnail.length > 0){
            resolvedThumbnail =  this.report.thumbnail;
            // console.log('thumbnail1 --> ' + resolvedThumbnail);
        } else if(this.report.type.includes('Tableau') ) {
            resolvedThumbnail = resolvedThumbnail + 'thumbnail_tableau.png';
            // console.log('thumbnail2 --> ' + resolvedThumbnail);
        } else {
            resolvedThumbnail = resolvedThumbnail + 'thumbnail_salesforce_report.png';
            // console.log('thumbnail3 --> ' + resolvedThumbnail);
        }
        return resolvedThumbnail;
    }
    
}