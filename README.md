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
sfdx force:user:permset:assign -n Advancement_Report_Finder_App_Manager
```
6. Import sample data to the Advancement_Report__c, Report_Finder_Job_Function__c, and Report_Finder_Job_Function_Filter__c objects:
```
sfdx force:data:tree:import -p ./data/Sample_Data_Import_Plan.json
```
7. Open the org and launch the Sales app:
```
sfdx force:org:open
```

