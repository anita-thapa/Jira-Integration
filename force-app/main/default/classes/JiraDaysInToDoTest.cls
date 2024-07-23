@isTest
public class JiraDaysInToDoTest {
    @isTest
    /*
     * @description: Verify that the 'Days in To Do' field correctly counts the days when the status is 'To Do'
     */
    static void testDaysInToDo() {
        User testUser1 = [SELECT Id FROM User WHERE Username = 'helloooosregmi48@gmail.com' LIMIT 1];
        User testUser2 = [SELECT Id FROM User WHERE Username = 'aneitathapa28@mindful-otter-400oh5.com' LIMIT 1];
        
        Jira__c toDoRecord = new Jira__c(
            StartDate__c = Date.newInstance(2024, 2, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'To Do',
            Type__c = 'Epic'
        );

        insert toDoRecord;
        Test.setCreatedDate(toDoRecord.Id, DateTime.now().addDays(-3));
        
        Test.startTest();
        toDoRecord = [SELECT Id, Days_In_To_Do__c FROM Jira__c WHERE Id = :toDoRecord.Id];
        Test.stopTest();
        
        System.assertEquals(3, toDoRecord.Days_In_To_Do__c);
    }
}