/**
* @author Ben Repak u0884669
* @date 2022-September
*
* @description Test class for ReportFinderUsageController
*/
@isTest
public with sharing class ReportFinderUsageController_TEST {

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
    }


     /*******************************************************************************************************
    * @description Tests opening a new item and creating a log
    */
    @isTest   
    private static void testAddNewBookmark(){
        Integer beforeCount;
        Integer afterCount;
        // get report from setup method
        Report_Finder_Item__c rfi = [SELECT Id FROM Report_Finder_Item__c WHERE Item_Name__c = 'Test Report Finder Item'];

        // get logs for current report before running tests
        List<Report_Finder_Item_Usage__c> beforeLogs = [SELECT Id FROM Report_Finder_Item_Usage__c WHERE Report_Finder_Item__c = :rfi.id];
        List<Report_Finder_Item_Usage__c> afterLogs;

        Test.startTest();
        // test adding a log
        ReportFinderUsageController.logItemUsage(rfi.id);
        Test.stopTest();

        // get bookmarks for current report after running tests
        afterLogs = [SELECT Id FROM Report_Finder_Item_Usage__c WHERE  Report_Finder_Item__c = :rfi.id];

        // check before/after counts 
        beforeCount = beforeLogs.size();
        afterCount = afterLogs.size();

        System.assertEquals(0, beforeCount, 'Expect no logs before running test');
        System.assertEquals(1, afterCount, 'Expect 1 log after running test');
    }



    
   
}
