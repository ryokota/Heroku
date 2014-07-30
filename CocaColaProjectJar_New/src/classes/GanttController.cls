public with sharing class GanttController {

    /* mytarget is the ID of the target */
    public String mytarget {get; 
        set{
            this.mytarget = value;
        }
    }
       
    public Integer maxTaskLevel {get;set;}
    public String objectType {get;set;}
    public String startDateFieldName {get;set;}
    public String endDateFieldName {get;set;}
    public String idFieldName {get;set;}
    public String fullViewURL {get;set;}
    
    private static final String REGEXP_QUOTES    = '(?<!\\\\)"';

    // Support for five levels
    public Map<Id, MilestoneWrap> resultMap = new Map<Id, MilestoneWrap>();
    public Map<Id, TaskWrap> taskResultMap = new Map<Id, TaskWrap>();
    List<MilestoneWrap> wrapList = new List<MilestoneWrap>();
    // End support for five levels
    
    public GanttController()
    {
        maxTaskLevel = 999;
    }
    
    /*
    * getFiveLevelsData
    *
    * Dependent on "mytarget"
    * - If mytarget == null, it will list *all* events
    * - If mytarget begins with Milestone1_Project__c KeyPrefix, show Project AND Milestones AND Tasks
    * - If mytarget begins with Milestone1_Milestone__c KeyPrefix, show Milestones AND Tasks
    */
    public String getFiveLevelsData() {
        String ret = '[';
                
        System.debug('Mytarget: ' + mytarget + ' ' + Schema.SObjectType.Milestone1_Project__c.getKeyPrefix());
        System.debug('Mytarget: ' + mytarget + ' ' + Schema.SObjectType.Milestone1_Milestone__c.getKeyPrefix());
                
        List<Milestone1_Milestone__c> milestones = null;
        if (mytarget == null) {
        /* ALL projects */
            milestones = [Select Id, Name, Kickoff__c, Deadline__c, Parent_Milestone__c, Complete__c, Progress__c, Milestone_Status__c,
                              (Select ID, Name, Start_Date__c, Due_Date__c, Parent_Task__c, Parent_Parent_Task__c, Parent_Level4__c, Parent_Level5__c, Parent_Level6__c, Parent_Level7__c, Complete__c, Progress__c, Task_Status__c From Project_Tasks__r order by Parent_Level5__c, Parent_Level4__c, Parent_Parent_Task__c, Parent_Task__c, id ) 
                          From Milestone1_Milestone__c 
                          order by parent_milestone__c];
        } else if(mytarget.startsWith(Schema.SObjectType.Milestone1_Project__c.getKeyPrefix())) {
        /* Project level and down */
            milestones = [Select Id, Name, Kickoff__c, Deadline__c, Parent_Milestone__c, Complete__c, Progress__c, Milestone_Status__c,
                              (Select ID, Name, Start_Date__c, Due_Date__c, Parent_Task__c, Parent_Parent_Task__c, Parent_Level4__c, Parent_Level5__c, Parent_Level6__c, Parent_Level7__c, Complete__c, Progress__c, Task_Status__c From Project_Tasks__r order by Parent_Level5__c, Parent_Level4__c, Parent_Parent_Task__c, Parent_Task__c, id ) 
                          From Milestone1_Milestone__c WHERE Project__C = :mytarget
                          order by parent_milestone__c];
        } else if(mytarget.startsWith(Schema.SObjectType.Milestone1_Milestone__c.getKeyPrefix())) {
            milestones = [Select Id, Name, Kickoff__c, Deadline__c, Parent_Milestone__c, Complete__c, Progress__c, Milestone_Status__c,
                              (Select ID, Name, Start_Date__c, Due_Date__c, Parent_Task__c, Parent_Parent_Task__c, Parent_Level4__c, Parent_Level5__c, Parent_Level6__c, Parent_Level7__c, Complete__c, Progress__c, Task_Status__c From Project_Tasks__r order by Parent_Level5__c, Parent_Level4__c, Parent_Parent_Task__c, Parent_Task__c, id ) 
                          From Milestone1_Milestone__c WHERE Id = :mytarget
                          order by parent_milestone__c];        
        }
                          
        Integer counter = 0;
        for(Milestone1_Milestone__c milestone : milestones) {
        
          if(milestone.Parent_Milestone__c != null && counter > 0){
            WrapperClass subWrap = new WrapperClass();
            subWrap.subM = milestone;
            subWrap.subT = wrapTasks(milestone.Project_Tasks__r);

            resultMap.get(milestone.Parent_Milestone__c).subMilestone.add(subWrap);
                
            continue;
          }
          
          MilestoneWrap wrapper = new MilestoneWrap();
          wrapper.mainMilestone.subM = milestone;
          wrapper.mainMilestone.subT = wrapTasks(milestone.Project_Tasks__r);
          
          resultMap.put(milestone.Id, wrapper); 
          counter++;     
        }
        
        System.debug('Parsed ' + counter + 'milestones in getFiveLevelsData()');
        System.debug('The resultMap size is ' + resultMap.size() + '');
        
        Integer resultCounter = 0;
        for (String msKey : resultMap.keySet())
        {
            MilestoneWrap msWrapper = resultMap.get(msKey);
            
            if (resultCounter>0)
                ret += ',';
            
            if (msWrapper.subMilestone.size() == 0)
            {
                ret += getMilestoneData(msWrapper.mainMilestone);
            } else {
                ret += getMilestoneData(msWrapper.mainMilestone);
                
                for (WrapperClass sms : msWrapper.subMilestone) {
                    ret += getSubmilestoneData(sms, msWrapper.mainMilestone.subM.Id);
                }
            }
            
            counter++;
        }
        
        return ret + ']';

    }
    
    /*
    * getTaskLevel
    *
    * Determines the depth level of a task
    * where level 1 is the first level of tasks
    * below the milestone level
    *
    * Parameters:
    * Milestone1_Task__c - a task
    */
    public Integer getTaskLevel(Milestone1_Task__c task) {
        
        if (task.Parent_Level7__c != null && task.Parent_Level6__c != null && task.Parent_Level5__c != null && task.Parent_Level4__c != null && task.Parent_Parent_Task__c != null && task.Parent_Task__c != null )
        {
            return 7;
        }
        else if (task.Parent_Level7__c == null && task.Parent_Level6__c != null && task.Parent_Level5__c != null && task.Parent_Level4__c != null && task.Parent_Parent_Task__c != null && task.Parent_Task__c != null )
        {
            return 6;
        }
        else if (task.Parent_Level7__c == null && task.Parent_Level6__c == null && task.Parent_Level5__c != null && task.Parent_Level4__c != null && task.Parent_Parent_Task__c != null && task.Parent_Task__c != null )
        {
            return 5;
        }
        else if (task.Parent_Level7__c == null && task.Parent_Level6__c == null && task.Parent_Level5__c == null && task.Parent_Level4__c != null && task.Parent_Parent_Task__c != null && task.Parent_Task__c != null )
        {
            return 4;
        }
        else if (task.Parent_Level7__c == null && task.Parent_Level6__c == null && task.Parent_Level5__c == null && task.Parent_Level4__c == null && task.Parent_Parent_Task__c != null && task.Parent_Task__c != null )
        {
            return 3;
        }
        else if (task.Parent_Level7__c == null && task.Parent_Level6__c == null && task.Parent_Level5__c == null && task.Parent_Level4__c == null && task.Parent_Parent_Task__c == null && task.Parent_Task__c != null )
        {
            return 2;
        }
        else if (task.Parent_Level7__c == null && task.Parent_Level6__c == null && task.Parent_Level5__c == null && task.Parent_Level4__c == null && task.Parent_Parent_Task__c == null && task.Parent_Task__c == null )
        {
            return 1;
        }

        return 1;
    }
    
    /*
    *
    * wrapTasks
    *
    * Creates a TaskWrap for a list of Milestone1_Task__c
    * and adds each TaskWrap to the global taskResultMap
    *
    * Returns a list of TaskWrap objects
    */
    public List<TaskWrap> wrapTasks(List<Milestone1_Task__c> taskList) {
        List<TaskWrap> outTaskList = new List<TaskWrap>();
        
        Integer taskCounter = 0;
        for (Milestone1_Task__c task : taskList)
        {
            Integer taskLevel = getTaskLevel(task);

			if (taskLevel == 7 && maxTaskLevel >= 7)
            {
                // Task level 7
                TaskWrap subTaskWrap = new TaskWrap();
                subTaskWrap.mainTask = task;
                subTaskWrap.level = 7;
                
                System.debug('Task level 7');
                System.debug('Task level 7: Adding [' + task.Name + '][' + task.Id + '] to taskResultMap');
                System.debug('taskResultMap ' + taskResultMap.get(task.Parent_Task__c));
                
                taskResultMap.get(task.Parent_Task__c).subTaskMap.put(task.Id, subTaskWrap);                
                
                taskResultMap.put(task.Id, subTaskWrap);
                outTaskList.add(subTaskWrap);
            }
            else if (taskLevel == 6 && maxTaskLevel >= 6)
            {
                // Task level 6
                TaskWrap subTaskWrap = new TaskWrap();
                subTaskWrap.mainTask = task;
                subTaskWrap.level = 6;
                
                System.debug('Task level 6');
                System.debug('Task level 6: Adding [' + task.Name + '][' + task.Id + '] to taskResultMap');
                System.debug('taskResultMap ' + taskResultMap.get(task.Parent_Task__c));
                
                taskResultMap.get(task.Parent_Task__c).subTaskMap.put(task.Id, subTaskWrap);                
                
                taskResultMap.put(task.Id, subTaskWrap);
                outTaskList.add(subTaskWrap);
            }
            else if (taskLevel == 5 && maxTaskLevel >= 5)
            {
                // Task level 5
                TaskWrap subTaskWrap = new TaskWrap();
                subTaskWrap.mainTask = task;
                subTaskWrap.level = 5;
                
                System.debug('Task level 5');
                System.debug('Task level 5: Adding [' + task.Name + '][' + task.Id + '] to taskResultMap');
                System.debug('taskResultMap ' + taskResultMap.get(task.Parent_Task__c));
                
                taskResultMap.get(task.Parent_Task__c).subTaskMap.put(task.Id, subTaskWrap);                
                
                taskResultMap.put(task.Id, subTaskWrap);
                outTaskList.add(subTaskWrap);
            }
            else if (taskLevel == 4 && maxTaskLevel >= 4)
            {
                // Task level 4
                TaskWrap subTaskWrap = new TaskWrap();
                subTaskWrap.mainTask = task;
                subTaskWrap.level = 4;
                
                System.debug('Task level 4');
                System.debug('Task level 4: Adding [' + task.Name + '][' + task.Id + '] to taskResultMap');
                System.debug('taskResultMap ' + taskResultMap.get(task.Parent_Task__c));
                
                taskResultMap.get(task.Parent_Task__c).subTaskMap.put(task.Id, subTaskWrap);                
                
                taskResultMap.put(task.Id, subTaskWrap);
                outTaskList.add(subTaskWrap);
            }
            else if (taskLevel == 3 && maxTaskLevel >= 3)
            {
                // Task level 3
                TaskWrap subTaskWrap = new TaskWrap();
                subTaskWrap.mainTask = task;
                subTaskWrap.level = 3;
                
                System.debug('Task level 3');
                System.debug('Task level 3: Adding [' + task.Name + '][' + task.Id + '] to taskResultMap');
                System.debug('taskResultMap ' + taskResultMap.get(task.Parent_Task__c));
                
                taskResultMap.get(task.Parent_Task__c).subTaskMap.put(task.Id, subTaskWrap);                
                
                taskResultMap.put(task.Id, subTaskWrap);
                outTaskList.add(subTaskWrap);
            }
            else if (taskLevel == 2 && maxTaskLevel >= 2)
            {
                // Task level 2
                TaskWrap subTaskWrap = new TaskWrap();
                subTaskWrap.mainTask = task;
                subTaskWrap.level = 2;
                
                System.debug('Task level 2: Adding [' + task.Name + '][' + task.Id + '] to taskResultMap');
                taskResultMap.get(task.Parent_Task__c).subTaskMap.put(task.Id, subTaskWrap);                
                
                taskResultMap.put(task.Id, subTaskWrap);
                outTaskList.add(subTaskWrap);
            } else if (taskLevel == 1 && maxTaskLevel >= 1) {
                // Task level 1
                TaskWrap taskWrap = new TaskWrap();
                taskWrap.mainTask = task;
                taskWrap.level = 1;

                System.debug('Task level 1: Adding [' + task.Name + '][' + task.Id + '] to taskResultMap');
                taskResultMap.put(task.Id, taskWrap);  
                outTaskList.add(taskWrap); 
            }
            
            taskCounter++;
        }
        
        System.debug('looped over tasks in milestonetasks: ' + taskCounter);
        System.debug('the outTaskList has size ' + outTaskList.size());
        
        return outTaskList;
    
    }
    
    /*
    *
    * getJsonForTaskList
    *
    * Takes a list of tasks (from a parent milestone)
    * and concatenates the values to a JSON string
    *
    * Returns a JSON String containing task data
    */
    public String getJsonForTaskList(List<TaskWrap> allTasks, Integer level, String milestoneId, boolean isParentAMilestone) {
        String ret = '';
        
        for (TaskWrap wrap : allTasks)
        {
            Milestone1_Task__c task = wrap.mainTask;
        
            if (task.Parent_Task__c != null || task.Parent_Parent_Task__c != null)
                continue;
                
            String parentId = task.Parent_Task__c;
            if (parentId == null)
            	parentId = milestoneId;

            TaskWrap tw = taskResultMap.get(task.Id);
            ret += getTaskData(tw.mainTask, level, parentId);
            ret += ',';

            for (String subTaskKey : tw.subTaskMap.keySet()) {
                TaskWrap tw2 = tw.subTaskMap.get(subTaskKey);
                ret += getTaskData(tw2.mainTask, level, parentId);
                ret += ',';

                for (String subTaskKey2 : tw2.subTaskMap.keySet()) {
                    TaskWrap tw3 = tw2.subTaskMap.get(subTaskKey2);                    
                    ret += getTaskData(tw3.mainTask, level, parentId);
                    ret += ',';
                    
                    for (String subTaskKey3 : tw3.subTaskMap.keySet()) {
                        TaskWrap tw4 = tw3.subTaskMap.get(subTaskKey3);                    
                        ret += getTaskData(tw4.mainTask, level, parentId);
                        ret += ',';
                                                
                        for (String subTaskKey4 : tw4.subTaskMap.keySet()) {
                            TaskWrap tw5 = tw4.subTaskMap.get(subTaskKey4);                    
                            ret += getTaskData(tw5.mainTask, level, parentId);
                            ret += ',';
                            
                            for (String subTaskKey5 : tw5.subTaskMap.keySet()) {
                            	TaskWrap tw6 = tw5.subTaskMap.get(subTaskKey5);                    
                            	ret += getTaskData(tw6.mainTask, level, parentId);
                            	ret += ',';
                            	
                            	for (String subTaskKey6 : tw6.subTaskMap.keySet()) {
                            		TaskWrap tw7 = tw6.subTaskMap.get(subTaskKey6);                    
                            		ret += getTaskData(tw7.mainTask, level, parentId);
                            		ret += ',';
                        		}
                        	}
                        }
                    }
                }
            }
        }
        
        return ret;
    }
    
    /*
    * getSubmilestoneData
    *
    * Create JSON for a submilestone
    *
    * Returns a JSON string of a submilestone
    * 
    */
    public String getSubmilestoneData(WrapperClass submilestone, String parentId) {
        String ret = '{ ';
        
        ret += ' "id" : "' + submilestone.subM.Id + '", ';
        ret += ' "level" : "2", ';
        ret += ' "isMS" : true, ';
        ret += ' "desc" : "' + escapeDoubleQuotes(submilestone.subM.Name) + '", ';
        ret += getValues(submilestone.subM.Id, parentId, 'submilestone', submilestone.subM.Milestone_Status__c, submilestone.subM.Progress__c, submilestone.subM.Complete__c, submilestone.subM.Name, submilestone.subM.Kickoff__c, submilestone.subM.Deadline__c);
        ret += ' }, ';
    
        if (submilestone.subT != null)
            ret += getJsonForTaskList(submilestone.subT, 2, submilestone.subM.Id, true);
        
        return ret;
    }
    
    /*
    * getMilestoneData
    *
    * Create JSON for a milestone
    *
    * Returns a JSON string of a milestone
    * 
    */
    public String getMilestoneData(WrapperClass milestone) {
        String ret = '{ ';
        ret += ' "level" : "1", ';
        ret += ' "id" : "' + milestone.subM.Id + '",';
        ret += ' "isMS" : true, ';
        ret += ' "desc" : "' + escapeDoubleQuotes(milestone.subM.Name) + '", ';

        ret += getValues(milestone.subM.Id, '', 'milestone', null, milestone.subM.Progress__c, milestone.subM.Complete__c, milestone.subM.Name, milestone.subM.Kickoff__c, milestone.subM.Deadline__c);
        ret += ' }, ';
    
        if (milestone.subT != null)
            ret += getJsonForTaskList(milestone.subT, 1, milestone.subM.Id, true);

        return ret;
    }

    /*
    * getTaskData
    *
    * Create JSON for a particular task
    *
    * Returns a JSON string representation of one task
    * 
    */
    public String getTaskData(Milestone1_Task__c task, Integer prevLevel, String parentId) {
        String ret = '';
        
        ret += '{ "desc" : "' + escapeDoubleQuotes(task.Name) + '", ';
        
        ret += ' "id" : "' + task.Id + '", ';
        
        Integer taskLevel = getTaskLevel(task);
        
        if (taskLevel == 1) { //(task.Parent_Task__c == null && task.Parent_Parent_Task__c == null) {
            ret += ' "level" : "' + (prevLevel+1) + '", ';
        } else if (taskLevel == 2) { // (task.Parent_Task__c != null && task.Parent_Parent_Task__c == null) {
            ret += ' "level" : "' + (prevLevel+2) + '", ';
        } else if (taskLevel == 3) { //(task.Parent_Task__c != null && task.Parent_Parent_Task__c != null) {
            ret += ' "level" : "' + (prevLevel+3) + '", ';
        }
        else if (taskLevel == 4) 
        {
            ret += ' "level" : "' + (prevLevel+4) + '", ';
        }
        else if (taskLevel == 5)
        {
            ret += ' "level" : "' + (prevLevel+5) + '", ';
        }
        else if (taskLevel == 6)
        {
            ret += ' "level" : "' + (prevLevel+6) + '", ';
        }
        else if (taskLevel == 7)
        {
            ret += ' "level" : "' + (prevLevel+7) + '", ';
        }
        
        ret += ' "name" : "", ';
        
        String parentTaskId = task.Parent_Task__c;
        if (task.Parent_Task__c == null) {
        	parentTaskId = parentId;
        }
        ret += ' "parentId" : "' + parentTaskId + '", ';

        ret += getValues(task.Id, parentTaskId, 'task', task.Task_Status__c, task.Progress__c, task.Complete__c, task.Name, task.Start_Date__c, task.Due_Date__c);
        ret += '}';
    
        return ret;
    }
    
    /*
    * getValues
    *
    * Create additional JSON data for a task
    *
    * Returns a JSON string representation of additional
    * values for one task
    * 
    */
    public String getValues(String id, String parentId, String type, String status, Decimal progress, Boolean completed, String label, Date startDate, Date endDate) {
                String ret = '"values": [{ ';
                    ret += ' "dataObj" : { ';
                    ret += '      "id" : "' + id + '",';

                    if (progress != null) {
                        ret += '      "progress" : "' + progress + '" ';
                    } else {
                        ret += '      "progress" : "' + 0.0 + '" ';
                    }
                    
                ret += ' },';
                
                ret += ' "parent" : "' + parentId + '", ';
            
                if (startDate != null) {
                    ret += '"from": "/Date(' + ((DateTime)startDate).getTime() + ')/",';
                } else {
                    ret += '"from": "/Date(' + DateTime.now().getTime() + ')/",';
                }

                if (endDate != null) {
                    ret += '"to": "/Date(' + ((DateTime)endDate).getTime() + ')/",';
                } else {
                    ret += '"to": "/Date(' + DateTime.now().addHours(1).getTime() + ')/",';
                }
                

                    // milestone or project
                    
                    String statusColor = '';
                    if (completed) {
                        statusColor = 'ganttBlack';
                    } else if (status == 'Green') {
                        statusColor = 'ganttGreen';
                    } else if (status == 'Yellow') {
                        statusColor = 'ganttYellow';
                    } else if (status == 'Red') {
                        statusColor = 'ganttRed';
                    } else {
                        statusColor = 'ganttGray';
                    }
                    
                    ret += ' "customClass" : "' + statusColor + '",';

                ret += '"label": "' + escapeDoubleQuotes(label) +'" }]';  
                
                return ret;  
    }
    
  public String escapeDoubleQuotes(String word){
      return word.escapeEcmaScript();
  }

  

}