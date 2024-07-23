@isTest
public class InQCStatusCountTest {
    @isTest
    /**
     * @description: create a new record with 'In QC' as its status, changed to 'In Progress' and back to 'In QC'; checking for increment of In_QC_Status_Count__c
     * @author: Diya Shrestha
     */
    static void testInQCStatusCountIncrement() {
        User  testUser1 = [SELECT Id FROM User WHERE Username = 'helloooosregmi48@gmail.com' LIMIT 1];
        User  testUser2 = [SELECT Id FROM User WHERE Username = 'aneitathapa28@mindful-otter-400oh5.com' LIMIT 1];
        
        Jira__c inqc = new Jira__c(
            StartDate__c = Date.newInstance(2024, 02, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'In QC',
            Type__c = 'Epic',
            To_Do_Status_Count__c = 0,
            In_Progress_Status_Count__c = 0,
            In_QC_Status_Count__c = 0,
            Done_Status_Count__c = 0
        );
        insert inqc;
        
        inqc = [SELECT Id, In_QC_Status_Count__c FROM Jira__c WHERE Id = :inqc.Id];
        System.assertEquals(1, inqc.In_QC_Status_Count__c, 'InQCStatusCount should be initialized to 1');
        
        inqc.Status__c = 'In Progress';
        inqc.DueDate__c = Date.newInstance(2023, 04, 12);
        update inqc;
        
       	inqc = [SELECT Id, In_QC_Status_Count__c FROM Jira__c WHERE Id = :inqc.Id];
        System.assertEquals(1, inqc.In_QC_Status_Count__c, 'InQCStatusCount should remain 1');
        
        inqc.Status__c = 'In QC';
        update inqc;
        
        inqc = [SELECT Id, In_QC_Status_Count__c FROM Jira__c WHERE Id = :inqc.Id];
        System.assertEquals(2, inqc.In_QC_Status_Count__c, 'InQCStatusCount should be incremented to 2');
    }
}