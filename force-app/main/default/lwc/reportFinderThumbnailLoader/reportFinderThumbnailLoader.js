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

    
    // @wire(getReport, { recordId : '$recordId' })
    // wiredReport({ data, error }) {
    //     if (data) {
    //         console.log('data');
    //         console.log(data);
    //         this.report = data;
    //         this.error = undefined;
    //         console.log('this.report.thumbnail --> ' + this.report.thumbnail);
    //     } else if (error) {
    //         console.log('error');
    //         console.log(error);
    //         this.error = error;
    //         this.report = undefined;
    //     }
    // }


    handleUploadFinished(event) {
        // Get the list of uploaded files
        this.report = undefined;
        const uploadedFiles = event.detail.files;
        // alert('File Details : ' + JSON.stringify(uploadedFiles));
        console.log('uploadedFiles --> ' + uploadedFiles);
        const contentVersionId = uploadedFiles[0].contentVersionId;
        console.log('contentVersionId --> ' + contentVersionId);
        updateThumbnail({contentVersionId : contentVersionId, recordId : this.recordId})
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