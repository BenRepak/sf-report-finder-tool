import { LightningElement,api,wire } from 'lwc';
import updateThumbnail from '@salesforce/apex/ReportThumbnailController.updateThumbnail';

import getReport from '@salesforce/apex/ReportThumbnailController.getReport'; 

export default class ReportFinderThumbnailLoader extends LightningElement {
    // valued pass from LRP
    @api
    recordId;

    // queried report to display
    @api
    report;

    // error to display
    @api
    error;

    // thumbnail = {};


    // acceptable upload formats for thumbnails
    get acceptedFormats() {
        return ['.jpeg','.jpg','.png'];
    }

    // get refreshed data when the component loads
    connectedCallback(){
        this.refreshThumbnail();
    }


    // call apex method to query thumbnail url
    refreshThumbnail(){
        getReport({ recordId : this.recordId })
            .then((result) => {
                console.log('result');
                // console.log(result);
                this.report = result;
                this.error = undefined;
                // console.log('this.report.thumbnail --> ' + this.report.thumbnail);
            })
            .catch((error) => {
                console.log('error');
                console.log(error);
                this.error = error;
                this.report = undefined;
            });
            
    }

    // after contentdoc is uploaded, update the access URL on the report finder item
    handleUploadFinished(event) {
        // Get the list of uploaded files
        this.report = undefined;
        const uploadedFiles = event.detail.files;
        // console.log('uploadedFiles --> ' + uploadedFiles);
        // console.log('uploadedFiles --> ' + JSON.stringify(uploadedFiles));

        const contentVersionId = uploadedFiles[0].contentVersionId;
        const contentDocumentId = uploadedFiles[0].documentId;
        // console.log('contentVersionId --> ' + contentVersionId);
        // console.log('contentDocumentId --> ' + contentDocumentId);

        updateThumbnail({contentVersionId : contentVersionId, contentDocumentId : contentDocumentId,recordId : this.recordId})
        .then((result) => {
            // refresh report data after successful update to update the thumbnail
            console.log('success');
            // console.log(result);
            this.refreshThumbnail();
        })
        .catch((error) => {
            console.log('error');
            console.log(JSON.stringify(error));
            console.log((error));
        });
    }

}