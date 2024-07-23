@isTest
private class ValidationForSummary {
    @isTest
    /*
     * @description: Create a record with the summary field and create another record without the summary field. Our condition is that summary
     is required for every record
     */
    static void createNoSummaryAndTest() {
        User  testUser1 = [SELECT Id FROM User WHERE Username = 'helloooosregmi48@gmail.com' LIMIT 1];
        User  testUser2 = [SELECT Id FROM User WHERE Username = 'aneitathapa28@mindful-otter-400oh5.com' LIMIT 1];
        
        Jira__c newJira1 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 02, 22),
            Name = 'Ram',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'random1',
            Status__c = 'To Do',
            Type__c = 'Epic'
        );
        
        Jira__c newJira2 = new Jira__c(
            StartDate__c = Date.newInstance(2023, 02, 22),
            Name = 'Shyam',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Status__c = 'To Do',
            Type__c = 'Epic'
        );

        Test.startTest();
        Database.SaveResult result1 = Database.insert(newJira1, false);
        Database.SaveResult result2 = Database.insert(newJira2, false);
        Test.stopTest();

        System.assertEquals(true, result1.isSuccess());
        System.assertEquals(false, result2.isSuccess());
        System.assertEquals('The summary field should not be empty', result2.getErrors()[0].getMessage(), 'Unexpected error message');    
    }
}