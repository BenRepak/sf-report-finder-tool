import { LightningElement, api } from 'lwc';

export default class ReportFinderPaginator extends LightningElement {
        /** The current page number. */
        // variable set from parent component (reportFinderList)
        @api pageNumber;

        /** The number of items on a page. */
        // variable set from parent component (reportFinderList)
        @api pageSize;
    
        /** The total number of items in the list. */
        // variable set from parent component (reportFinderList)
        @api totalItemCount;
    
        
        // sends custom event to parent component (reportFinderList --> reportFinderContainer) to requery with offset 
        handlePrevious() {
            this.dispatchEvent(new CustomEvent('previous'));
        }
    
        // sends custom event to parent component (reportFinderContainer) to requery with offset 
        handleNext() {
            this.dispatchEvent(new CustomEvent('next'));
        }

        // dynamically sets the singular or plural value based on record count
        get itemOrItems(){
            return this.totalItemCount === 1 ? 'item' : 'items';
        }
        
        // dynamically sets the current page number
        get currentPageNumber() {
            return this.totalItemCount === 0 ? 0 : this.pageNumber;
        }
        
        // dynamically calculates if the current page is the first page
        // if so, the back button will be hidden
        get isFirstPage() {
            return this.pageNumber === 1;
        }
            
        // dynamically calculates if the current page is the laste page
        // if so, the next button will be hidden
        get isLastPage() {
            return this.pageNumber >= this.totalPages;
        }
        
        // calculates the total pages based on results size
        get totalPages() {
            return Math.ceil(this.totalItemCount / this.pageSize);
        }
}