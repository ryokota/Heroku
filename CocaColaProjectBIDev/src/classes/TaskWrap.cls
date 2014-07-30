global class TaskWrap implements Comparable {
    public Milestone1_Task__c mainTask {get;set;}
    public Integer level { get;set; }
    public Map<Id, TaskWrap> subTaskMap { get;set; }
    public List<TaskWrap> subTaskList {get;set;}
    public TaskWrap(){
      mainTask = new Milestone1_Task__c();
      subTaskList = new List<TaskWrap>();
      subTaskMap = new Map<Id, TaskWrap>();
    }
    
    global Integer compareTo(Object compareTo) {
        // Cast argument to TaskWrap
        TaskWrap compareToWrapper = (TaskWrap)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (mainTask.Name > compareToWrapper.mainTask.Name) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (mainTask.Name < compareToWrapper.mainTask.Name) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
  }