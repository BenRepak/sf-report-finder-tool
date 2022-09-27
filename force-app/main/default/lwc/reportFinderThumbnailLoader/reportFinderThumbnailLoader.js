import { LightningElement,api,wire } from 'lwc';
import updateThumbnail from '@salesforce/apex/ReportThumbnailController.updateThumbnail';

import getReport from '@salesforce/apex/ReportThumbnailController.getReport'; 

export default class ReportFinderThumbnailLoader extends LightningElement {
    @api
    recordId;
    @api
    report;
    @api
    error;

    thumbnail = {};


    get acceptedFormats() {
        return ['.jpeg','.jpg','.png'];
    }

    connectedCallback(){
        this.refreshThumbnail();
    }

    refreshThumbnail(){
        getReport({ recordId : this.recordId })
            .then((result) => {
                console.log('result');
                console.log(result);
                this.report = result;
                this.error = undefined;
                console.log('this.report.thumbnail --> ' + this.report.thumbnail);
            })
            .catch((error) => {
                console.log('error');
                console.log(error);
                this.error = error;
                this.report = undefined;
            });
            
    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        this.report = undefined;
        const uploadedFiles = event.detail.files;
        // alert('File Details : ' + JSON.stringify(uploadedFiles));
        console.log('uploadedFiles --> ' + uploadedFiles);
        console.log('uploadedFiles --> ' + JSON.stringify(uploadedFiles));

        const contentVersionId = uploadedFiles[0].contentVersionId;
        const contentDocumentId = uploadedFiles[0].documentId;
        console.log('contentVersionId --> ' + contentVersionId);
        console.log('contentDocumentId --> ' + contentDocumentId);

        updateThumbnail({contentVersionId : contentVersionId, contentDocumentId : contentDocumentId,recordId : this.recordId})

        .then((result) => {
            console.log('success');
            
            console.log(result);
            this.refreshThumbnail();
            
            // TODO need to fix quotes
        })
        .catch((error) => {
            console.log('error');
            console.log(JSON.stringify(error));
            console.log((error));

        });
    }

}