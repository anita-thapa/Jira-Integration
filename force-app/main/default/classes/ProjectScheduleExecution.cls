/*
 * @description: creates a schedulable class whose instance is called in ProjectScheduleExecutor class
 * @author: Diya Shrestha 
*/
public class ProjectScheduleExecution implements Schedulable {
    private Id projectId;
    public ProjectScheduleExecution(Id projectId) {
    this.projectId = projectId;
  }
    
  public void execute(SchedulableContext context) {
    Project_Schedule__c schedule = [SELECT Id, Name FROM Project_Schedule__c WHERE Id = :projectId];
    String Namez = (string)schedule.Name;
    JiraRestClient.performHttpRequestWithNamedCredential(Namez);
  }
}