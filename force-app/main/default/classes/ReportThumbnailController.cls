/**
* @author Ben Repak u0884669
* @date 2022-September
*
* @description Controller used in the Report Finder App to update Thumbnail photos 
*/
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

  

    @AuraEnabled
    public static String updateThumbnail(String contentVersionId, String contentDocumentId, String recordId) {
      if (contentVersionId == null || recordId == null || contentDocumentId == null) { return null; }
       
      try {
       
        Report_Finder_Item__c rfi = new Report_Finder_Item__c();
        rfi.Id = recordId;
        rfi.Thumbnail_Url__c = System.URL.getSalesforceBaseUrl().toExternalForm()+'/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId=' 
        +  contentVersionId
        + '&operationContext=CHATTER&contentId='
        + contentDocumentId;
        update rfi;
        system.debug('rfi --> ' + rfi);
        return rfi.Thumbnail_Url__c;
      } catch(DMLException e) {
        system.debug('error');
        System.debug(e.getMessage());
        return null;
      }
    }

}

