public with sharing class ReportThumbnailController {
    

    @AuraEnabled(cacheable=false)
    public static string updateReportThumbnail(Id contentDocumentId, Id parentRecordId){

        ContentVersion cv = [select id, title from contentversion where contentdocumentid =:contentDocumentId];
        

        Advancement_Report__c ar = new Advancement_Report__c();
        ar.id = parentRecordId;
        ar.thumbnail_url__c = '/sfc/servlet.shepherd/version/download/' + cv.id;
        update ar;

        return ar.thumbnail_url__c ;
    }
    

    @AuraEnabled(cacheable=true)
    public static string getReportThumbnail(Id parentRecordId){

        Advancement_Report__c ar = new Advancement_Report__c();
        ar = [select thumbnail_url__c from Advancement_Report__c where Id =:parentRecordId];

        // ContentVersion cv = [select id, title from contentversion where contentdocumentid =:contentDocumentId];


        

    

        return ar.thumbnail_url__c ;

    }



}

///sfc/servlet.shepherd/version/download/06923000000w8BmAAI 
