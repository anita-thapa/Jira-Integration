public class UpdateJiraDaysScheduled implements Schedulable {
    public void execute(SchedulableContext sc) {
        List<Jira__c> jiraList = [SELECT Id, Status__c, Last_To_Do_Date__c, Last_In_Progress_Date__c, Last_In_QC_Date__c, Last_Done_Date__c,
                                         Days_In_To_Do__c, Days_In_InProgress__c, Days_In_InQC__c, Days_In_Done__c
                                    FROM Jira__c];
        
        List<Jira__c> jiraToUpdate = new List<Jira__c>();
        
        for (Jira__c jira : jiraList) {
            if (jira.Status__c == 'To Do' && jira.Last_To_Do_Date__c != null) {
                jira.Days_In_To_Do__c = (Integer)(jira.Last_To_Do_Date__c.daysBetween(Date.today()));
            } else if (jira.Status__c == 'In Progress' && jira.Last_In_Progress_Date__c != null) {
                jira.Days_In_InProgress__c = (Integer)(jira.Last_In_Progress_Date__c.daysBetween(Date.today()));
            } else if (jira.Status__c == 'In QC' && jira.Last_In_QC_Date__c != null) {
                jira.Days_In_InQC__c = (Integer)(jira.Last_In_QC_Date__c.daysBetween(Date.today()));
            } 
            
            jiraToUpdate.add(jira);
        }
        
        if (!jiraToUpdate.isEmpty()) {
            update jiraToUpdate;
        }
    }
}