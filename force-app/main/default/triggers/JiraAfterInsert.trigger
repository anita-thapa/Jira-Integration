trigger JiraAfterInsert on Jira__c (after insert) {
    // Step 1: Collect parent names from the newly inserted Jira records
    Set<String> parentNames = new Set<String>();
    for (Jira__c jiraRecord : Trigger.new) {
        if (jiraRecord.ParentName__c != null) {
            parentNames.add(jiraRecord.ParentName__c);
        }
    }

    // Step 2: If there are any parent names, proceed to find corresponding parent records
    if (!parentNames.isEmpty()) {
        // Query to get the parent records that match the parent names and are of type 'Epic'
        Map<String, Id> parentNameToIdMap = new Map<String, Id>();
        for (Jira__c parentRecord : [
            SELECT Id, Name 
            FROM Jira__c 
            WHERE Name IN :parentNames AND Type__c = 'Epic'
        ]) {
            parentNameToIdMap.put(parentRecord.Name, parentRecord.Id);
        }

        // Step 3: Create a list of Jira records to update
        List<Jira__c> recordsToUpdate = new List<Jira__c>();
        for (Jira__c jiraRecord : Trigger.new) {
            if (jiraRecord.ParentName__c != null && parentNameToIdMap.containsKey(jiraRecord.ParentName__c)) {
                // Create a new instance of Jira__c and set the Id and the Related_Item__c field
                Jira__c recordToUpdate = new Jira__c(
                    Id = jiraRecord.Id, 
                    Related_Item__c = parentNameToIdMap.get(jiraRecord.ParentName__c)
                );
                recordsToUpdate.add(recordToUpdate);
            }
        }

        // Step 4: Perform the update DML operation
        if (!recordsToUpdate.isEmpty()) {
            try {
                update recordsToUpdate;
            } catch (DmlException e) {
                System.debug('Error updating Jira records: ' + e.getMessage());
            }
        }
    }
}