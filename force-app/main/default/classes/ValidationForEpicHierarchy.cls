@isTest
private class ValidationForEpicHierarchy {
    @isTest
     /*
     * @description:should show error when 'epic' is created under 'epic', 'story', 'task' and 'bug'
     * @author: Diya Shrestha 
     */
    static void createDiffRelatedChildForEpicAndTest() {
        User  testUser1 = [SELECT Id FROM User WHERE Username = 'helloooosregmi48@gmail.com' LIMIT 1];
        User  testUser2 = [SELECT Id FROM User WHERE Username = 'aneitathapa28@mindful-otter-400oh5.com' LIMIT 1];
        
        /*
         * @description: create Parent Epic
         */
        Jira__c jira1 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 02, 22),
            Name = 'Epic 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Epic Summary',
            Status__c = 'To Do',
            Type__c = 'Epic'
        );
        insert jira1;
        
        /*
         * @description: attempt to create Child Epic inside the Parent Epic, setting the Related_Item__c field to the Parent Epic's Id
         */
        Jira__c jira2 = new Jira__c(
            StartDate__c = Date.newInstance(2023, 02, 22),
            Name = 'Epic 2',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Child Epic Summary',
            Status__c = 'To Do',
            Type__c = 'Epic',
            Related_Item__c = jira1.Id  
        );
        
        /*
         * @description: Create Parent Story
         */
        Jira__c jira3 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 02, 22),
            Name = 'Parent 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Story Summary',
            Status__c = 'To Do',
            Type__c = 'Story',
            Related_Item__c = jira1.Id
        );
        insert jira3;
        
        /*
         * @description: attempt to create Child Epic inside the Parent Story, setting the Related_Item__c field to the Parent Story's Id
         */
        Jira__c jira4 = new Jira__c(
            StartDate__c = Date.newInstance(2023, 02, 22),
            Name = 'Epic 2',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Child Epic Summary',
            Status__c = 'To Do',
            Type__c = 'Epic',
            Related_Item__c = jira3.Id 
        );
        
        /*
         * @description: Create Parent Task
         */
        Jira__c jira5 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 02, 22),
            Name = 'Task 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Task Summary',
            Status__c = 'To Do',
            Type__c = 'Task',
            Related_Item__c = jira1.Id
        );
        insert jira5;
        
        /*
         * @description: attempt to create Child Epic inside the Parent Task, setting the Related_Item__c field to the Parent Task's Id
         */
        Jira__c jira6 = new Jira__c(
            StartDate__c = Date.newInstance(2023, 02, 22),
            Name = 'Epic 2',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Child Epic Summary',
            Status__c = 'To Do',
            Type__c = 'Epic',
            Related_Item__c = jira5.Id 
        );
        
        /*
         * @description: Create Parent Bug
         */
        Jira__c jira7 = new Jira__c(
            StartDate__c = Date.newInstance(2024, 02, 22),
            Name = 'Bug 1',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Parent Bug Summary',
            Status__c = 'To Do',
            Type__c = 'Bug',
            Related_Item__c = jira1.Id
        );
        insert jira7;
        
        /*
         * @description: attempt to create Child Epic inside the Parent Story, setting the Related_Item__c field to the Parent Task's Id
         */
        Jira__c jira8 = new Jira__c(
            StartDate__c = Date.newInstance(2023, 02, 22),
            Name = 'Epic 2',
            Reporter__c = testUser1.Id,
            Assignee__c = testUser2.Id,
            Summary__c = 'Child Epic Summary',
            Status__c = 'To Do',
            Type__c = 'Epic',
            Related_Item__c = jira7.Id 
        );

        Test.startTest();
        List<Database.SaveResult>results=new List<Database.SaveResult>();
        results.add(Database.insert(jira2,false));
        results.add(Database.insert(jira4,false));
        results.add(Database.insert(jira6,false));
        results.add(Database.insert(jira8,false));
        Test.stopTest();
        
        for(Database.SaveResult result:results){
            System.assertEquals(false,result.isSuccess());
            System.assertEquals('Epic cannot be created inside epic, story, task or bug', result.getErrors()[0].getMessage(), 'Unexpected error message');
        }
    }
}