public with sharing class ReportThumbnailController {
    

    @AuraEnabled(cacheable=false)
    public static string updateReportThumbnail(Id contentDocumentId, Id parentRecordId){

        ContentVersion cv = [select id, title from contentversion where contentdocumentid =:contentDocumentId];
        

        Report_Finder_Item__c item = new Report_Finder_Item__c();
        item.id = parentRecordId;
        item.thumbnail_url__c = '/sfc/servlet.shepherd/version/download/' + cv.id;
        update item;

         return  item.thumbnail_url__c ;
    }
    

    @AuraEnabled(cacheable=true)
    public static string getReportThumbnail(Id parentRecordId){

        Report_Finder_Item__c item = new Report_Finder_Item__c();
        item = [select thumbnail_url__c from Report_Finder_Item__c where Id =:parentRecordId];

        return item.thumbnail_url__c ;

    }



}

///sfc/servlet.shepherd/version/download/06923000000w8BmAAI 
