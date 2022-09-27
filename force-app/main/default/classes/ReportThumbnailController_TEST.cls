/**
* @author Ben Repak u0884669
* @date 2022-September
*
* @description Test class for ReportThumbnailController
*/
@isTest
public with sharing class ReportThumbnailController_TEST {

    @TestSetup
    static void makeData(){
        Report_Finder_Item__c rfi = new Report_Finder_Item__c();
        rfi.Item_Name__c = 'Test Report Finder Item';
        rfi.Short_Description__c = 'Short Description';
        rfi.Long_Description__c = 'Long Description';
        rfi.Publish_Status__c = 'Published';
        rfi.Type__c = 'Tableau Dashboard';
        rfi.Access_URL__c = 'https://utah.edu';
        insert rfi;

    }

    
    /*******************************************************************************************************
    * @description Tests uploading a new image to the report
    */
    @isTest
    private static void testUploadThumbnail(){
        //Create a new file
        ContentVersion newFile = new ContentVersion();
        newFile.PathOnClient = 'TestFile';
        newFile.Title = 'TestFile';
        newFile.VersionData = Blob.valueOf('sample content');
        insert newFile;

        // get documentId
        String contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion where Id = :newFile.Id][0].ContentDocumentId;

        // get report from setup method
        Report_Finder_Item__c rfi = [SELECT Id FROM Report_Finder_Item__c WHERE Item_Name__c = 'Test Report Finder Item'];

        String thumbnailUrl;
        Test.startTest();
        thumbnailUrl = ReportThumbnailController.updateThumbnail(newFile.Id, contentDocumentId, rfi.Id);
        Test.stopTest();

        // get updated report from setup method after adding thumbnail
        Report_Finder_Item__c rfi2 = [SELECT Id, Thumbnail_URL__c FROM Report_Finder_Item__c WHERE Item_Name__c = 'Test Report Finder Item'];

        System.assertEquals(thumbnailUrl,rfi2.Thumbnail_URL__c, 'expect rfi thumbnail url to match return value from method');
    }

    /*******************************************************************************************************
    * @description Tests requerying a report based on id to get refreshed data
    */
    @isTest
    private static void testGetRefreshedReport(){
        // get report from setup method
        Report_Finder_Item__c rfi = [SELECT Id,Item_Name__c FROM Report_Finder_Item__c WHERE Item_Name__c = 'Test Report Finder Item'];

        ReportFinderController.ReportInfo report;
        Test.startTest();
        report = ReportThumbnailController.getReport(rfi.Id);
        Test.stopTest();

        System.assertEquals(rfi.id,report.id, 'expect report attributes to match when returned');
        System.assertEquals(rfi.item_name__c,report.name, 'expect report attributes to match when returned');
    }
    
}
