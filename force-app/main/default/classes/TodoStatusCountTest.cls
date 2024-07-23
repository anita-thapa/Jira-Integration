@isTest
public class TodoStatusCountTest {
    @isTest
    /**
     * @description: create a new record with 'To Do' as its status, changed to 'In Progress' and back to 'To Do'; checking for increment of To_Do_Status_Count__c
     * @author: Diya Shrestha
     */
    static void testTodoStatusCountIncrement() {
        User  testUser1 = [SELECT Id FROM User WHERE Username = 'helloooosregmi48@gmail.com' LIMIT 1];
        User  testUser2 = [SELECT Id FROM User WHERE Username = 'aneitathapa28@mindful-otter-400oh5.com' LIMIT 1];
        
        Jira__c todo = new Jira__c(
            StartDate__c = Date.newInstance(2024, 02, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'To Do',
            Type__c = 'Epic',
            To_Do_Status_Count__c = 0,
            In_Progress_Status_Count__c = 0,
            In_QC_Status_Count__c = 0,
            Done_Status_Count__c =0
        );
        insert todo;
        
        todo = [SELECT Id, To_Do_Status_Count__c FROM Jira__c WHERE Id = :todo.Id];
        System.assertEquals(1, todo.To_Do_Status_Count__c, 'TodoStatusCount should be initialized to 1');
        
        todo.Status__c = 'In Progress';
        todo.DueDate__c = Date.newInstance(2024, 03, 12);
        update todo;
        
        todo = [SELECT Id, To_Do_Status_Count__c FROM Jira__c WHERE Id = :todo.Id];
        System.assertEquals(1, todo.To_Do_Status_Count__c, 'TodoStatusCount should remain 1');
        
        todo.Status__c = 'To Do';
        update todo;
        
        todo = [SELECT Id, To_Do_Status_Count__c FROM Jira__c WHERE Id = :todo.Id];
        System.assertEquals(2, todo.To_Do_Status_Count__c, 'TodoStatusCount should be incremented to 2');
    }
}