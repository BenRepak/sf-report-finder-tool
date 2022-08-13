import { LightningElement, api } from 'lwc';

export default class ReportFinderBookmarker extends LightningElement {
   

    createBookmark = false;

    @api
    report;

    get isBookmarked(){
        return this.report.isBookmarked;
    }

    addBookmark;



    handleBookmark() {
        console.log('this.isBookmarked --> ' + this.isBookmarked);
        console.log('this.report.isBookmarked --> ' + this.report.isBookmarked);
        this.addBookmark = !this.isBookmarked;
        console.log('this.addBookmark --> ' + this.addBookmark);

        this.handleUpdate();

    }


    handleUpdate(){
        const updatedBookmarkEvent = new CustomEvent('changebookmark', {detail : {report: this.report, addBookmark : this.addBookmark}});
        this.dispatchEvent(updatedBookmarkEvent);
        }


    get iconAltText(){
        if(this.isBookmarked == true){
            return 'Remove from Bookmarks';
        } else {
            return 'Add to Bookmarks';
        }
    }
}