public with sharing class ReportFinderFilterController {
   

    @AuraEnabled(cacheable=true)
    public static List<String> getJobFunctions() {
        List<String> jobFunctions = new List<String>();
        for(Report_Finder_Job_Function__c jobFunction : [SELECT Job_Function_Name__c FROM Report_Finder_Job_Function__c WHERE Is_Active__c = TRUE ORDER BY Job_Function_Name__c ASC]){
            jobFunctions.add(jobFunction.Job_Function_Name__c);
        }
        return jobFunctions;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getCategories() {
        List<String> categories = new List<String>();
        for(Report_Finder_Category__c category : [SELECT Category_Name__c FROM Report_Finder_Category__c WHERE Is_Active__c = TRUE ORDER BY Category_Name__c ASC]){
            categories.add(category.Category_Name__c);
        }
        return categories;
    }



    @AuraEnabled(cacheable=true)
    public static List<String> getReportTypes() {
        List<String> reportTypes = new List<String>();
        Schema.DescribeFieldResult reportTypeFields = Report_Finder_Item__c.Type__c.getDescribe();
        for(Schema.PicklistEntry fld : reportTypeFields.getPicklistValues()){
            if(fld.isActive() == true){
                reportTypes.add(fld.getValue());
            }   
        }
        return reportTypes;
    }

}