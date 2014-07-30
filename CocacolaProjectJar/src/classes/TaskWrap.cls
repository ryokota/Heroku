public class TaskWrap {
    public Milestone1_Task__c mainTask {get;set;}
    public Integer level { get;set; }
    public Map<Id, TaskWrap> subTaskMap { get;set; }
    public List<TaskWrap> subTaskList {get;set;}
    public TaskWrap(){
      mainTask = new Milestone1_Task__c();
      subTaskList = new List<TaskWrap>();
      subTaskMap = new Map<Id, TaskWrap>();
    }
  }