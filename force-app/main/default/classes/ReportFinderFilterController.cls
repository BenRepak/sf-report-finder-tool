/**
* @author Ben Repak u0884669
* @date 2022-September
*
* @description Controller used in the Report Finder App to retreive data for the filters lwc
*/

public with sharing class ReportFinderFilterController {
   
    /*******************************************************************************************************
    * @description Retreives Report_Finder_Job_Function__c records to build a list of filter items 
    * @return a list of active job function names from the Report_Finder_Job_Function__c object that have a published report associated
    */
    @AuraEnabled(cacheable=true)
    public static List<String> getJobFunctions() {
        List<String> jobFunctions = new List<String>();
        // for(Report_Finder_Job_Function__c jobFunction : [SELECT Job_Function_Name__c FROM Report_Finder_Job_Function__c WHERE Is_Active__c = TRUE ORDER BY Job_Function_Name__c ASC]){
        for(Report_Finder_Job_Function__c jobFunction : [SELECT Job_Function_Name__c FROM Report_Finder_Job_Function__c WHERE Is_Active__c = TRUE AND Id IN (SELECT Job_Function__c FROM Report_Finder_Job_Function_Filter__c WHERE Report_Finder_Item__R.Publish_Status__c = 'Published') ORDER BY Job_Function_Name__c ASC]){
            jobFunctions.add(jobFunction.Job_Function_Name__c);
        }
        return jobFunctions;
    }

    /*******************************************************************************************************
    * @description Retreives Report_Finder_Category__c records to build a list of filter items 
    * @return a list of active category names from the Report_Finder_Category__c object that have a published report associated
    */
    @AuraEnabled(cacheable=true)
    public static List<String> getCategories() {
        List<String> categories = new List<String>();
        // for(Report_Finder_Category__c category : [SELECT Category_Name__c FROM Report_Finder_Category__c WHERE Is_Active__c = TRUE ORDER BY Category_Name__c ASC]){
        for(Report_Finder_Category__c category : [SELECT Category_Name__c FROM Report_Finder_Category__c WHERE Is_Active__c = TRUE AND Id IN (SELECT Report_Finder_Category__c FROM Report_Finder_Category_Filter__c WHERE Report_Finder_Item__R.Publish_Status__c = 'Published') ORDER BY Category_Name__c ASC]){
            categories.add(category.Category_Name__c);
        }
        return categories;
    }

    /*******************************************************************************************************
    * @description Retreives active picklist values from the Report_Finder_Item__c.Type__c field to build a list of filter items 
    * @return a list of active Report_Finder_Item__c.Type__c values from the Report_Finder_Item__c object
    */
    @AuraEnabled(cacheable=true)
    public static List<String> getReportTypes() {
        List<String> reportTypes = new List<String>();
        Schema.DescribeFieldResult reportTypeFields = Report_Finder_Item__c.Type__c.getDescribe();
            for(Schema.PicklistEntry fld : reportTypeFields.getPicklistValues()){
                if(fld.isActive() == true){
                    reportTypes.add(fld.getValue());
                }   
            }


        /* if desired to only show values for active reports, implement the following. the tradeoff is slower load time
        // try to only retrieve Type__c values associated with published reports to limit the filter values
        try{
            system.debug('try');
            AggregateResult[] groupedResults = [SELECT Type__c FROM Report_Finder_Item__c WHERE Publish_Status__c = 'Published' GROUP BY type__c ORDER BY Type__c ];
            for (AggregateResult ar : groupedResults)  {
                reportTypes.add((string)ar.get('Type__c'));
            }
        // handle any errors, and then just result to getting active picklist values and displaying them
        } Catch(exception e){
            System.debug('catch error --> ' + e);
            Schema.DescribeFieldResult reportTypeFields = Report_Finder_Item__c.Type__c.getDescribe();
            for(Schema.PicklistEntry fld : reportTypeFields.getPicklistValues()){
                if(fld.isActive() == true){
                    reportTypes.add(fld.getValue());
                }   
            }
        // if there are no records found just set the return to null, which should hide the filter component entirely
        } finally{
            system.debug('finally');
            if(reportTypes.size() == 0) {
                reportTypes = null;
            }
        }
        */
        
        return reportTypes;

    }


}