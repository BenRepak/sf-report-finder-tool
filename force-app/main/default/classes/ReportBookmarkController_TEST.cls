/**
* @author Ben Repak u0884669
* @date 2022-September
*
* @description Test class for ReportBookmarkController
*/
@isTest
public with sharing class ReportBookmarkController_TEST {


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
    * @description Tests creating a new bookmark for a specific report finder item. Assumes the user has not bookmarked the report before.
    */
    @isTest   
    private static void testAddNewBookmark(){
        Integer beforeCount;
        Integer afterCount;
        // get report from setup method
        Report_Finder_Item__c rfi = [SELECT Id FROM Report_Finder_Item__c WHERE Item_Name__c = 'Test Report Finder Item'];

        // get bookmarks for current report before running tests
        List<Report_Finder_User_Bookmark__c> beforeBookmarks = [SELECT Id FROM Report_Finder_User_Bookmark__c WHERE Report_Finder_Item__c = :rfi.id];
        List<Report_Finder_User_Bookmark__c> afterBookmarks;

        Test.startTest();
        // test adding a bookmark
        ReportBookmarkController.updateBookmark(rfi.id, true);
        Test.stopTest();

        // get bookmarks for current report after running tests
        afterBookmarks = [SELECT Id FROM Report_Finder_User_Bookmark__c WHERE  Report_Finder_Item__c = :rfi.id];

        // check before/after counts 
        beforeCount = beforeBookmarks.size();
        afterCount = afterBookmarks.size();

        System.assertEquals(0, beforeCount, 'Expect no bookmarks before running test');
        System.assertEquals(1, afterCount, 'Expect 1 bookmark after running test');
    }


    /*******************************************************************************************************
    * @description Tests ignoring a request to create a new bookmark for a specific report finder item. Assumes the user has not bookmarked the report before.
    */
    @isTest   
    private static void testAddExistingBookmark(){
        Integer beforeCount;
        Integer afterCount;
        // get report from setup method
        Report_Finder_Item__c rfi = [SELECT Id FROM Report_Finder_Item__c WHERE Item_Name__c = 'Test Report Finder Item'];

        // create a bookmark for the report
        Id currentUser = UserInfo.getUserId();
        Report_Finder_User_Bookmark__c bm = new Report_Finder_User_Bookmark__c();
        bm.Bookmarked_By__c = currentUser;
        bm.Report_Finder_Item__c = rfi.id;
        insert bm;

        // get bookmarks for current report before running tests
        List<Report_Finder_User_Bookmark__c> beforeBookmarks = [SELECT Id FROM Report_Finder_User_Bookmark__c WHERE Report_Finder_Item__c = :rfi.id];
        List<Report_Finder_User_Bookmark__c> afterBookmarks;

        Test.startTest();
        // test adding a bookmark
        ReportBookmarkController.updateBookmark(rfi.id, true);
        Test.stopTest();
        // get bookmarks for current report after running tests
        afterBookmarks = [SELECT Id FROM Report_Finder_User_Bookmark__c WHERE  Report_Finder_Item__c = :rfi.id];

        // check before/after counts 
        beforeCount = beforeBookmarks.size();
        afterCount = afterBookmarks.size();

        System.assertEquals(1, beforeCount, 'Expect 1 bookmark before running test');
        System.assertEquals(1, afterCount, 'Expect 1 bookmark after running test');
    }


  /*******************************************************************************************************
    * @description Tests removing a bookmark for a specific report finder item. Assumes the user has bookmarked the report before.
    */
    @isTest   
    private static void testRemoveBookmark(){
        Integer beforeCount;
        Integer afterCount;

        // get report from setup method
        Report_Finder_Item__c rfi = [SELECT Id FROM Report_Finder_Item__c WHERE Item_Name__c = 'Test Report Finder Item'];

        // create a bookmark for the report
        Id currentUser = UserInfo.getUserId();
        Report_Finder_User_Bookmark__c bm = new Report_Finder_User_Bookmark__c();
        bm.Bookmarked_By__c = currentUser;
        bm.Report_Finder_Item__c = rfi.id;
        insert bm;
               
        // get bookmarks for current report before running tests
        List<Report_Finder_User_Bookmark__c> beforeBookmarks = [SELECT Id FROM Report_Finder_User_Bookmark__c WHERE Report_Finder_Item__c = :rfi.id];
        List<Report_Finder_User_Bookmark__c> afterBookmarks;

        Test.startTest();
        // test removing a bookmark
        ReportBookmarkController.updateBookmark(rfi.id, false);
        Test.stopTest();

        // get bookmarks for current report after running tests
        afterBookmarks = [SELECT Id FROM Report_Finder_User_Bookmark__c WHERE  Report_Finder_Item__c = :rfi.id];

        // check before/after counts 
        beforeCount = beforeBookmarks.size();
        afterCount = afterBookmarks.size();

        System.assertEquals(1, beforeCount, 'Expect 1 bookmark before running test');
        System.assertEquals(0, afterCount, 'Expect 0 bookmarks after running test');
        
    }
}
