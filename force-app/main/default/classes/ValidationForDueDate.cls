@isTest
private class ValidationForDueDate {
    @isTest
    /*
     * @description: Create a record with status as 'In Progress' and define the DueDate. Also, create another record with status as 
     'In Progress' and do not define the DueDate. Our condition is DueDate is a required field when Status = 'In Progress'
     */
    static void createNoDueDateAndTest() {
        User  testUser1 = [SELECT Id FROM User WHERE Username = 'helloooosregmi48@gmail.com' LIMIT 1];
        User  testUser2 = [SELECT Id FROM User WHERE Username = 'aneitathapa28@mindful-otter-400oh5.com' LIMIT 1];
        
        Jira__c newJira1 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 02, 22),
            Name = 'Ram',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'random1',
            Status__c = 'In Progress',
            Type__c = 'Epic',
            DueDate__c = Date.newInstance(2024, 03, 22) 
        );
        
        Jira__c newJira2 = new Jira__c(
            StartDate__c = Date.newInstance(2023, 02, 22),
            Name = 'Shyam',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'random2',
            Status__c = 'In Progress',
            Type__c = 'Epic'
        );

        Test.startTest();
        Database.SaveResult result1 = Database.insert(newJira1, false);
        Database.SaveResult result2 = Database.insert(newJira2, false);
        Test.stopTest();

        System.assertEquals(true, result1.isSuccess());
        System.assertEquals(false, result2.isSuccess());
        System.assertEquals('The due date field should not be empty', result2.getErrors()[0].getMessage(), 'Unexpected error message');    
    }
}