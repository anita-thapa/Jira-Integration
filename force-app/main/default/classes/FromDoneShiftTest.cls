@isTest
public class FromDoneShiftTest {
    @isTest
    /*
     * @description: Create a new record with 'Done' as its status; change to 'To Do', 'In Progress', and 'In QC'
     * @author: Diya Shrestha
     */
    static void testDoneShifting() {
        User testUser1 = [SELECT Id FROM User WHERE Username = 'helloooosregmi48@gmail.com' LIMIT 1];
        User testUser2 = [SELECT Id FROM User WHERE Username = 'aneitathapa28@mindful-otter-400oh5.com' LIMIT 1];

        /*
         * @description: Create records in 'Done' status
         */
        Jira__c indone1 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 2, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'Done',
            Type__c = 'Epic'
        );

        Jira__c indone2 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 2, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'Done',
            Type__c = 'Epic'
        );

        Jira__c indone3 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 2, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'Done',
            Type__c = 'Epic'
        );

        insert new List<Jira__c> { indone1, indone2, indone3 };

        /*
         * @description: Update the statuses
         */
        indone1.Status__c = 'To Do';
        
        indone2.Status__c = 'In Progress';
        indone2.DueDate__c = Date.newInstance(2023, 4, 12);

        indone3.Status__c = 'In QC';

        Test.startTest();
        List<Database.SaveResult> results = Database.update(new List<Jira__c> { indone1, indone2, indone3 }, false);
        Test.stopTest();
        
        for (Database.SaveResult result : results) {
            System.assertEquals('Cannot update the &quot;Status&quot; value from &quot;Done&quot; to any available options', result.getErrors()[0].getMessage(), 'Unexpected error message');
        }
    }
}