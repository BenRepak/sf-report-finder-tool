import { LightningElement,api,wire } from 'lwc';
import updateThumbnail from '@salesforce/apex/ReportThumbnailController.updateThumbnail';
import getThumbnail from '@salesforce/apex/ReportThumbnailController.getThumbnail';


export default class ReportFinderThumbnailLoader extends LightningElement {
    @api
    recordId;

    thumbnail;


    get acceptedFormats() {
        return ['.jpeg','.jpg','.png'];
    }

    @wire(getThumbnail, { recordId : '$recordId' })
    thumbnailPhoto({ data, error }) {
        if (data) {
            console.log('data');
            console.log(data);
            this.thumbnail = data;
        } else if (error) {
            console.log('error');
            console.log(error);
        }
    }



    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        alert('File Details : ' + JSON.stringify(uploadedFiles));
        console.log('uploadedFiles --> ' + uploadedFiles);
        const contentVersionId = uploadedFiles[0].contentVersionId;
        console.log('contentVersionId --> ' + contentVersionId);
        updateThumbnail({contentVersionId : contentVersionId, recordId : this.recordId})
        .then((result) => {
            console.log('success');
            console.log(JSON.stringify(result));
            this.thumbnail = JSON.stringify(result);
            // TODO need to fix quotes
        })
        .catch((error) => {
            console.log('error');
            console.log(JSON.stringify(error));

        });
    }

}