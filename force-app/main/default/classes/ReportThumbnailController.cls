/**
* @author Ben Repak u0884669
* @date 2022-September
*
* @description Controller used in the Report Finder App to update Thumbnail photos 
*/
public with sharing class ReportThumbnailController {

    private static String thumbnailUrl;
    

    /*******************************************************************************************************
    * @description Rereives access URL for thumbnail in the Report Finder App
    * @param reportId Id of Report_Finder_Item__c to retreive thumbnail access url
    * @return a new instance of ReportInfo from the ReportFinderController class
    */
    @AuraEnabled
    public static ReportFinderController.ReportInfo getReport(String recordId){
        Report_Finder_Item__c rfi = new Report_Finder_Item__c();
        string queryString =    'SELECT Id, Item_Name__c,Thumbnail_URL__c, Name, Long_Description__c,Short_Description__c, Type__c, Publish_Status__c, Access_URL__c ' + 
        ' FROM Report_Finder_Item__c ' +
        ' WHERE Id = :recordId';
        rfi = database.query(queryString);
        ReportFinderController.ReportInfo report = new ReportFinderController.ReportInfo(rfi);
        return report;
    }

  
    /*******************************************************************************************************
    * @description Inserts/Updates content documents and adds content version link to RFI access URL for thumbnail
    * TODO - find a way to speed up preview or cache the images
    * @param contentVersionId contentVersionId from the newly uploaded file
    * @param contentDocumentId contentDocumentId from the newly uploaded file
    * @param reportId Id of Report_Finder_Item__c to associate with the file upload
    * @return a string containing the url encoded blow data of the uploaded picture
    */
    @AuraEnabled
    public static String updateThumbnail(String contentVersionId, String contentDocumentId, String recordId) {
      String versionData;
      // return null if any of the inputs are null
      if (contentVersionId == null || recordId == null || contentDocumentId == null) { return null; }
       
      try {

        // get content version body and access url
        ContentVersion cv = [SELECT Id, VersionData, Field_Image_URL__c FROM ContentVersion WHERE Id =: contentVersionId];

        // encode photo data 
        versionData = System.EncodingUtil.base64Encode(cv.versionData);

        // get relative URL to avoid CORS issues 
        String urlSubstring = cv.Field_Image_URL__c.substringAfter('.com');

        Report_Finder_Item__c rfi = new Report_Finder_Item__c();
        rfi.Id = recordId;
        rfi.Thumbnail_URL__c = urlSubstring;
        // rfi.Thumbnail_Url__c = '/sfc/servlet.shepherd/version/download/' + contentVersionId;
        return versionData;
      } catch(DMLException e) {
        system.debug('error');
        System.debug(e.getMessage());
        return null;
      }
    }

}

