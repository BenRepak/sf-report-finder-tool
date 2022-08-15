public with sharing class ReportFinderController {
    
    static Integer PAGE_SIZE = 6;

    public class Filters {
        @AuraEnabled
        public String searchKey { get; set; }
        @AuraEnabled
        public String[] jobFunctions { get; set; }
        @AuraEnabled
        public String[] type { get; set; }
        @AuraEnabled
        public Boolean bookmarksOnly { get; set; }
    }



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

        public ReportInfo(){

        }

        public ReportInfo(Advancement_Report__c advRep){
            this.id = advRep.Id;
            this.name = advRep.Advancement_Report_Name__c;
            this.thumbnail = advRep.Thumbnail_URL__c;
            this.longDescription = advRep.Report_Description__c;
            this.shortDescription = advRep.Report_Short_Description__c + ' Click to learn more.';
            this.type = advRep.Type__c;
            this.isBookmarked = (advRep.Report_Finder_User_Bookmarks__r.size() > 0)? true : false;
            this.accessUrl = advRep.Report_URL__c;
        }

    }

    @AuraEnabled
    public static PagedResult refreshReports(Filters filters, Integer pageNumber) {
        return getReports(filters, pageNumber);
    }


    @AuraEnabled(cacheable=true)
    public static PagedResult getReports(Filters filters, Integer pageNumber) {
        //https://github.com/trailheadapps/ebikes-lwc/blob/main/force-app/main/default/classes/ProductController.cls

        List<ReportInfo> reports = new List<ReportInfo>();
        String key, whereClause = '';
        String[] jobFunctions, type, criteria = new List<String>{};
        Id currentUser = UserInfo.getUserId();
        if (filters != null) {
            if (!String.isEmpty(filters.searchKey)) {
                String cleansedKey = String.escapeSingleQuotes(filters.searchKey);
                key = '%' + filters.searchKey + '%';
                criteria.add('(Advancement_Report_Name__c LIKE : key OR Report_Short_Description__c LIKE : key)');
            }
           
            if (filters.jobFunctions != null && filters.jobFunctions.size() > 0) {
                jobFunctions = filters.jobFunctions;
                criteria.add('Id IN (SELECT Advancement_Report__c FROM Report_Finder_Job_Function_Filter__c WHERE Job_Function__r.Job_Function_Name__c IN :jobFunctions)');
            }

            if (filters.type != null && filters.type.size() > 0) {
                type = filters.type;
                criteria.add('Type__c = :type');
            }

            // bookmarks only
            if(filters.bookmarksOnly == true){
                criteria.add('Id IN (SELECT Advancement_Report__c FROM Report_Finder_User_Bookmark__c WHERE Bookmarked_By__c = :currentUser)');
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
        

        
        string queryString =    'SELECT Id, Advancement_Report_Name__c,Thumbnail_URL__c, Name, Report_Description__c,Report_Short_Description__c, Type__c, Publish_Status__c, Report_URL__c ' + 
            ',(SELECT Id, Name FROM Report_Finder_User_Bookmarks__r WHERE Bookmarked_By__c = : currentUser) ' + 
            ' FROM Advancement_Report__c ' +
            
            whereClause + 
            ' WITH SECURITY_ENFORCED' +
            ' ORDER BY Advancement_Report_Name__c LIMIT :pageSize OFFSET :offset';

            result.totalItemCount = Database.countQuery('SELECT count() FROM Advancement_Report__c ' + whereClause);

            result.pageNumber = ( result.totalItemCount <= result.pageSize ? 1 : pageNumber);


        
        

        for(Advancement_Report__c advRep : Database.query(queryString)){
            ReportInfo report = new ReportInfo(advRep);
            reports.add(report);

        }

        result.records = reports;
        system.debug('result --> ' + result);
        system.debug('result.totalItemCount --> ' + result.totalItemCount);


        return result;


    



    }



    @AuraEnabled(cacheable=true)
    public static List<String> getJobFunctions() {
        List<String> jobFunctions = new List<String>();
        for(Report_Finder_Job_Function__c jobFunction : [SELECT Job_Function_Name__c FROM Report_Finder_Job_Function__c ORDER BY Job_Function_Name__c ASC]){
            jobFunctions.add(jobFunction.Job_Function_Name__c);
        }
        return jobFunctions;
    }



    @AuraEnabled(cacheable=true)
    public static List<String> getReportTypes() {
        List<String> reportTypes = new List<String>();
        Schema.DescribeFieldResult reportTypeFields = Advancement_Report__c.Type__c.getDescribe();
        for(Schema.PicklistEntry fld : reportTypeFields.getPicklistValues()){
            if(fld.isActive() == true){
                reportTypes.add(fld.getValue());
            }   
        }
        return reportTypes;
    }




}
