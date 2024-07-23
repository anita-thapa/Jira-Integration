public class JiraRestClient {
    
    private static String PROJECT_NAME = '';
	public static list<String> Sprints_Name = new list<String>();
    public static list<Sprint__c> Sprints_list = new list<Sprint__c>();
    
    
    @AuraEnabled
    public static String deleteJiraRecords(String projectName) {
        return JiraRecordHandler.deleteJiraRecords(projectName);
    }
    
  	public static void createUniqueSprints() {
        if (!Sprints_Name.isEmpty()) {
            // Query existing sprints with the same names
            Map<String, Sprint__c> existingSprintsMap = new Map<String, Sprint__c>();
            for (Sprint__c existingSprint : [SELECT Name FROM Sprint__c WHERE Name IN :Sprints_Name]) {
                existingSprintsMap.put(existingSprint.Name, existingSprint);
            }

            List<Sprint__c> sprintsToInsert = new List<Sprint__c>();

            for (String sprintName : Sprints_Name) {
                if (!existingSprintsMap.containsKey(sprintName)) {
                    Sprint__c newSprint = new Sprint__c(Name = sprintName);
                    sprintsToInsert.add(newSprint);
                }
            }

            if (!sprintsToInsert.isEmpty()) {
                insert sprintsToInsert;
            }
        }
    }
    
    
    @AuraEnabled
    public static Map<String, Integer> performHttpRequestWithNamedCredential(String selectedValues) {
        PROJECT_NAME = selectedValues;
        HttpResponse res;
        String responseBody = '';
        List<String> projectData;
        Map<String, Integer> result = new Map<String, Integer>();
        result.put('successCount', 0);
        result.put('failedCount', 0);
		
        // Retrieve project details
        List<Map<String, Map<String, String>>> projectMapList = GetProjectDetails.getProjectName();
        String selectedProjectAddress = JiraUtility.getSelectedProjectAddress(projectMapList, selectedValues);

        if (selectedProjectAddress != null) {
            res = JiraService.sendHttpRequest(selectedProjectAddress);

            if (res != null && res.getStatusCode() == 200) {
                responseBody = res.getBody();
                JiraService.processIssues(responseBody, result, PROJECT_NAME);
                createUniqueSprints();
            } else {
                System.debug('Error: ' + res.getStatusCode() + ' ' + res.getStatus());
            }
        } else {
            System.debug('Selected project not found');
        }

        Project_Schedule__c p = new Project_Schedule__c();
        p.Name = selectedValues;
        insert p;
		
		return result;
    }
}