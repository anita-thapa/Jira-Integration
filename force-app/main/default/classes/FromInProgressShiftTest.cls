@isTest
public class FromInProgressShiftTest {
    @isTest
    /*
     * @description: Create a new record with 'In Progress' as its status; change to 'To Do', 'In QC', and 'Done'
     * @author: Diya Shrestha
     */
    static void testInProgressShifting() {
        User testUser1 = [SELECT Id FROM User WHERE Username = 'helloooosregmi48@gmail.com' LIMIT 1];
        User testUser2 = [SELECT Id FROM User WHERE Username = 'aneitathapa28@mindful-otter-400oh5.com' LIMIT 1];

        /*
         * @description: Create records in 'In Progress' status
         */
        Jira__c inprogress1 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 2, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'In Progress',
            Type__c = 'Epic',
            DueDate__c = Date.newInstance(2023, 4, 12)
        );

        Jira__c inprogress2 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 2, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'In Progress',
            Type__c = 'Epic',
            DueDate__c = Date.newInstance(2023, 4, 12)
        );

        Jira__c inprogress3 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 2, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'In Progress',
            Type__c = 'Epic',
            DueDate__c = Date.newInstance(2023, 4, 12)
        );

        insert new List<Jira__c> { inprogress1, inprogress2, inprogress3 };

        /*
         * @description: Update the statuses
         */
        inprogress1.Status__c = 'To Do';
        inprogress2.Status__c = 'In QC';
        inprogress3.Status__c = 'Done';

        Test.startTest();
        Database.SaveResult result1 = Database.update(inprogress1, false);
        Database.SaveResult result2 = Database.update(inprogress2, false);
        Database.SaveResult result3 = Database.update(inprogress3, false);
        Test.stopTest();

        System.assert(result1.isSuccess());
        System.assert(result2.isSuccess());
        System.assertEquals('Cannot update the &quot;Status&quot; value from &quot;In Progress&quot; to &quot;Done&quot;', result3.getErrors()[0].getMessage(), 'Unexpected error message');
    }
}