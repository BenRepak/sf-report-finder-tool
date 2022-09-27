import { LightningElement, api } from 'lwc';

export default class ReportFinderBookmarker extends LightningElement {
   
    @api
    report;

    // dynamically set icon state based on the value from the report
    get isBookmarked(){
        return this.report.isBookmarked;
    }

    // variable used in icon toggle
    addBookmark;


    // dispatches an event to reportFinderListItemCard --> reportFinderSelectedItemModal --> reportFinderContainer
    // handleBookmarkChange method in reportFinderContainer.js calls apex method to update bookmark and return refreshed results 
    handleBookmark() {
        // console.log('this.isBookmarked --> ' + this.isBookmarked);
        this.addBookmark = !this.isBookmarked;
        const updatedBookmarkEvent = new CustomEvent('changebookmark', {detail : {report: this.report, addBookmark : this.addBookmark}});
        this.dispatchEvent(updatedBookmarkEvent);

    }


    // dynamically sets icon text based on value of report.isBookmarked
    get iconAltText(){
        if(this.isBookmarked == true){
            return 'Remove from Bookmarks';
        } else {
            return 'Add to Bookmarks';
        }
    }
}