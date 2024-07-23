public class JiraSprintTriggerHandler {
    private static Boolean jiraProcessed = false;
    private static Boolean sprintProcessed = false;
    private static List<Jira__c> jiraRecordsToProcess = new List<Jira__c>();
    private static List<Sprint__c> sprintRecordsToProcess = new List<Sprint__c>();

    public static void processJiraRecords(List<Jira__c> jiraRecords) {
        jiraRecordsToProcess.addAll(jiraRecords);
        jiraProcessed = true;
        createJiraSprintRecords();
    }

    public static void processSprintRecords(List<Sprint__c> sprintRecords) {
        sprintRecordsToProcess.addAll(sprintRecords);
        sprintProcessed = true;
        createJiraSprintRecords();
    }

    private static void createJiraSprintRecords() {
        if (!jiraProcessed || !sprintProcessed) {
            return; // Wait until both Jira and Sprint records are processed
        }

        System.debug('createJiraSprintRecords method called');
        System.debug('Number of Jira records: ' + jiraRecordsToProcess.size());
        System.debug('Number of Sprint records: ' + sprintRecordsToProcess.size());

        Set<String> sprintNames = new Set<String>();
        Map<Id, Jira__c> jiraMap = new Map<Id, Jira__c>();
        Map<Id, List<String>> jiraSprintMap = new Map<Id, List<String>>();

        // Collect all sprint names and map them to Jira records
        for (Jira__c jira : jiraRecordsToProcess) {
            jiraMap.put(jira.Id, jira);
            if (String.isNotBlank(jira.Sprint__c)) {
                List<String> sprints = jira.Sprint__c.split(',');
                for (String sprint : sprints) {
                    sprintNames.add(sprint.trim());
                }
                jiraSprintMap.put(jira.Id, sprints);
            }
        }

        System.debug('Number of unique sprint names: ' + sprintNames.size());
        System.debug('Sprint names: ' + sprintNames);

        // Create a map of Sprint names to Sprint records
        Map<String, Sprint__c> sprintNameToRecordMap = new Map<String, Sprint__c>();
        for (Sprint__c sprint : sprintRecordsToProcess) {
            sprintNameToRecordMap.put(sprint.Name, sprint);
        }

        System.debug('Number of Sprint__c records: ' + sprintNameToRecordMap.size());

        // Create Jira_Sprint__c records
        List<Jira_Sprint__c> jiraSprintsToInsert = new List<Jira_Sprint__c>();

        for (Id jiraId : jiraSprintMap.keySet()) {
            Jira__c jira = jiraMap.get(jiraId);
            for (String sprintName : jiraSprintMap.get(jiraId)) {
                String trimmedSprintName = sprintName.trim();
                if (sprintNameToRecordMap.containsKey(trimmedSprintName)) {
                    Sprint__c sprint = sprintNameToRecordMap.get(trimmedSprintName);
                    Jira_Sprint__c jiraSprint = new Jira_Sprint__c(
                        Name = jira.Name + '-' + sprint.Name,
                        Sprint__c = sprint.Id,
                        Jira__c = jiraId
                    );
                    jiraSprintsToInsert.add(jiraSprint);
                }
            }
        }

        System.debug('Number of Jira_Sprint__c records to insert: ' + jiraSprintsToInsert.size());

        // Insert Jira_Sprint__c records
        if (!jiraSprintsToInsert.isEmpty()) {
            try {
                Database.insert(jiraSprintsToInsert,false);
                System.debug('Successfully inserted Jira_Sprint__c records');
            } catch (Exception e) {
                System.debug('Error inserting Jira_Sprint__c records: ' + e.getMessage());
                // Handle the error as needed
            }
        } else {
            System.debug('No Jira_Sprint__c records to insert');
        }

        // Reset the flags and lists for the next execution
        jiraProcessed = false;
        sprintProcessed = false;
        jiraRecordsToProcess.clear();
        sprintRecordsToProcess.clear();
    }
}