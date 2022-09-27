/**
* @author Ben Repak u0884669
* @date 2022-September
*
* @description Test class for ReportFinderController
*/
@isTest
public with sharing class ReportFinderController_TEST {

    @TestSetup
    static void makeData(){
        Report_Finder_Item__c rfi = new Report_Finder_Item__c();
        rfi.Item_Name__c = 'Test Report Finder Item';
        rfi.Short_Description__c = 'Short Description';
        rfi.Long_Description__c = 'Long Description';
        rfi.Publish_Status__c = 'Published';
        rfi.Type__c = 'Tableau Dashboard';
        rfi.Access_URL__c = 'https://utah.edu';
        rfi.Thumbnail_URL__c = '/bogus_url/';
        insert rfi;

       // create a bookmark for the report
       Id currentUser = UserInfo.getUserId();
       Report_Finder_User_Bookmark__c bm = new Report_Finder_User_Bookmark__c();
       bm.Bookmarked_By__c = currentUser;
       bm.Report_Finder_Item__c = rfi.id;
       insert bm;


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
        
        // create job filter
        List<Report_Finder_Job_Function_Filter__c> jobFilters = new List<Report_Finder_Job_Function_Filter__c>();
        for(Report_Finder_Job_Function__c job : jobs){
            Report_Finder_Job_Function_Filter__c jobFilter = new Report_Finder_Job_Function_Filter__c();
            jobFilter.Job_Function__c = job.Id;
            jobFilter.Report_Finder_Item__c = rfi.Id;
            jobFilters.add(jobFilter);
        }

        insert jobFilters;

        // create category filter
        List<Report_Finder_Category_Filter__c> categoryFilters = new List<Report_Finder_Category_Filter__c>();
        for(Report_Finder_Category__c category : categories){
            Report_Finder_Category_Filter__c categoryFilter = new Report_Finder_Category_Filter__c();
            categoryFilter.Report_Finder_Category__c = category.Id;
            categoryFilter.Report_Finder_Item__c = rfi.Id;
            categoryFilters.add(categoryFilter);
        }

        insert categoryFilters;

    }

     /*******************************************************************************************************
    * @description Tests retrieving reports without any filters
    */
    @isTest 
    private static void testGetReportsWithNoFilters(){

        Integer pageNumber = 1;

        ReportFinderFilter filters = new ReportFinderFilter();

        PagedResult result;

        Test.startTest();
        result = ReportFinderController.refreshReports(filters, pageNumber);
        Test.stopTest();
        // cast 1st result record to a report info object
        ReportFinderController.ReportInfo reportInfo = (ReportFinderController.ReportInfo)result.records[0];
        System.assertEquals(ReportFinderController.PAGE_SIZE, result.pageSize, 'Expect pageSize to be value set in ReportFinderController');
        System.assertEquals(1, result.pageNumber, 'Expect pageNumber to be 1');
        System.assertEquals(1, result.totalItemCount, 'Expect totalItemCount to be 1');
        System.assertEquals('Test Report Finder Item', reportInfo.name, 'Expect name to match record from setup');
        System.assertEquals('Long Description', reportInfo.longDescription, 'Expect longDescription to match record from setup');
        System.assertEquals('Tableau Dashboard', reportInfo.type, 'Expect type to match record from setup');
        System.assertEquals('https://utah.edu', reportInfo.accessUrl, 'Expect accessUrl to match record from setup');
    }

     /*******************************************************************************************************
    * @description Tests retrieving reports a valid job filter
    */
    @isTest 
    private static void testGetReportsWithJobFilters(){

        Integer pageNumber = 1;

        ReportFinderFilter filters = new ReportFinderFilter();
        filters.jobFunctions = new List<String>{'Active Job'};
        PagedResult result;

        Test.startTest();
        result = ReportFinderController.refreshReports(filters, pageNumber);
        Test.stopTest();
        // cast 1st result record to a report info object
        ReportFinderController.ReportInfo reportInfo = (ReportFinderController.ReportInfo)result.records[0];
        System.assertEquals(ReportFinderController.PAGE_SIZE, result.pageSize, 'Expect pageSize to be value set in ReportFinderController');
        System.assertEquals(1, result.pageNumber, 'Expect pageNumber to be 1');
        System.assertEquals(1, result.totalItemCount, 'Expect totalItemCount to be 1');
        System.assertEquals('Test Report Finder Item', reportInfo.name, 'Expect name to match record from setup');
        System.assertEquals('Long Description', reportInfo.longDescription, 'Expect longDescription to match record from setup');
        System.assertEquals('Tableau Dashboard', reportInfo.type, 'Expect type to match record from setup');
        System.assertEquals('https://utah.edu', reportInfo.accessUrl, 'Expect accessUrl to match record from setup');
    }


     /*******************************************************************************************************
    * @description Tests retrieving reports an invalid job filter
    */
    @isTest 
    private static void testGetReportsWithInvalidJobFilters(){
        Integer pageNumber = 1;
        ReportFinderFilter filters = new ReportFinderFilter();
        filters.jobFunctions = new List<String>{'thisshouldreturnnoresulsts'};
        PagedResult result;

        Test.startTest();
        result = ReportFinderController.refreshReports(filters, pageNumber);
        Test.stopTest();
        System.assertEquals(ReportFinderController.PAGE_SIZE, result.pageSize, 'Expect pageSize to be value set in ReportFinderController');
        System.assertEquals(1, result.pageNumber, 'Expect pageNumber to be 1');
        System.assertEquals(0, result.totalItemCount, 'Expect totalItemCount to be 0');
    }


     /*******************************************************************************************************
    * @description Tests retrieving reports a valid category filter
    */
    @isTest 
    private static void testGetReportsWithCategoryFilters(){

        Integer pageNumber = 1;

        ReportFinderFilter filters = new ReportFinderFilter();
        filters.categories = new List<String>{'Active Category'};
        PagedResult result;

        Test.startTest();
        result = ReportFinderController.refreshReports(filters, pageNumber);
        Test.stopTest();
        // cast 1st result record to a report info object
        ReportFinderController.ReportInfo reportInfo = (ReportFinderController.ReportInfo)result.records[0];
        System.assertEquals(ReportFinderController.PAGE_SIZE, result.pageSize, 'Expect pageSize to be value set in ReportFinderController');
        System.assertEquals(1, result.pageNumber, 'Expect pageNumber to be 1');
        System.assertEquals(1, result.totalItemCount, 'Expect totalItemCount to be 1');
        System.assertEquals('Test Report Finder Item', reportInfo.name, 'Expect name to match record from setup');
        System.assertEquals('Long Description', reportInfo.longDescription, 'Expect longDescription to match record from setup');
        System.assertEquals('Tableau Dashboard', reportInfo.type, 'Expect type to match record from setup');
        System.assertEquals('https://utah.edu', reportInfo.accessUrl, 'Expect accessUrl to match record from setup');
    }


     /*******************************************************************************************************
    * @description Tests retrieving reports an invalid category filter
    */    @isTest 
    private static void testGetReportsWithInvalidCategoryFilters(){
        Integer pageNumber = 1;
        ReportFinderFilter filters = new ReportFinderFilter();
        filters.categories = new List<String>{'thisshouldreturnnoresulsts'};
        PagedResult result;

        Test.startTest();
        result = ReportFinderController.refreshReports(filters, pageNumber);
        Test.stopTest();
        System.assertEquals(ReportFinderController.PAGE_SIZE, result.pageSize, 'Expect pageSize to be value set in ReportFinderController');
        System.assertEquals(1, result.pageNumber, 'Expect pageNumber to be 1');
        System.assertEquals(0, result.totalItemCount, 'Expect totalItemCount to be 0');
    }


     /*******************************************************************************************************
    * @description Tests retrieving reports a valid searchKey filter
    */
    @isTest 
    private static void testGetReportsWithSearchKeyFilters(){

        Integer pageNumber = 1;

        ReportFinderFilter filters = new ReportFinderFilter();
        filters.searchKey = 'test report';
        PagedResult result;

        Test.startTest();
        result = ReportFinderController.refreshReports(filters, pageNumber);
        Test.stopTest();
        // cast 1st result record to a report info object
        ReportFinderController.ReportInfo reportInfo = (ReportFinderController.ReportInfo)result.records[0];
        System.assertEquals(ReportFinderController.PAGE_SIZE, result.pageSize, 'Expect pageSize to be value set in ReportFinderController');
        System.assertEquals(1, result.pageNumber, 'Expect pageNumber to be 1');
        System.assertEquals(1, result.totalItemCount, 'Expect totalItemCount to be 1');
        System.assertEquals('Test Report Finder Item', reportInfo.name, 'Expect name to match record from setup');
        System.assertEquals('Long Description', reportInfo.longDescription, 'Expect longDescription to match record from setup');
        System.assertEquals('Tableau Dashboard', reportInfo.type, 'Expect type to match record from setup');
        System.assertEquals('https://utah.edu', reportInfo.accessUrl, 'Expect accessUrl to match record from setup');
    }


     /*******************************************************************************************************
    * @description Tests retrieving reports an invalid searchKey filter
    */
    @isTest 
    private static void testGetReportsWithInvalidSearchKeyFilters(){
        Integer pageNumber = 1;
        ReportFinderFilter filters = new ReportFinderFilter();
        filters.searchKey = 'thisshouldreturnnoresulsts';
        PagedResult result;

        Test.startTest();
        result = ReportFinderController.refreshReports(filters, pageNumber);
        Test.stopTest();
        System.assertEquals(ReportFinderController.PAGE_SIZE, result.pageSize, 'Expect pageSize to be value set in ReportFinderController');
        System.assertEquals(1, result.pageNumber, 'Expect pageNumber to be 1');
        System.assertEquals(0, result.totalItemCount, 'Expect totalItemCount to be 0');
    }


     /*******************************************************************************************************
    * @description Tests retrieving reports a valid type filter
    */
    @isTest 
    private static void testGetReportsWithTypeFilters(){

        Integer pageNumber = 1;

        ReportFinderFilter filters = new ReportFinderFilter();
        filters.type = new List<String>{'Tableau Dashboard','another type filtler'};
        PagedResult result;

        Test.startTest();
        result = ReportFinderController.refreshReports(filters, pageNumber);
        Test.stopTest();
        // cast 1st result record to a report info object
        ReportFinderController.ReportInfo reportInfo = (ReportFinderController.ReportInfo)result.records[0];
        System.assertEquals(ReportFinderController.PAGE_SIZE, result.pageSize, 'Expect pageSize to be value set in ReportFinderController');
        System.assertEquals(1, result.pageNumber, 'Expect pageNumber to be 1');
        System.assertEquals(1, result.totalItemCount, 'Expect totalItemCount to be 1');
        System.assertEquals('Test Report Finder Item', reportInfo.name, 'Expect name to match record from setup');
        System.assertEquals('Long Description', reportInfo.longDescription, 'Expect longDescription to match record from setup');
        System.assertEquals('Tableau Dashboard', reportInfo.type, 'Expect type to match record from setup');
        System.assertEquals('https://utah.edu', reportInfo.accessUrl, 'Expect accessUrl to match record from setup');
    }


     /*******************************************************************************************************
    * @description Tests retrieving reports an invalid type filter
    */
    @isTest 
    private static void testGetReportsWithInvalidTypeFilters(){
        Integer pageNumber = 1;
        ReportFinderFilter filters = new ReportFinderFilter();
        filters.type = new List<String>{'thisshouldreturnnoresulsts'};
        PagedResult result;

        Test.startTest();
        result = ReportFinderController.refreshReports(filters, pageNumber);
        Test.stopTest();
        System.assertEquals(ReportFinderController.PAGE_SIZE, result.pageSize, 'Expect pageSize to be value set in ReportFinderController');
        System.assertEquals(1, result.pageNumber, 'Expect pageNumber to be 1');
        System.assertEquals(0, result.totalItemCount, 'Expect totalItemCount to be 0');
    }


    /*******************************************************************************************************
    * @description Tests retrieving reports an isBookmarked filter
    */
    @isTest 
    private static void testGetReportsWithBookmarkFilters(){

        Integer pageNumber = 1;

        ReportFinderFilter filters = new ReportFinderFilter();
        filters.bookmarksOnly = true;
        PagedResult result;

        Test.startTest();
        result = ReportFinderController.refreshReports(filters, pageNumber);
        Test.stopTest();
        // cast 1st result record to a report info object
        ReportFinderController.ReportInfo reportInfo = (ReportFinderController.ReportInfo)result.records[0];
        System.assertEquals(ReportFinderController.PAGE_SIZE, result.pageSize, 'Expect pageSize to be value set in ReportFinderController');
        System.assertEquals(1, result.pageNumber, 'Expect pageNumber to be 1');
        System.assertEquals(1, result.totalItemCount, 'Expect totalItemCount to be 1');
        System.assertEquals('Test Report Finder Item', reportInfo.name, 'Expect name to match record from setup');
        System.assertEquals('Long Description', reportInfo.longDescription, 'Expect longDescription to match record from setup');
        System.assertEquals('Tableau Dashboard', reportInfo.type, 'Expect type to match record from setup');
        System.assertEquals('https://utah.edu', reportInfo.accessUrl, 'Expect accessUrl to match record from setup');
    }




}
