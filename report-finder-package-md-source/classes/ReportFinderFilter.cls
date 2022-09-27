/**
* @author Ben Repak u0884669
* @date 2022-September
*
* @description Wrapper class to build soql query within the ReportFinderController class
*/
public with sharing class ReportFinderFilter {
        // search term from input box
        @AuraEnabled
        public String searchKey { get; set; }

        // list of jobs
        @AuraEnabled
        public String[] jobFunctions { get; set; }

        // list of categories
        @AuraEnabled
        public String[] categories { get; set; }

        // list of type values
        @AuraEnabled
        public String[] type { get; set; }

        // flag to include only bookmarked items for current user
        @AuraEnabled
        public Boolean bookmarksOnly { get; set; }

}