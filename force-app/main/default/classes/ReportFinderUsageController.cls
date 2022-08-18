public without sharing class ReportFinderUsageController {
    private static DateTime TODAY_DATE_TIME = System.now();

    @AuraEnabled(cacheable=false)
    public static void logItemUsage(Id reportId){
        Id currentUser = UserInfo.getUserId();
       

        Report_Finder_Item_Usage__c itemUsage = new Report_Finder_Item_Usage__c();
        itemUsage.Accessed_By__c = currentUser;
        itemUsage.Report_Finder_Item__c = reportId;
        itemUsage.Accessed_Date__c = TODAY_DATE_TIME;

        try{
            insert itemUsage;
        }catch(Exception e){
            system.debug('error --> ' + e);
                    throw new AuraHandledException('An error occured --> ' + e);
        }
    }
}
