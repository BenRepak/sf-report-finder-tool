public with sharing class ReportThumbnailController {

    private static String thumbnailUrl;
    


    @AuraEnabled
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
      "/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=" +
            this.fileList[i].Id +
            "&operationContext=CHATTER&contentId=" +
            this.fileList[i].ContentDocumentId,
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

        return '/sfc/servlet.shepherd/version/download/'+contentVersionId;
      } catch(DMLException e) {
        system.debug('error');
        System.debug(e.getMessage());
        return null;
      }
    }


         /*
      "/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=" +
            this.fileList[i].Id +
            "&operationContext=CHATTER&contentId=" +
            this.fileList[i].ContentDocumentId,
     */
    @AuraEnabled
    public static String updateThumbnail2(String contentVersionId, String contentDocumentId, String recordId) {
      if (contentVersionId == null || recordId == null || contentDocumentId == null) { return null; }
       
      try {
       
        Report_Finder_Item__c rfi = new Report_Finder_Item__c();
        rfi.Id = recordId;
        rfi.Thumbnail_Url__c = '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=' 
        +  contentVersionId
        + '&operationContext=CHATTER&contentId='
        + contentDocumentId;
  
        update rfi;
        system.debug('rfi --> ' + rfi);

        return '/sfc/servlet.shepherd/version/download/'+contentVersionId;
      } catch(DMLException e) {
        system.debug('error');
        System.debug(e.getMessage());
        return null;
      }
    }
// /sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=0680R000001oWLjQAM&operationContext=CHATTER&contentId=0690R000001oJy7QAE

}

