/**
* @author Ben Repak u0884669
* @date 2022-September
*
* @description Wrapper class to return a paginated list of results of Report Finder Items.
*/
public with sharing class PagedResult {
    // number of records per page
    @AuraEnabled
    public Integer pageSize { get; set; }

    // current page
    @AuraEnabled
    public Integer pageNumber { get; set; }

    // total items returned
    @AuraEnabled
    public Integer totalItemCount { get; set; }

    // search results returned
    @AuraEnabled
    public Object[] records { get; set; }
}