@isTest
public class InProgressStatusCountTest {
    @isTest
    /**
     * @description: create a new record with 'In Progress' as its status, changed to 'In QC' and back to 'In Progress'; checking for increment of In_Progress_Status_Count__c
     * @author: Diya Shrestha
     */
    static void testInProgressStatusCountIncrement() {
        User  testUser1 = [SELECT Id FROM User WHERE Username = 'helloooosregmi48@gmail.com' LIMIT 1];
        User  testUser2 = [SELECT Id FROM User WHERE Username = 'aneitathapa28@mindful-otter-400oh5.com' LIMIT 1];
        
        Jira__c inprogress = new Jira__c(
            StartDate__c = Date.newInstance(2024, 02, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'In Progress',
            Type__c = 'Epic',
            DueDate__c = Date.newInstance(2024, 04, 15),
            To_Do_Status_Count__c = 0,
            In_Progress_Status_Count__c = 0,
            In_QC_Status_Count__c = 0,
            Done_Status_Count__c =0
        );
        insert inprogress;
        
        inprogress = [SELECT Id, In_Progress_Status_Count__c FROM Jira__c WHERE Id = :inprogress.Id];
        System.assertEquals(1, inprogress.In_Progress_Status_Count__c, 'InProgressStatusCount should be initialized to 1');
        
        inprogress.Status__c = 'In QC';
        update inprogress;
        
       	inprogress = [SELECT Id, In_Progress_Status_Count__c FROM Jira__c WHERE Id = :inprogress.Id];
        System.assertEquals(1, inprogress.In_Progress_Status_Count__c, 'InProgressStatusCount should remain 1');
        
        inprogress.Status__c = 'In Progress';
        update inprogress;
        
        inprogress = [SELECT Id, In_Progress_Status_Count__c FROM Jira__c WHERE Id = :inprogress.Id];
        System.assertEquals(2, inprogress.In_Progress_Status_Count__c, 'InProgressStatusCount should be incremented to 2');
    }
}