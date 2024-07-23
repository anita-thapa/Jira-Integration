public class JiraRecordHandler {
    private static final String CUSTOMFIELD_START_DATE = 'customfield_10015';
    private static final String CUSTOMFIELD_PLANNED_END_DATE = 'customfield_10048';
    private static final String CUSTOMFIELD_DUE_DATE = 'duedate';
    private static final String CUSTOMFIELD_SPRINT = 'customfield_10020';
    private static final String CUSTOMFIELD_WORK_PRODUCT_OWNER = 'customfield_10072';
	
    
    public static String deleteJiraRecords(String projectName) {
        try {
            List<Jira__c> jiraRecordsToDelete = [SELECT Id FROM Jira__c WHERE Parent_Project__c = :projectName];
            if (jiraRecordsToDelete.isEmpty()) {
                return 'No records found for the selected project ' + projectName;
            } else {
                delete jiraRecordsToDelete;
                return 'All Jira records from Project ' + projectName + ' have been deleted';
            }
        } catch (Exception e) {
            throw new AuraHandledException('Failed to delete Jira records: ' + e.getMessage());
        }
    }

    public static Map<String, Jira__c> getExistingJiraRecords(Set<String> jiraKeys) {
        Map<String, Jira__c> existingJiraRecords = new Map<String, Jira__c>();
        if (!jiraKeys.isEmpty()) {
            for (Jira__c existingRecord : [SELECT Id, Name, Type__c, Summary__c, Status__c, Reporter__c, Assignee__c, StartDate__c, Expected_Time_Tracking__c, DueDate__c, ParentName__c, Actual_Time_Tracking__c, Current_Sprint__c, WorkProductOwner__c FROM Jira__c WHERE Name IN :jiraKeys]) {
                existingJiraRecords.put(existingRecord.Name, existingRecord);
            }
        }
        return existingJiraRecords;
    }

    
    public static Jira__c createIssueRecord(Map<String, Object> issue, Map<String, Object> fields, String projectName) {
        Jira__c jiraRecord = new Jira__c();
        List<String> sprint = new List<String>();
    
        
        //system.debug(Sprints_ReadyMade);
        jiraRecord.Name = (String) issue.get('key');
        jiraRecord.Type__c = fields != null && fields.containsKey('issuetype') ? (String) ((Map<String, Object>) fields.get('issuetype')).get('name') : null;
        jiraRecord.Summary__c = fields != null && fields.containsKey('summary') ? (String) fields.get('summary') : null;
        jiraRecord.Status__c = fields != null && fields.containsKey('status') ? (String) ((Map<String, Object>) fields.get('status')).get('name') : null;
        jiraRecord.Reporter__c = JiraUtility.getUserByName(fields != null && fields.containsKey('reporter') ? (String) ((Map<String, Object>) fields.get('reporter')).get('displayName') : null);
        jiraRecord.Parent_Project__c = projectName;
        
        if (fields != null && fields.containsKey('assignee') && fields.get('assignee') != null) {
            Map<String, Object> assigneeMap = (Map<String, Object>) fields.get('assignee');
            jiraRecord.Assignee__c = assigneeMap.containsKey('displayName') ? JiraUtility.getUserByName((String) assigneeMap.get('displayName')) : null;
        } else {
            jiraRecord.Assignee__c = null;
        }

        jiraRecord.StartDate__c = fields != null && fields.containsKey(CUSTOMFIELD_START_DATE) ? JiraUtility.parseDate((String) fields.get(CUSTOMFIELD_START_DATE)) : Date.today();
        jiraRecord.DueDate__c = fields != null && fields.containsKey(CUSTOMFIELD_DUE_DATE) ? JiraUtility.parseDate((String) fields.get(CUSTOMFIELD_DUE_DATE)) : Date.today();
        
        Integer timeSpentSeconds = fields != null && fields.containsKey('timespent') ? (Integer) fields.get('timespent') : null;
        jiraRecord.Expected_Time_Tracking__c = timeSpentSeconds != null ? JiraUtility.convertSecondsToDHMS(timeSpentSeconds) : null;

        jiraRecord.ParentName__c = fields != null && fields.containsKey('parent') ? (String) ((Map<String, Object>) fields.get('parent')).get('key') : null;
        Integer timeOriginalEstimateSeconds = fields != null && fields.containsKey('timeoriginalestimate') ? (Integer) fields.get('timeoriginalestimate') : null;
        jiraRecord.Actual_Time_Tracking__c = timeOriginalEstimateSeconds != null ? JiraUtility.convertSecondsToDHMS(timeOriginalEstimateSeconds) : null;

        if (fields != null && fields.containsKey(CUSTOMFIELD_SPRINT) && fields.get(CUSTOMFIELD_SPRINT) != null) {
            List<Object> sprints = (List<Object>) fields.get(CUSTOMFIELD_SPRINT);    
            
            for (Object s : sprints) {
                Map<String, Object> sp = (Map<String, Object>) s;
                String st = (String) sp.get('name');
                sprint.add((String) sp.get('name'));
                if(!JiraRestClient.Sprints_Name.contains((String) sp.get('name'))){
                    JiraRestClient.Sprints_Name.add((String) sp.get('name'));
               }
			
            }
            jiraRecord.Sprint__c = String.join(sprint, ', ');

            Map<String, Object> currentSprintMap = (Map<String, Object>) sprints[sprints.size() - 1]; 
            if ((String) currentSprintMap.get('state') == 'active') {
                jiraRecord.Current_Sprint__c = (String) currentSprintMap.get('name');
            }	
        } else {
            jiraRecord.Sprint__c = null;
        }

        if (fields != null && fields.containsKey(CUSTOMFIELD_WORK_PRODUCT_OWNER) && fields.get(CUSTOMFIELD_WORK_PRODUCT_OWNER) != null) {
            List<Object> WORK_PRODUCT_OWNER_LIST = (List<Object>) fields.get(CUSTOMFIELD_WORK_PRODUCT_OWNER);
            Map<String, Object> WORK_PRODUCT_OWNER = (Map<String, Object>) WORK_PRODUCT_OWNER_LIST[0];   
            jiraRecord.WorkProductOwner__c = JiraUtility.getUserByName((String) WORK_PRODUCT_OWNER.get('displayName'));
        } else {
            jiraRecord.WorkProductOwner__c = JiraUtility.getUserByName(null);
        }
        
        return jiraRecord;
    }

    public static Boolean hasChanges(Jira__c existingRecord, Jira__c newRecord) {
        return existingRecord.Type__c != newRecord.Type__c ||
               existingRecord.Summary__c != newRecord.Summary__c ||
               existingRecord.Status__c != newRecord.Status__c ||
               existingRecord.Reporter__c != newRecord.Reporter__c ||
               existingRecord.Assignee__c != newRecord.Assignee__c ||
               existingRecord.StartDate__c != newRecord.StartDate__c ||
               existingRecord.Expected_Time_Tracking__c != newRecord.Expected_Time_Tracking__c ||
               existingRecord.DueDate__c != newRecord.DueDate__c ||
               existingRecord.ParentName__c != newRecord.ParentName__c ||
               existingRecord.Actual_Time_Tracking__c != newRecord.Actual_Time_Tracking__c ||
        	   existingRecord.WorkProductOwner__c != newRecord.WorkProductOwner__c ||
               existingRecord.Current_Sprint__c != newRecord.Current_Sprint__c;
    }

    public static void upsertJiraRecords(List<Jira__c> jiraRecordsToUpdate, List<Jira__c> jiraRecordsToInsert, Map<String, Integer> result) {
        Integer successCount = result.get('successCount');
        Integer failedCount = result.get('failedCount');

        if (!jiraRecordsToUpdate.isEmpty()) {
            Database.SaveResult[] updateResults = Database.update(jiraRecordsToUpdate, false);

            for (Database.SaveResult sr : updateResults) {
                if (!sr.isSuccess()) {
                    failedCount++;
                    for (Database.Error err : sr.getErrors()) {
                        System.debug('Error updating Jira record: ' + err.getStatusCode() + ' - ' + err.getMessage());
                    }
                } else {
                    successCount++;
                }
            }
        }

        if (!jiraRecordsToInsert.isEmpty()) {
            Database.SaveResult[] insertResults = Database.insert(jiraRecordsToInsert, false);

            for (Database.SaveResult sr : insertResults) {
                if (!sr.isSuccess()) {
                    failedCount++;
                    for (Database.Error err : sr.getErrors()) {
                        System.debug('Error inserting Jira record: ' + err.getStatusCode() + ' - ' + err.getMessage());
                    }
                } else {
                    successCount++;
                }
            }
        }

        result.put('successCount', successCount);
        result.put('failedCount', failedCount);
    }
}