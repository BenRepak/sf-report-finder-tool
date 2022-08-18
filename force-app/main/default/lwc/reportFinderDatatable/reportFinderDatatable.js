import { LightningElement, api } from 'lwc';
import REPORT_FINDER_ASSETS from '@salesforce/resourceUrl/report_finder_assets';

const actions = [
    { label: 'Show details', name: 'show_details' },
    { label: 'Open Report', name: 'open_report' }
];
const columns = [    
    
    { label: 'Name', fieldName: 'name', type: 'text', sortable: true,wrapText: true,cellAttributes :{
      
    } },
    { label: 'Short Description', fieldName: 'shortDescription', type: 'text',wrapText: true,cellAttributes :{
      
    } },
    { label: 'Long Description', fieldName: 'longDescription', type: 'text',wrapText: true,cellAttributes :{
      
    } },
    { label: 'Bookmarked', fieldName: 'isBookmarked', type: 'boolean',fixedWidth: 100,sortable: true, cellAttributes :{
    }},
    { label: '', fieldName: 'showDetails',type: 'button',  fixedWidth: 150,
   
    hideLabel: true,typeAttributes: {
        label: 'Show More',
        name: 'show_details'
    }}



];



export default class ReportFinderDatatable extends LightningElement {
    @api
    reports;


    get data(){
        return this.reports.records;
    }



    connectedCallback(){
        console.log('this.reports --->' + JSON.stringify(this.reports));
       
    }

    handleReportSelected(event) {
        console.log('handleReportSelected in reportFinderDatatable');
        const action = event.detail.action;
        const row = event.detail.row;
        console.log('action ' + action);
        console.log('row ' + JSON.stringify(row));

        switch (action.name) {
            case 'show_details':
                const selectedReportEvent = new CustomEvent('reportselected', {
                    detail: row
                });
                this.dispatchEvent(selectedReportEvent);
                break;
            case 'open_report':
                alert('Open Report: ' + JSON.stringify(row));
                break;
        }

        
    }


    loadMoreData(event) {
        //Display a spinner to signal that data is being loaded
        event.target.isLoading = true;
        //Display "Loading" when more data is being loaded
        this.loadMoreStatus = 'Loading';
        console.log('itemCount --> ' + this.reports.totalItemCount);
        let _reports = this.reports.records;

            console.log('this.pageNumber --> ' + this.pageNumber);
            this.pageNumber = this.pageNumber + 1;
            console.log('this.pageNumber --> ' + this.pageNumber);

            this.dispatchEvent(new CustomEvent('loadmore',{detail: {reports : this.reports.records}}));
          
 

            event.target.isLoading = false;
    
        
        // fetchData()
        // .then((data) => {
        //     if (data.length >= this.reports.totalItemCount) {
        //         event.target.enableInfiniteLoading = false;
        //         this.loadMoreStatus = 'No more data to load';
        //     } else {
        //         const currentData = this.data;
        //         //Appends new data to the end of the table
        //         const newData = currentData.concat(data);
        //         this.data = newData;
        //         this.loadMoreStatus = '';
        //     }
        //     event.target.isLoading = false;
        // })
        // .catch((error) => {
        //     console.log('error --> ' + error);
        // });
    }

  

    columns = columns;

     /** Current page in the product list. */
     pageNumber = 1;



    message = 'There are no reports matching your search criteria.'

    /** Url for UU logo. */
    logoUrl = `${REPORT_FINDER_ASSETS}/logo_BlockU_red-800px.png`;

    getSelectedName(){
        console.log('getSelectedName');
    }


    get itemOrItems(){
        return this.totalItemCount === 1 ? 'item' : 'items';
    }

    get currentPageNumber() {
        return this.totalItemCount === 0 ? 0 : this.pageNumber;
    }

    get isFirstPage() {
        return this.pageNumber === 1;
    }

    get isLastPage() {
        return this.pageNumber >= this.totalPages;
    }

    get totalPages() {
        return Math.ceil(this.totalItemCount / this.pageSize);
    }

    get pageNumber(){
        return this.reports.pageNumber;
    }

    get displayedItemCount(){
        return this.reports.records.length;
    }

    get totalItemCount(){
        return this.reports.totalItemCount;
    }

    get isAllData(){
        return this.totalItemCount == this.displayedItemCount;
    }
  
}