/**
* @author Ben Repak u0884669
* @date 2022-September
*
* @description Test class for ReportFinderFilterController
*/
@isTest
public with sharing class ReportFinderFilterController_TEST {

    @TestSetup
    private static void makeData(){
        // create a test Report_Finder_Item__c record for assignments later
        Report_Finder_Item__c rfi = new Report_Finder_Item__c();
        rfi.Item_Name__c = 'Test Report Finder Item';
        rfi.Short_Description__c = 'Short Description';
        rfi.Long_Description__c = 'Long Description';
        rfi.Publish_Status__c = 'Published';
        rfi.Type__c = 'Tableau Dashboard';
        rfi.Access_URL__c = 'https://utah.edu';
        rfi.Thumbnail_URL__c = '/bogus_url/';
        insert rfi;

        // create Report_Finder_Job_Function__c data 
        List<Report_Finder_Job_Function__c> jobs = new List<Report_Finder_Job_Function__c>();
        Report_Finder_Job_Function__c activeJob = new Report_Finder_Job_Function__c();
        activeJob.Is_Active__c = true;
        activeJob.Job_Function_Name__c = 'Active Job';
        jobs.add(activeJob);
        Report_Finder_Job_Function__c inactiveJob = new Report_Finder_Job_Function__c();
        inactiveJob.Is_Active__c = false;
        inactiveJob.Job_Function_Name__c = 'Inactive Job';
        jobs.add(inactiveJob);

        insert jobs;

        // create Report_Finder_Category__c data 
        List<Report_Finder_Category__c> categories = new List<Report_Finder_Category__c>();
        Report_Finder_Category__c activeCategory = new Report_Finder_Category__c();
        activeCategory.Is_Active__c = true;
        activeCategory.Category_Name__c = 'Active Category';
        categories.add(activeCategory);
        Report_Finder_Category__c inactiveCategory = new Report_Finder_Category__c();
        inactiveCategory.Is_Active__c = false;
        inactiveCategory.Category_Name__c = 'Inactive Category';
        categories.add(inactiveCategory);

        insert categories;

    }

    /*******************************************************************************************************
    * @description Tests retrieving active and assigned records
    */
    @isTest
    private static void testRetrieveJobsWithFilters(){

        // get report from setup method
        Report_Finder_Item__c rfi = [SELECT Id FROM Report_Finder_Item__c WHERE Item_Name__c = 'Test Report Finder Item'][0];

        // get filter from setup method
        Report_Finder_Job_Function__c job = [SELECT Id FROM Report_Finder_Job_Function__c WHERE  Job_Function_Name__c = 'Active Job'][0];

        // create a filter on a report so the value is loaded in the controller
        Report_Finder_Job_Function_Filter__c jobFilter = new Report_Finder_Job_Function_Filter__c();
        jobFilter.Job_Function__c = job.Id;
        jobFilter.Report_Finder_Item__c = rfi.Id;
        insert jobFilter;

        List<String> results;
        Integer countResults;

        Test.startTest();
        results = ReportFinderFilterController.getJobFunctions();
        Test.stopTest();

        countResults = results.size();

        System.assertEquals(1, countResults, 'Expect 1 active record to be returned');
    }


    /*******************************************************************************************************
    * @description Tests retrieving active and assigned records
    */
    @isTest
    private static void testRetrieveCategoriesWithFilters(){

        // get report from setup method
        Report_Finder_Item__c rfi = [SELECT Id FROM Report_Finder_Item__c WHERE Item_Name__c = 'Test Report Finder Item'][0];

        // get filter from setup method
        Report_Finder_Category__c category = [SELECT Id FROM Report_Finder_Category__c WHERE  Category_Name__c = 'Active Category'][0];

        // create a filter on a report so the value is loaded in the controller
        Report_Finder_Category_Filter__c categoryFilter = new Report_Finder_Category_Filter__c();
        categoryFilter.Report_Finder_Category__c = category.Id;
        categoryFilter.Report_Finder_Item__c = rfi.Id;
        insert categoryFilter;

        List<String> results;
        Integer countResults;

        Test.startTest();
        results = ReportFinderFilterController.getCategories();
        Test.stopTest();

        countResults = results.size();

        System.assertEquals(1, countResults, 'Expect 1 active record to be returned');
    }


    /*******************************************************************************************************
    * @description Tests retrieving active records that are not assigned to any report
    */
    @isTest
    private static void testRetrieveCategoriesWithoutFilters(){
        List<String> results;
        Integer countResults;

        Test.startTest();
        results = ReportFinderFilterController.getCategories();
        Test.stopTest();

        countResults = results.size();

        System.assertEquals(0, countResults, 'Expect 0 records to be returned');
    }


    /*******************************************************************************************************
    * @description Tests retrieving active records that are not assigned to any report
    */
    @isTest
    private static void testRetrieveJobsWithoutFilters(){
        List<String> results;
        Integer countResults;

        Test.startTest();
        results = ReportFinderFilterController.getJobFunctions();
        Test.stopTest();

        countResults = results.size();

        System.assertEquals(0, countResults, 'Expect 0 records to be returned');
    }



    /*******************************************************************************************************
    * @description Tests retrieving picklist values
    */
    @isTest
    private static void testRetrieveTypes(){
        List<String> results;
        Integer countResults;
        List<String> reportTypes = new List<String>();
        Integer countActiveValues;

        Schema.DescribeFieldResult reportTypeFields = Report_Finder_Item__c.Type__c.getDescribe();
        for(Schema.PicklistEntry fld : reportTypeFields.getPicklistValues()){
            if(fld.isActive() == true){
                reportTypes.add(fld.getValue());
            }   
        }

        Test.startTest();
        results = ReportFinderFilterController.getReportTypes();
        Test.stopTest();

        countResults = results.size();
        countActiveValues = reportTypes.size();

        System.assert(countActiveValues == countResults, 'Expect matching counts of active picklist values');
    }

    
}
