@isTest
public class FromToDoShiftTest {
    @isTest
    /*
     * @description: Create a new record with 'To Do' as its status; change to 'In Progress', 'In QC', and 'Done'
     * @author: Diya Shrestha
     */
    static void testToDoShifting() {
        User testUser1 = [SELECT Id FROM User WHERE Username = 'helloooosregmi48@gmail.com' LIMIT 1];
        User testUser2 = [SELECT Id FROM User WHERE Username = 'aneitathapa28@mindful-otter-400oh5.com' LIMIT 1];

        /*
         * @description: Create records in 'To Do' status
         */
        Jira__c intodo1 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 2, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'To Do',
            Type__c = 'Epic'
        );

        Jira__c intodo2 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 2, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'To Do',
            Type__c = 'Epic'
        );

        Jira__c intodo3 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 2, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'To Do',
            Type__c = 'Epic'
        );

        insert new List<Jira__c> { intodo1, intodo2, intodo3 };

        /*
         * @description: Update the statuses
         */
        intodo1.Status__c = 'In Progress';
        intodo1.DueDate__c = Date.newInstance(2023, 4, 12);

        intodo2.Status__c = 'In QC';
        
        intodo3.Status__c = 'Done';

        Test.startTest();
        Database.SaveResult result1 = Database.update(intodo1, false);
        List<Database.SaveResult> results = Database.update(new List<Jira__c> { intodo2, intodo3 }, false);
        Test.stopTest();

        System.assert(result1.isSuccess());

        for (Database.SaveResult result : results) {
            System.assertEquals('Cannot update the &quot;Status&quot; value from &quot;To Do&quot; to &quot;In QC&quot; or &quot;Done&quot;', result.getErrors()[0].getMessage(), 'Unexpected error message');
        }
    }
}