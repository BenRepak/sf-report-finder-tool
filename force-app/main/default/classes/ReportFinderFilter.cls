public with sharing class ReportFinderFilter {
        @AuraEnabled
        public String searchKey { get; set; }
        @AuraEnabled
        public String[] jobFunctions { get; set; }
        @AuraEnabled
        public String[] categories { get; set; }
        @AuraEnabled
        public String[] type { get; set; }
        @AuraEnabled
        public Boolean bookmarksOnly { get; set; }

}
