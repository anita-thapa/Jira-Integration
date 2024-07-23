@isTest
public class FromInQCShiftTest {
    @isTest
    /*
     * @description: Create a new record with 'In QC' as its status; change to 'To Do', 'In Progress', and 'Done'
     * @author: Diya Shrestha
     */
    static void testInQCShifting() {
        User testUser1 = [SELECT Id FROM User WHERE Username = 'helloooosregmi48@gmail.com' LIMIT 1];
        User testUser2 = [SELECT Id FROM User WHERE Username = 'aneitathapa28@mindful-otter-400oh5.com' LIMIT 1];

        /*
         * @description: Create records in 'In QC' status
         */
        Jira__c inqc1 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 2, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'In QC',
            Type__c = 'Epic'
        );

        Jira__c inqc2 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 2, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'In QC',
            Type__c = 'Epic'
        );

        Jira__c inqc3 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 2, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'In QC',
            Type__c = 'Epic'
        );

        insert new List<Jira__c> { inqc1, inqc2, inqc3 };

        /*
         * @description: Update the statuses
         */
        inqc1.Status__c = 'To Do';
        
        inqc2.Status__c = 'In Progress';
        inqc2.DueDate__c = Date.newInstance(2023, 4, 12);
        
        inqc3.Status__c = 'Done';

        Test.startTest();
        Database.SaveResult result1 = Database.update(inqc1, false);
        Database.SaveResult result2 = Database.update(inqc2, false);
        Database.SaveResult result3 = Database.update(inqc3, false);
        Test.stopTest();

        System.assert(result2.isSuccess());
        System.assert(result3.isSuccess());
        System.assertEquals('Cannot update the &quot;Status&quot; value from &quot;In QC&quot; to &quot;To Do&quot;', result1.getErrors()[0].getMessage(), 'Unexpected error message');
    }
}