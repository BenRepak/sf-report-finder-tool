/**
* @author Ben Repak
* @date 2022-September
*
* @description Controller used in the Report Finder App to insert / delete Report_Finder_Item_Usage__c records
*/


public without sharing class ReportFinderUsageController {

    // current date / time for use with timestamping usage log
    @TestVisible
    private static DateTime todayDateTime = System.now();

    /*******************************************************************************************************
    * @description Inserts/Updates use log records for specific Report Finder Items that are opened from the Report Finder App
    * @param reportId Id of Report_Finder_Item__c to be bookmarked or unbookmarked
    */
    @AuraEnabled(cacheable=false)
    public static void logItemUsage(Id reportId){
        // build usage log record for current user
        Id currentUser = UserInfo.getUserId();
        Report_Finder_Item_Usage__c itemUsage = new Report_Finder_Item_Usage__c();
        itemUsage.Accessed_By__c = currentUser;
        itemUsage.Report_Finder_Item__c = reportId;
        itemUsage.Accessed_Date__c = todayDateTime;

        // try to insert the usage log
        try{
            insert itemUsage;
        }catch(Exception e){
            system.debug('error inserting usage log record --> ' + e);
            throw new AuraHandledException('An error occured --> ' + e);
        }
    }
}