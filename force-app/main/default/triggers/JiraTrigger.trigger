trigger JiraTrigger on Jira__c (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            JiraSprintTriggerHandler.processJiraRecords(Trigger.new);
        }
    }
}