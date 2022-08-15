public without sharing class ReportBookmarkController {



    @AuraEnabled(cacheable=false)
    public static ReportFinderController.ReportInfo updateBookmark(Id reportId, Boolean isAdd){
        Id currentUser = UserInfo.getUserId();

        Report_Finder_User_Bookmark__c bookmark = new Report_Finder_User_Bookmark__c();
        bookmark.Bookmarked_By__c = currentUser;
        bookmark.Report_Finder_Item__c = reportId;
        List<Report_Finder_User_Bookmark__c> bookmarks = new List<Report_Finder_User_Bookmark__c>();
        bookmarks = [SELECT Id FROM Report_Finder_User_Bookmark__c WHERE Bookmarked_By__c = :currentUser AND Report_Finder_Item__c = :reportId];

        if(isAdd){
           
            
            try{
                if(bookmarks.size() == 0){
                    bookmarks.add(bookmark);
                    insert bookmarks;
                } else {
                    system.debug('no insert needed');
                }

                }catch(Exception e){
                    system.debug('error --> ' + e);
                    throw new AuraHandledException('An error occured --> ' + e);

            }
            // delete
        } else {
            if(bookmarks.size() > 0){
                delete bookmarks;
            }
        }


       Report_Finder_Item__c item =  [SELECT Id,Item_Name__c, Thumbnail_URL__c, Name, Report_Description__c,Report_Short_Description__c, Type__c, Publish_Status__c, Report_URL__c, (SELECT Id, Name FROM Report_Finder_User_Bookmarks__r WHERE Bookmarked_By__c = : currentUser) FROM Report_Finder_Item__c WHERE Id = :reportId];
       ReportFinderController.ReportInfo report = new ReportFinderController.ReportInfo(item);

      return report;

    }


}
