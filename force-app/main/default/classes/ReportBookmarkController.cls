public without sharing class ReportBookmarkController {



    @AuraEnabled(cacheable=false)
    public static void updateBookmark(Id reportId, Boolean isAdd){
        Id currentUser = UserInfo.getUserId();

        Report_Finder_User_Bookmark__c bookmark = new Report_Finder_User_Bookmark__c();
        bookmark.Bookmarked_By__c = currentUser;
        bookmark.Advancement_Report__c = reportId;
        List<Report_Finder_User_Bookmark__c> bookmarks = new List<Report_Finder_User_Bookmark__c>();
        bookmarks = [SELECT Id FROM Report_Finder_User_Bookmark__c WHERE Bookmarked_By__c = :currentUser AND Advancement_Report__c = :reportId];

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

        
    }


}
