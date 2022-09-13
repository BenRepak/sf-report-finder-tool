public with sharing class ReportThumbnailController {

    private static String thumbnailUrl;
    

    @AuraEnabled(cacheable=true)
    public static String getThumbnail(String recordId){
        system.debug('recordId --> ' + recordId);
        if(string.isNotBlank(thumbnailUrl)){
            system.debug('thumbnailURL --> ' + thumbnailUrl);
            String returnThumbnail = thumbnailUrl;
            return returnThumbnail;
        } else {
            system.debug('else');
            return [SELECT Thumbnail_URL__c FROM Report_Finder_Item__c WHERE Id =:recordId][0].Thumbnail_URL__c;
        }

    }

    @AuraEnabled(cacheable=true)
    public static ReportFinderController.ReportInfo getReport(String recordId){
        system.debug('recordId --> ' + recordId);

        Report_Finder_Item__c rfi = new Report_Finder_Item__c();
        string queryString =    'SELECT Id, Item_Name__c,Thumbnail_URL__c, Name, Long_Description__c,Short_Description__c, Type__c, Publish_Status__c, Access_URL__c ' + 
        ' FROM Report_Finder_Item__c ' +
        ' WHERE Id = :recordId';
        rfi = database.query(queryString);
        ReportFinderController.ReportInfo report = new ReportFinderController.ReportInfo(rfi);
        return report;
        

    }

  
     /*
     */
    @AuraEnabled
    public static String updateThumbnail(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDistribution  cd = new ContentDistribution();
        cd.ContentVersionId = contentVersionId;
        cd.PreferencesAllowViewInBrowser= true;
        cd.PreferencesLinkLatestVersion=true;
        cd.PreferencesNotifyOnVisit=false;
        cd.PreferencesPasswordRequired=false;
        cd.PreferencesAllowOriginalDownload= true;
        cd.Name = 'Report Finder Thumbnail - record ' + recordId;

        
        
     
      try {
        insert cd;
        system.debug('cd --> ' + cd);
        thumbnailUrl = [SELECT DistributionPublicUrl FROM ContentDistribution WHERE Id = :cd.Id].DistributionPublicUrl;

        Report_Finder_Item__c rfi = new Report_Finder_Item__c();
        rfi.Id = recordId;
        rfi.Thumbnail_Url__c = '/sfc/servlet.shepherd/version/download/'+contentVersionId;
        update rfi;
        system.debug('rfi --> ' + rfi);

        return getThumbnail(recordId);
      } catch(DMLException e) {
        system.debug('error');
        System.debug(e.getMessage());
        return null;
      }
    }


}

///sfc/servlet.shepherd/version/download/06923000000w8BmAAI 
