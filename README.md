# Report Finder Tool

A tool to help filter for useful reports within the Advancement office. 

## Installation Instructions
1. Authenticate with dev hub:
```
sfdx auth:web:login -d -a myhuborg
```
2. Clone this repo:
```
git clone https://github.com/BenRepak/sf-report-finder-tool
cd sf-report-finder-tool
```
3. Create a scratch org and set an alias: 
```
sfdx force:org:create -s -f config/project-scratch-def.json -a report-finder
```
4. Push source code to the scratch org:
```
sfdx force:source:push
```
5. Assign the app manager permission set to the default user:
```
sfdx force:user:permset:assign -n Report_Finder_App_Manager
```
6. Import sample data to the Advancement_Report__c, Report_Finder_Job_Function__c, and Report_Finder_Job_Function_Filter__c objects:
```
sfdx force:data:tree:import -p ./data/Sample_Data_Import_Plan.json
```
7. Open the org and launch the default org:
```
sfdx force:org:open
```
8. Once the oefault org is open in your browser, use the App Launcher to open the **Report Finder App**
<img src="documentation-assets\launch_report_finder_app.png" alt="open the Report Finder App from App Launcher" title="Report Finder App" />



## Granting User Access
### App User Access
To grant access to App users, grant access using the **Report Finder** App User permission set.

### App Manager Access
To grant access to App managers (aka Admins or Super users), grant access using the **Report Finder App Manager** permission set. This will grant **Modify All** rights to the following objects:
- Report_Finder_Category__c
- Report_Finder_Category_Filter__c
- Report_Finder_Item__c
- Report_Finder_Item_Usage__c
- Report_Finder_Job_Function__c
- Report_Finder_Job_Function_Filter__c
- Report_Finder_User_Bookmark__c

## Sharing Model
All objects are defaulted to Public Read or Controlled by Parent.

## App Metadata
The following describe the most important metadata items within the Report Finder App.

### Object Definitions 
Object API Name | Object Usage
----------------|----------------
Report_Finder_Category__c | Used for classifying / tagging Report Finder Items.
Report_Finder_Category_Filter__c | Junction object between Report_Finder_Category__c and Report_Finder_Item__c.
Report_Finder_Item__c | Main object of the app to hold descriptive information about the report items.
Report_Finder_Item_Usage__c | Logs when Users launch an Access URL from a Report Finder Item. Junction object between Report_Finder_Item__c and User.
Report_Finder_Job_Function__c | Used for classifying / tagging Report Finder Items by end-user job type (e.g. Accountant, Sales Manager, etc). Is not tied to Profiles or User Roles. 
Report_Finder_Job_Function_Filter__c | Junction object between Report_Finder_Job_Function__c and Report_Finder_Item_Usage__c.
Report_Finder_User_Bookmark__c | Used to bookmark Report Finder Item records for end-users. Junction object between Report_Finder_Item__c and User.

### Lightning Web Components  
LWC Name | LWC Purpose
----------------|----------------
reportFinderBookmarker | Enables users to flag Report Finder Items as bookmarks for easier filtering
reportFinderContainer | main LWC to hold other LWCs for this app
reportFinderDatatable | currently not in use
reportFinderFilters| Used to drill down the displayed Report Finder Items
reportFinderList | Holds Report Finder Items returned from search
reportFinderListItemCard | Holds a single Report Finder Item in the reportFinderList lwc
reportFinderListeItemThumbnail | Displays the styled thumbnail for the Report Finder Item in the reportFinderListItemCard and reportFinderThumbnailLoader lwcs
reportFinderPaginator | Allows users to view additional results when searching for Report Finder Items 
reportFinderSelectedItemModal | A pop-up modal that displays additional detail about Report Finder Items and enables bookmarking and opening of the items 
reportFinderThumbnailLoader | Used on the Report Finder Item lightning record page to upload thumbnails to the record

<img src="documentation-assets\report_finder_lwcs_diagram.png" alt="diagram of lwcs in report finder app" title="Report Finder App LWC Diagram" />


### Apex Classes 
Class Name | Class Purpose
----------------|----------------
PagedResult | Custom class to define seach resulsts 
ReportBookMarkController | Updates bookmarks from action on the reportFinderBookmarker lwc
ReportFinderController | Main controller for the app to control searching
ReportFinderFilter | Custom class to define filter settings
ReportFinderFilterController | Retreives filter values to be displayed in the reportFinderFilters lwc
ReportFinderUsageController | Logs report usage when a report is opened from the reportFinderSelectedItemModal lwc
ReportThumbnailController | Updates the Report Finder Item thumbnail from the reportFinderThumbnailLoader lwc

### Dashboard
Pending

### Reports
Pending
