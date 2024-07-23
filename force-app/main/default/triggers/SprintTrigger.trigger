trigger SprintTrigger on Sprint__c (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            JiraSprintTriggerHandler.processSprintRecords(Trigger.new);
        }
    }
}