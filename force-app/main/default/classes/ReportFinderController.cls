public with sharing class ReportFinderController {
    
    static Integer PAGE_SIZE = 6;

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
        @AuraEnabled
        public String[] jobFunctions { get; set; }
        @AuraEnabled
        public String[] categories { get; set; }
        @AuraEnabled
        public Boolean isNew { get; set; }
        @AuraEnabled
        public Boolean isRecentlyModified { get; set; }

        public ReportInfo(){

        }

        public ReportInfo(Report_Finder_Item__c item){
            this.id = item.Id;
            this.name = item.Item_Name__c;
            this.thumbnail = item.Thumbnail_URL__c;
            this.longDescription = item.Long_Description__c;
            this.shortDescription = item.Short_Description__c + ' Click to learn more.';
            this.type = item.Type__c;
            this.isBookmarked = (item.Report_Finder_User_Bookmarks__r.size() > 0)? true : false;
            this.accessUrl = item.Access_URL__c;
            this.jobFunctions = new List<String>{'Job1','Job2'};
            this.categories = new List<String>{'This is a word','Cat2','Another word','Cat4','Cat5'};
        }

    }

    @AuraEnabled
    public static PagedResult refreshReports(ReportFinderFilter filters, Integer pageNumber) {
        return getReports(filters, pageNumber);
    }


    @AuraEnabled(cacheable=true)
    public static PagedResult getReports(ReportFinderFilter filters, Integer pageNumber) {
        //https://github.com/trailheadapps/ebikes-lwc/blob/main/force-app/main/default/classes/ProductController.cls

        List<ReportInfo> reports = new List<ReportInfo>();
        String key, whereClause = '';
        String[] jobFunctions, type,categories, criteria = new List<String>{};
        Id currentUser = UserInfo.getUserId();
        if (filters != null) {
            if (!String.isEmpty(filters.searchKey)) {
                String cleansedKey = String.escapeSingleQuotes(filters.searchKey);
                key = '%' + filters.searchKey + '%';
                criteria.add('(Item_Name__c LIKE : key OR Short_Description__c LIKE : key)');
            }
            
            // job function filters
            if (filters.jobFunctions != null && filters.jobFunctions.size() > 0) {
                jobFunctions = filters.jobFunctions;
                criteria.add('Id IN (SELECT Report_Finder_Item__c FROM Report_Finder_Job_Function_Filter__c WHERE Job_Function__r.Job_Function_Name__c IN :jobFunctions)');
            }

            // type filters
            if (filters.type != null && filters.type.size() > 0) {
                type = filters.type;
                criteria.add('Type__c = :type');
            }

            // category / purpose filters
            if (filters.categories != null && filters.categories.size() > 0) {
                categories = filters.categories;
                system.debug('categories --> ' + categories);
                criteria.add('Id IN (SELECT Report_Finder_Item__c FROM Report_Finder_Category_Filter__c WHERE Report_Finder_Category__r.Category_Name__c IN :categories)');
            }


            // bookmarks only
            if(filters.bookmarksOnly == true){
                criteria.add('Id IN (SELECT Report_Finder_Item__c FROM Report_Finder_User_Bookmark__c WHERE Bookmarked_By__c = :currentUser)');
            }

           
         
        }
            criteria.add('Publish_Status__c != \'Not Published\' AND Publish_Status__c != \'\'');

            if (criteria.size() > 0) {
                whereClause = 'WHERE ' + String.join(criteria, ' AND ');
                system.debug('criteria --> ' + criteria);
                system.debug('where clause --> ' + whereClause);
            }
        

        Integer pageSize = ReportFinderController.PAGE_SIZE;
        Integer offset = (pageNumber - 1) * pageSize;
        PagedResult result = new PagedResult();
        result.pageSize = pageSize;
        

        
        string queryString =    'SELECT Id, Item_Name__c,Thumbnail_URL__c, Name, Long_Description__c,Short_Description__c, Type__c, Publish_Status__c, Access_URL__c ' + 
            ',(SELECT Id, Name FROM Report_Finder_User_Bookmarks__r WHERE Bookmarked_By__c = : currentUser) ' + 
            ' FROM Report_Finder_Item__c ' +
            
            whereClause + 
            ' WITH SECURITY_ENFORCED' +
            ' ORDER BY Item_Name__c LIMIT :pageSize OFFSET :offset';

            result.totalItemCount = Database.countQuery('SELECT count() FROM Report_Finder_Item__c ' + whereClause);

            result.pageNumber = ( result.totalItemCount <= result.pageSize ? 1 : pageNumber);


        
        

        for(Report_Finder_Item__c item : Database.query(queryString)){
            ReportInfo report = new ReportInfo(item);
            reports.add(report);

        }

        result.records = reports;
        system.debug('result --> ' + result);
        system.debug('result.totalItemCount --> ' + result.totalItemCount);


        return result;




    }







}
