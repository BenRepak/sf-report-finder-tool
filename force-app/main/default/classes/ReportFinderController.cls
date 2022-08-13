public with sharing class ReportFinderController {
    
    static Integer PAGE_SIZE = 9;

    public class Filters {
        @AuraEnabled
        public String searchKey { get; set; }
        @AuraEnabled
        public String[] jobFunctions { get; set; }
        @AuraEnabled
        public String type { get; set; }
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

    }

    @AuraEnabled
    public static PagedResult refreshReports(Filters filters, Integer pageNumber) {
        return getReports(filters, pageNumber);
    }


    @AuraEnabled(cacheable=true)
    public static PagedResult getReports(Filters filters, Integer pageNumber) {
        //https://github.com/trailheadapps/ebikes-lwc/blob/main/force-app/main/default/classes/ProductController.cls

        List<ReportInfo> reports = new List<ReportInfo>();
        String key, type, whereClause = '';
        String[] jobFunctions, criteria = new List<String>{};
        Id currentUser = UserInfo.getUserId();
        if (filters != null) {
            if (!String.isEmpty(filters.searchKey)) {
                key = '%' + filters.searchKey + '%';
                criteria.add('Advancement_Report_Name__c LIKE :key');
            }
           
            if (filters.jobFunctions != null && filters.jobFunctions.size() > 0) {
                jobFunctions = filters.jobFunctions;
                criteria.add('Id IN (SELECT Advancement_Report__c FROM Report_Finder_Job_Function_Filter__c WHERE Job_Function__c.Job_Function_Name__c IN :jobFunctions)');
            }

            // bookmarks only
            if(filters.bookmarksOnly == true){
                criteria.add('Id IN (SELECT Advancement_Report__c FROM Report_Finder_User_Bookmark__c WHERE Bookmarked_By__c = :currentUser)');
            }

           
            // if (filters.type != null) {
            //     type = filters.type;
            //     criteria.add('Type__c IN :materials');
            // }
            if (criteria.size() > 0) {
                criteria.add('Publish_Status__c != \'Not Published\' AND Publish_Status__c != \'\'');
                whereClause = 'WHERE ' + String.join(criteria, ' AND ');
            }
        }

        Integer pageSize = ReportFinderController.PAGE_SIZE;
        Integer offset = (pageNumber - 1) * pageSize;
        PagedResult result = new PagedResult();
        result.pageSize = pageSize;
        result.pageNumber = pageNumber;

        
        string queryString =    'SELECT Id, Advancement_Report_Name__c,Thumbnail_URL__c, Name, Report_Description__c,Report_Short_Description__c, Type__c, Publish_Status__c, Report_URL__c ' + 
            ',(SELECT Id, Name FROM Report_Finder_User_Bookmarks__r WHERE Bookmarked_By__c = : currentUser) ' + 
            ' FROM Advancement_Report__c ' +
            
            whereClause + 
            ' WITH SECURITY_ENFORCED' +
            ' ORDER BY Name LIMIT :pageSize OFFSET :offset';
        

        for(Advancement_Report__c advRep : Database.query(queryString)){
            ReportInfo report = new ReportInfo();
            report.id = advRep.Id;
            report.name = advRep.Advancement_Report_Name__c;
            report.thumbnail = advRep.Thumbnail_URL__c;
            report.longDescription = advRep.Report_Description__c;
            report.shortDescription = advRep.Report_Short_Description__c;
            report.type = advRep.Type__c;
            report.isBookmarked = (advRep.Report_Finder_User_Bookmarks__r.size() > 0)? true : false;
            report.accessUrl = advRep.Report_URL__c;

            reports.add(report);

        }

        result.records = reports;

        result.totalItemCount = result.records.size();

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




}
