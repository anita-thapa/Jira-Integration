public class JiraService {
    private static final String ENDPOINT_URL = 'callout:JiraAuth/rest/api/3/search?jql=';

    public static HttpResponse sendHttpRequest(String projectAddress) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(ENDPOINT_URL + projectAddress);
        req.setMethod('GET');

        Http http = new Http();
        try {
            return http.send(req);
        } catch (Exception e) {
            System.debug('HTTP Request failed: ' + e.getMessage());
            return null;
        }
    }

    public static void processIssues(String responseBody, Map<String, Integer> result, String projectName) {
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
        List<Object> issuesList = (List<Object>) jsonMap.get('issues');
        List<Jira__c> jiraRecordsToUpdate = new List<Jira__c>();
        List<Jira__c> jiraRecordsToInsert = new List<Jira__c>();

        Set<String> jiraKeys = new Set<String>();
        for (Object issueObj : issuesList) {
            Map<String, Object> issue = (Map<String, Object>) issueObj;
            jiraKeys.add((String) issue.get('key'));
        }

        Map<String, Jira__c> existingJiraRecords = JiraRecordHandler.getExistingJiraRecords(jiraKeys);

        for (Object issueObj : issuesList) {
            Map<String, Object> issue = (Map<String, Object>) issueObj;
            Map<String, Object> fields = (Map<String, Object>) issue.get('fields');
            Jira__c newJiraRecord = JiraRecordHandler.createIssueRecord(issue, fields, projectName);

            if (existingJiraRecords.containsKey(newJiraRecord.Name)) {
                Jira__c existingRecord = existingJiraRecords.get(newJiraRecord.Name);
                if (JiraRecordHandler.hasChanges(existingRecord, newJiraRecord)) {
                    newJiraRecord.Id = existingRecord.Id;
                    jiraRecordsToUpdate.add(newJiraRecord);
                }
            } else {
                jiraRecordsToInsert.add(newJiraRecord);
            }
        }

        JiraRecordHandler.upsertJiraRecords(jiraRecordsToUpdate, jiraRecordsToInsert, result);
    }
}