/**
* @author Ben Repak u0884669
* @date 2022-September
*
* @description Controller used in the Report Finder App to insert / delete Report_Finder_User_Bookmark__c records
*/

public without sharing class ReportBookmarkController {

    /*******************************************************************************************************
    * @description Inserts/Updates bookmark records for specific Report Finder Items, and returns an updated ReportInfo reocrd
    * @param reportId Id of Report_Finder_Item__c to be bookmarked or unbookmarked
    * @param isAdd if TRUE, an insert bookmark operatoin is needed. If FALSE, a delete bookmark operation is needed. 
    * @return a new instance of the ReportFinderController.ReportInfo inner class with the isBookmarked attribute updated
    */
    @AuraEnabled(cacheable=false)
    public static ReportFinderController.ReportInfo updateBookmark(Id reportId, Boolean isAdd){
        Id currentUser = UserInfo.getUserId();

        Report_Finder_User_Bookmark__c bookmark = new Report_Finder_User_Bookmark__c();
        bookmark.Bookmarked_By__c = currentUser;
        bookmark.Report_Finder_Item__c = reportId;
        List<Report_Finder_User_Bookmark__c> bookmarks = new List<Report_Finder_User_Bookmark__c>();

        // check to see if a bookmark already exists for the current recordId for the running user
        bookmarks = [SELECT Id FROM Report_Finder_User_Bookmark__c WHERE Bookmarked_By__c = :currentUser AND Report_Finder_Item__c = :reportId];

        // is isAdd == TRUE, then the user wants to add a new bookmark
        if(isAdd){
            try{
                // if no bookmark records were from from the query above, insert a bookmark
                if(bookmarks.size() == 0){
                    bookmarks.add(bookmark);
                    insert bookmarks;
                // if a bookmark record was found in the query above, no insert or update is needed
                } else {
                    system.debug('no insert needed');
                }
            }catch(Exception e){
                system.debug('error inserting bookmarks --> ' + e);
                throw new AuraHandledException('An error occured --> ' + e);
            }
        // if isAdd == FALSE, then the user wants to remove the bookmark 
        } else {
            // if a bookmark record was found in the query above, delete the record
            if(bookmarks.size() > 0){
                try{
                    delete bookmarks;
                }catch(Exception e){
                    system.debug('error deleting bookmarks --> ' + e);
                    throw new AuraHandledException('An error occured --> ' + e);
                }
            }
        }

        // requery report to update the isBookmarked attribute on the ReportFinderController.ReportInfo inner class
        // without requerying, the UI element will not be updated in the reportFinderBookmarker lwc
       Report_Finder_Item__c item =  [SELECT Id,Item_Name__c, Thumbnail_URL__c, Name, Long_Description__c,Short_Description__c, Type__c, Publish_Status__c, Access_URL__c, (SELECT Id, Name FROM Report_Finder_User_Bookmarks__r WHERE Bookmarked_By__c = : currentUser) FROM Report_Finder_Item__c WHERE Id = :reportId];

       // build and return new instance of ReportInfo
       ReportFinderController.ReportInfo report = new ReportFinderController.ReportInfo(item);
       return report;
    }


}