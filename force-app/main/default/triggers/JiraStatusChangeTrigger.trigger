trigger JiraStatusChangeTrigger on Jira__c (before insert, before update ) {
    for (Jira__c jira:Trigger.new){
        if (jira.Status__c=='To Do' && (jira.Last_To_Do_Date__c==NULL||jira.Status__c!=Trigger.oldMap.get(jira.Id).Status__c)){
            jira.Last_To_Do_Date__c=Date.today();
        }else if (jira.Status__c=='In Progress' && (jira.Last_In_Progress_Date__c==NULL||jira.Status__c!=Trigger.oldMap.get(jira.Id).Status__c)){
            jira.Last_In_Progress_Date__c=Date.today();
        }else if (jira.Status__c=='In QC' && (jira.Last_In_QC_Date__c==NULL||jira.Status__c!=Trigger.oldMap.get(jira.Id).Status__c)){
            jira.Last_In_QC_Date__c=Date.today();
        }
    }
}