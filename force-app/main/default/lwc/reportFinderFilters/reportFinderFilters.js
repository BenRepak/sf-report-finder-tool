import { LightningElement } from 'lwc';
import getJobFunctions from '@salesforce/apex/ReportFinderController.getJobFunctions';
import getReportTypes from '@salesforce/apex/ReportFinderController.getReportTypes';
import getCategories from '@salesforce/apex/ReportFinderController.getCategories';


// The delay used when debouncing event handlers before firing the event
const DELAY = 350;

export default class ReportFinderFilters extends LightningElement {
    

    valueJobFunction = [];
    valueType = [];
    valueCategory = [];
    searchKey = null;
    bookmarksOnly = false;

    optionsUser = [];
    optionsType = [];
    optionsCategory = [];

    filters = {};
    
    connectedCallback() {
        this.getOptionsUser();
        this.getOptionsType();
        this.getOptionsCategory();
    }

    getOptionsCategory() {
        console.log('getCategories');
        let options = [];
        getCategories()
            .then((result) => {
            if (result) {
                console.log('getCategories result' + JSON.stringify(result));
                result.forEach(r => {
                options.push({
                    label: r,
                    value: r,
                });
                });
            }
            console.log('getCategories options' + JSON.stringify(options));
            this.optionsCategory =  options;

            })
            .catch((error) => {
            // handle Error
            console.log('error');
            });
    }


    getOptionsType() {
        console.log('getOptionsType');
        let options = [];
        getReportTypes()
            .then((result) => {
            if (result) {
                console.log('getOptionsType result' + JSON.stringify(result));
                result.forEach(r => {
                options.push({
                    label: r,
                    value: r,
                });
                });
            }
            console.log('getOptionsType options' + JSON.stringify(options));
            this.optionsType =  options;

            })
            .catch((error) => {
            // handle Error
            console.log('error');
            });
    }


    

    getOptionsUser() {
        console.log('getJobFunctions');
        let options = [];
        getJobFunctions()
            .then((result) => {
            if (result) {
                console.log('result ' + JSON.stringify(result));
                result.forEach(r => {
                options.push({
                    label: r,
                    value: r,
                });
                });
            }
            console.log('options' + JSON.stringify(options));
            this.optionsUser =  options;

            })
            .catch((error) => {
            // handle Error
            console.log('error');
            });
    }


    // get optionsType() {
    //     return [
    //         { label: 'Salesforce Report', value: 'salesforce report' },
    //         { label: 'Tableau Dashboard', value: 'tableau dashboard' },
    //     ];
    // }

    // get optionsCategory() {
    //     return [
    //         { label: 'Mass Contact', value: 'mass contact' },
    //         { label: 'Prospecting', value: 'prospecting' },
    //     ];
    // }

    handleChangeJobFunction(e) {
        console.log('handleChangeJobFunction');
        this.valueJobFunction = e.detail.value;
        this.buildFilters();
        this.fireFilterChangeEvent();        
    }
    handleChangeType(e) {
        this.valueType = e.detail.value;
        this.buildFilters();
        this.fireFilterChangeEvent();  
    }
    handleChangeCategory(e) {
        this.valueCategory = e.detail.value;
        this.buildFilters();
        this.fireFilterChangeEvent();  
    }

    handleSearchKeyChange(e) {
        this.searchKey = e.detail.value;
        this.buildFilters();
        this.delayedFireFilterChangeEvent();
        
    }

    handleChangeBookmark(e){
        this.bookmarksOnly = e.target.checked;
        console.log('this.bookmarksOnly --> ' + this.bookmarksOnly);
        this.buildFilters();
        this.fireFilterChangeEvent();        

    }

    buildFilters(){
        console.log('buildFilters');
        this.filters.searchKey = this.searchKey;
        this.filters.jobFunctions = this.valueJobFunction;
        this.filters.bookmarksOnly = this.bookmarksOnly;
        this.filters.type = this.valueType;
        this.filters.categories = this.valueCategory;
       // this.filters.userRoles = this.valueJobFunction;
        console.log('this.filters --> ' + JSON.stringify(this.filters));
    }

    fireFilterChangeEvent(){
        console.log('fireFilterChangeEvent');

        const filteredEvent = new CustomEvent('filtered', { detail: this.filters });
        this.dispatchEvent(filteredEvent);
    }



    delayedFireFilterChangeEvent() {
        // Debouncing this method: Do not actually fire the event as long as this function is
        // being called within a delay of DELAY. This is to avoid a very large number of Apex
        // method calls in components listening to this event.
        console.log('delayedFireFilterChangeEvent');
        console.log('this.filters... ', this.filters);
        window.clearTimeout(this.delayTimeout);
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {

            this.fireFilterChangeEvent();


        }, DELAY);
        console.log('done');
    }


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