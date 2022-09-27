import { LightningElement, api } from 'lwc';
import getJobFunctions from '@salesforce/apex/ReportFinderFilterController.getJobFunctions';
import getReportTypes from '@salesforce/apex/ReportFinderFilterController.getReportTypes';
import getCategories from '@salesforce/apex/ReportFinderFilterController.getCategories';


// The delay used when debouncing event handlers before firing the event
const DELAY = 350;

export default class ReportFinderFilters extends LightningElement {
    
    /** Configure hide/show filters from UI */
    // variables set from the parent component (reportFinderContainer) via the app builder
    @api showJobFunctionFilter;
    @api showPurposeFilter;
    @api showFormatFilter;
    @api showBookmarkFilter;
    @api showSearchByNameFilter;

    valueJobFunction = []; // shows actively selected optionsJob values in UI
    valueType = []; // shows actively selected optionsType values in UI
    valueCategory = []; // shows actively selected optionsCategory values in UI
    searchKey = null; // filter in UI
    bookmarksOnly = false; // filter in UI


    optionsJob = []; // filter in UI. displays active job filters set from getOptionsJob()
    optionsType = []; // filter in UI.displays active type filters set from getOptionsType()
    optionsCategory = []; // filter in UI.displays category type filters set from getOptionsCategory()

    // object used to create filters
    // eventually sent to controller 
    filters = {};
    
    // retreives filter options when the component is loaded
    connectedCallback() {
        this.getOptionsJob();
        this.getOptionsType();
        this.getOptionsCategory();
    }

    // retrives active Category filters from Report_Finder_Category__c
    getOptionsCategory() {
        console.log('getCategories');
        let options = [];
        getCategories()
            .then((result) => {
            if (result) {
                // console.log('getCategories result' + JSON.stringify(result));
                result.forEach(r => {
                options.push({
                    label: r,
                    value: r,
                });
                });
            }
            // console.log('getCategories options' + JSON.stringify(options));
            this.optionsCategory =  options;

            })
            .catch((error) => {
            // handle Error
            console.log('error getOptionsCategory --> ' + JSON.stringify(error));
            });
    }


    // retrives active type filters from active picklist values in Report_Finder_Item__c.Type__c
    getOptionsType() {
        console.log('getOptionsType');
        let options = [];
        getReportTypes()
            .then((result) => {
            if (result) {
                // console.log('getOptionsType result' + JSON.stringify(result));
                result.forEach(r => {
                options.push({
                    label: r,
                    value: r,
                });
                });
            }
            // console.log('getOptionsType options' + JSON.stringify(options));
            this.optionsType =  options;

            })
            .catch((error) => {
            // handle Error
            console.log('error getOptionsType --> ' + JSON.stringify(error));
            });
    }


    
    // retrives active Job Function filters from Report_Finder_Job_Function__c
    getOptionsJob() {
        console.log('getJobFunctions');
        let options = [];
        getJobFunctions()
            .then((result) => {
            if (result) {
                // console.log('result ' + JSON.stringify(result));
                result.forEach(r => {
                options.push({
                    label: r,
                    value: r,
                });
                });
            }
            // console.log('options' + JSON.stringify(options));
            this.optionsJob =  options;

            })
            .catch((error) => {
            // handle Error
            console.log('error getOptionsJob --> ' + JSON.stringify(error));
            });
    }


    // updates the job function variable, rebuilds filters, and fires event to requery records
    handleChangeJobFunction(e) {
        this.valueJobFunction = e.detail.value;
        this.buildFilters();
        this.fireFilterChangeEvent();        
    }

    // updates the type variable, rebuilds filters, and fires event to requery records
    handleChangeType(e) {
        this.valueType = e.detail.value;
        this.buildFilters();
        this.fireFilterChangeEvent();  
    }

    // updates the category variable, rebuilds filters, and fires event to requery records
    handleChangeCategory(e) {
        this.valueCategory = e.detail.value;
        this.buildFilters();
        this.fireFilterChangeEvent();  
    }


    // updates the searchKey variable, rebuilds filters, and fires event to requery records
    handleSearchKeyChange(e) {
        this.searchKey = e.detail.value;
        this.buildFilters();
        this.delayedFireFilterChangeEvent();
    }


    // updates the bookmark variable, rebuilds filters, and fires event to requery records
    handleChangeBookmark(e){
        this.bookmarksOnly = e.target.checked;
        this.buildFilters();
        this.fireFilterChangeEvent();        

    }

    // sets customer filter object values based on user input from UI
    buildFilters(){
        console.log('buildFilters');
        this.filters.searchKey = this.searchKey;
        this.filters.jobFunctions = this.valueJobFunction;
        this.filters.bookmarksOnly = this.bookmarksOnly;
        this.filters.type = this.valueType;
        this.filters.categories = this.valueCategory;
        // console.log('this.filters --> ' + JSON.stringify(this.filters));
    }


    // sends event to parent (reportFinderContainer) to requery records with filters
    fireFilterChangeEvent(){
        console.log('fireFilterChangeEvent');
        const filteredEvent = new CustomEvent('filtered', { detail: this.filters });
        this.dispatchEvent(filteredEvent);
    }


    // delays then sends event to parent (reportFinderContainer) to requery records with filters
    // Debouncing this method: Do not actually fire the event as long as this function is
    // being called within a delay of DELAY. This is to avoid a very large number of Apex
    // method calls in components listening to this event.
    delayedFireFilterChangeEvent() {
        // console.log('delayedFireFilterChangeEvent');
        // console.log('this.filters... ', this.filters);
        window.clearTimeout(this.delayTimeout);
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            this.fireFilterChangeEvent();
        }, DELAY);
        // console.log('done');
    }


    // resets all filters and sends event to parent (reportFinderContainer) to requery records with no filters
    clearFilters(){
        this.filters = {};
        this.valueJobFunction = [];
        this.valueType = [];
        this.valueCategory = [];
        this.searchKey = '';
        this.bookmarksOnly = false;
        this.fireFilterChangeEvent();        
    }


}