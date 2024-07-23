trigger updateProjects on Project_Schedule__c (after insert, after update) {
    Set<String> newProjectNames = new Set<String>();
    for (Project_Schedule__c schedule : Trigger.new) {
        newProjectNames.add(schedule.Name);
    }

    // Query and delete old Project_Schedule__c records with the same names
    List<Project_Schedule__c> oldRecords = [SELECT Id, Name FROM Project_Schedule__c 
                                            WHERE Name IN :newProjectNames 
                                            AND Id NOT IN :Trigger.newMap.keySet()];
    if (!oldRecords.isEmpty()) {
        delete oldRecords;
    }

    // Query existing jobs for the new project names
    List<CronTrigger> existingJobs = [SELECT Id, CronJobDetail.Name 
                                      FROM CronTrigger 
                                      WHERE CronJobDetail.Name LIKE 'ProjectScheduleExecution_%'
                                      AND CronJobDetail.Name IN :newProjectNames];
    
    // Abort existing jobs
    for (CronTrigger job : existingJobs) {
        System.abortJob(job.Id);
    }

    // Schedule new jobs for all new records
    for (Project_Schedule__c project : Trigger.new) {
        String cronExpression = '0 0 0 * * ?'; 
        String jobName = 'ProjectScheduleExecution_' + project.Name;
        System.schedule(jobName, cronExpression, new ProjectScheduleExecution(project.Id));
    }
}