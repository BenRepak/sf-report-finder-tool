/**
* @author Ben Repak u0884669
* @date 2022-September
*
* @description The controller used in the Report Finder App to retreive and display results of filtered report items
* The general framework was taken from: https://github.com/trailheadapps/ebikes-lwc/blob/main/force-app/main/default/classes/ProductController.cls
*/

public with sharing class ReportFinderController {
    
    // default page size for returned items
    public static Integer PAGE_SIZE = 8;

    // inner wrapper class to define a report finder item
    public class ReportInfo {
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String name { get; set; }
        @AuraEnabled
        public String thumbnail { get; set; }
        @AuraEnabled
        public String longDescription { get; set; }
        @AuraEnabled
        public String shortDescription { get; set; }
        @AuraEnabled
        public String type { get; set; }
        @AuraEnabled
        public Boolean isBookmarked { get; set; }
        @AuraEnabled
        public String accessUrl { get; set; }
  
        // 0 argument constructor for wrapper
        public ReportInfo(){}

        // single argument constructor for wrapper 
        // builds a ReportInfo object from the Report_Finder_Item__c record
        public ReportInfo(Report_Finder_Item__c item){
            this.id = item.Id;
            this.name = item.Item_Name__c;
            this.thumbnail = item.Thumbnail_URL__c;
            this.longDescription = item.Long_Description__c;
            this.shortDescription = item.Short_Description__c;
            this.type = item.Type__c;
            this.isBookmarked = (item.Report_Finder_User_Bookmarks__r.size() > 0)? true : false; // identified if bookmarked for the running user
            this.accessUrl = item.Access_URL__c;
        }
    } 

    /*******************************************************************************************************
    * @description queries for report items based on the filters and page number. Used for invocable methods.
    * @param filters instance of filters for use in query as provided by the reportFindersFilters lwc
    * @param pageNumber page number from the paginator lwc, which applies an offset to the query
    * @return a custom instance of PageResult for use in the lwc
    */
    @AuraEnabled
    public static PagedResult refreshReports(ReportFinderFilter filters, Integer pageNumber) {
        return getReports(filters, pageNumber);
    }


    /*******************************************************************************************************
    * @description queries for report items based on the filters and page number. Used for wired methods. 
    * @param filters instance of filters for use in query as provided by the reportFindersFilters lwc
    * @param pageNumber page number from the paginator lwc, which applies an offset to the query
    * @return a custom instance of PageResult for use in the lwc
    */
    @AuraEnabled(cacheable=true)
    public static PagedResult getReports(ReportFinderFilter filters, Integer pageNumber) {

        // create a list of wrapper classes 
        List<ReportInfo> reports = new List<ReportInfo>();
        // initialize variables to be used in the query 
        String key, whereClause = '';
        String[] jobFunctions, type,categories, criteria = new List<String>{};
        Id currentUser = UserInfo.getUserId();
        
        // if filters has a value then build the criteria, which will be usedi n the filter
        if (filters != null) {
            // apply name / short description search filter
            if (!String.isEmpty(filters.searchKey)) {
                String cleansedKey = String.escapeSingleQuotes(filters.searchKey);
                key = '%' + filters.searchKey + '%';
                criteria.add('(Item_Name__c LIKE : key OR Short_Description__c LIKE : key)');
            }
            
            // apply job function filters
            if (filters.jobFunctions != null && filters.jobFunctions.size() > 0) {
                jobFunctions = filters.jobFunctions;
                criteria.add('Id IN (SELECT Report_Finder_Item__c FROM Report_Finder_Job_Function_Filter__c WHERE Job_Function__r.Job_Function_Name__c IN :jobFunctions)');
            }

            // apply type filters
            if (filters.type != null && filters.type.size() > 0) {
                type = filters.type;
                criteria.add('Type__c = :type');
            }

            // apply category / purpose filters
            if (filters.categories != null && filters.categories.size() > 0) {
                categories = filters.categories;
                system.debug('categories --> ' + categories);
                criteria.add('Id IN (SELECT Report_Finder_Item__c FROM Report_Finder_Category_Filter__c WHERE Report_Finder_Category__r.Category_Name__c IN :categories)');
            }


            // apply bookmarks only filter
            if(filters.bookmarksOnly == true){
                criteria.add('Id IN (SELECT Report_Finder_Item__c FROM Report_Finder_User_Bookmark__c WHERE Bookmarked_By__c = :currentUser)');
            }
        
        } // end if filters != null

        // only query Report_Finder_Item__c reqords that are published
        criteria.add('Publish_Status__c = \'Published\'');

        // for each string in the criteria list, append to the where clause 
        if (criteria.size() > 0) {
            whereClause = 'WHERE ' + String.join(criteria, ' AND ');
            system.debug('criteria --> ' + criteria);
            system.debug('where clause --> ' + whereClause);
        }
        
        
        Integer pageSize = ReportFinderController.PAGE_SIZE;
        Integer offset = (pageNumber - 1) * pageSize;
        // begin building the custom PageResult object
        PagedResult result = new PagedResult();
        result.pageSize = pageSize;
        

        // build the query string to retreive Report_Finder_Item__c records and child Report_Finder_User_Bookmark__c records associated with the running user
        string queryString =    
        'SELECT Id, Item_Name__c,Thumbnail_URL__c, Name, Long_Description__c,Short_Description__c, Type__c, Publish_Status__c, Access_URL__c ' + 
        ',(SELECT Id, Name FROM Report_Finder_User_Bookmarks__r WHERE Bookmarked_By__c = : currentUser) ' + 
        ' FROM Report_Finder_Item__c ' +
        whereClause + 
        ' WITH SECURITY_ENFORCED' +
        ' ORDER BY Item_Name__c LIMIT :pageSize OFFSET :offset';

        // identify total number of returned resulsts 
        result.totalItemCount = Database.countQuery('SELECT count() FROM Report_Finder_Item__c ' + whereClause);

        // identify current page number
        result.pageNumber = ( result.totalItemCount <= result.pageSize ? 1 : pageNumber);

        // execute query and build a list of custom wrappers
        for(Report_Finder_Item__c item : Database.query(queryString)){
            ReportInfo report = new ReportInfo(item);
            system.debug('report --> ' + report);
            reports.add(report);
        }

        // finish building the custom PageResult object and return the object
        result.records = reports;
        system.debug('result --> ' + result);
        system.debug('result.records --> ' + result.records);
        return result;
    }







}