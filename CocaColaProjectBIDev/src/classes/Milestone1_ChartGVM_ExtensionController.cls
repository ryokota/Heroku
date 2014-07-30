global class Milestone1_ChartGVM_ExtensionController {

    private final Milestone1_Project__c project;
    public ID targetProject {get; set;}
    
    public Milestone1_Settings__c settings = Milestone1_Settings__c.getInstance();

    public Milestone1_ChartGVM_ExtensionController(ApexPages.StandardController stdController) {
        this.project = (Milestone1_Project__c)stdController.getRecord();
        targetProject = this.project.Id;
    }
    
    public Milestone1_ChartGVM_ExtensionController(String projectId)
    {
        targetProject = projectId;    
    }
    
    public String getTaskStatusForOwners() {
        return getTaskStatusForOwners(this.project.Id, '');
    }
    
    public String getTaskStatusForProjectLeaders() {
        return getTaskStatusForOwners(this.project.Id, 'projectLeader');
    }
    
    public String getTaskStatusForProjectSponsors() {
        return getTaskStatusForOwners(this.project.Id, 'projectSponsor');
    }

    public String getTaskStatusForOwners(String projectId, String queryType) {
        
        List<Milestone1_Task__c> tasks = [SELECT Milestone1_Task__c.Name, Accountable_Owner__c, OverAll_PickList_Status__c, Overall_Status__c, ProjectId__c FROM Milestone1_Task__c ORDER BY Accountable_Owner__c, Overall_Status__c ];

        System.debug('getTaskStatusForOwners: ' + projectId + ', tasks ' + tasks);

        Map<Id, String> usernames = new Map<Id, String>();
        Map<Id, Milestone1_Project__c> projects = new Map<Id, Milestone1_Project__c>();

        List<Milestone1_Project__c> allProjects = [SELECT Id, Name, Project_Sponsor__c, Project_Leader__c FROM Milestone1_Project__c ];
        for (Milestone1_Project__c p : allProjects)
        {
            projects.put(p.Id, p);
        }

        // Collect all usernames
        for(Milestone1_Task__c task : tasks) {
        
            Milestone1_Project__c project = projects.get(task.ProjectId__c);
            
            if (queryType == 'projectSponsor') {
                if ((project.Project_Sponsor__c != null) && !usernames.containsKey(project.Project_Sponsor__c)) {
                    usernames.put(project.Project_Sponsor__c, '');
                }
            } else if (queryType == 'projectLeader') {
                if ((project.Project_Leader__c != null) && !usernames.containsKey(project.Project_Leader__c)) {
                    usernames.put(project.Project_Leader__c, '');
                }            
            } else {
                if ((task.Accountable_Owner__c != null) && !usernames.containsKey(task.Accountable_Owner__c)) {
                    usernames.put(task.Accountable_Owner__c, '');
                }            
            }
        }
        
        // Create a map with empty count values
        // OwnerId --> Status --> Count
        Map<String, Map<String, Integer>> theMap = new Map<String, Map<String, Integer>>();
        for (String key : usernames.keySet())
        {
            theMap.put(key, new Map<String, Integer>());
            theMap.get(key).put('Open', 0);
            theMap.get(key).put('Late', 0);
            theMap.get(key).put('Late In Progress', 0);
            theMap.get(key).put('Complete', 0);
        }
        
        for(Milestone1_Task__c task : tasks) 
        {
        
            Milestone1_Project__c project = projects.get(task.ProjectId__c);
            
            System.debug('Task [' + task.Name + '] Sponsor: [' + project.Project_Sponsor__c + '] Leader: [' + project.Project_Leader__c + ']');
            
            if (queryType == 'projectSponsor') {
                if ((project.Project_Sponsor__c != null) && theMap.containsKey(project.Project_Sponsor__c)
                    && (task.ProjectId__c == targetProject)) {
                    Map<String, Integer> mapForUser = theMap.get(project.Project_Sponsor__c);

                    // Get status
                    if (mapForUser != null)
                    {
//                        Integer currentCount = mapForUser.get((String)task.Overall_Status__c);
                        Integer currentCount = mapForUser.get(simplifyOverallStatus((String)task.OverAll_PickList_Status__c));
                        System.debug('' + mapForUser + ', Overall status: ' + task.Overall_Status__c + ', ' + currentCount);
                        if (currentCount != null)
                            mapForUser.put(simplifyOverallStatus((String)task.Overall_Status__c), (currentCount+1));
                    }
                }
            } else if (queryType == 'projectLeader') {
                if ((project.Project_Leader__c != null) && theMap.containsKey(project.Project_Leader__c)
                    && (task.ProjectId__c == targetProject)) {
                    Map<String, Integer> mapForUser = theMap.get(project.Project_Leader__c);

                    // Get status
                    if (mapForUser != null)
                    {
//                        Integer currentCount = mapForUser.get((String)task.Overall_Status__c);
                        Integer currentCount = mapForUser.get(simplifyOverallStatus((String)task.OverAll_PickList_Status__c));
                        System.debug('' + mapForUser + ', Overall status: ' + task.Overall_Status__c + ', ' + currentCount);
                        if (currentCount != null)
                            mapForUser.put(simplifyOverallStatus((String)task.Overall_Status__c), (currentCount+1));
                    }
                }                                
            }
            else // default is task.Accountable_Owner__c
            {
                if ((task.Accountable_Owner__c != null) && theMap.containsKey(task.Accountable_Owner__c)
                    && (task.ProjectId__c == targetProject)) {
                    Map<String, Integer> mapForUser = theMap.get(task.Accountable_Owner__c);

                    // Get status
                    if (mapForUser != null)
                    {
//                        Integer currentCount = mapForUser.get((String)task.Overall_Status__c);
                        Integer currentCount = mapForUser.get(simplifyOverallStatus((String)task.OverAll_PickList_Status__c));
                        System.debug('' + mapForUser + ', Overall status: ' + task.Overall_Status__c + ', ' + currentCount);
                        if (currentCount != null)
                            mapForUser.put(simplifyOverallStatus((String)task.Overall_Status__c), (currentCount+1));
                    }
                }
            }
        }
        
        Map<String, Map<String, Integer>> outMap = new Map<String, Map<String, Integer>>();
        for(String userKey : usernames.keySet()) {
            User user = [SELECT Id, Name FROM User Where Id = :userKey];
            outMap.put(user.Name, theMap.get(userKey));
        }
        
        Integer keySet = outMap.keySet().size();
        if (keySet == 0) {
            return '{}';
        }
        
        String ret = '';
        for (String key : outMap.keySet())
        {
            Map<String, Integer> statusMap = outMap.get(key);
            Integer open = statusMap.get('Open');
            Integer late = statusMap.get('Late');
            Integer lateInProgress = statusMap.get('Late In Progress');
            Integer complete = statusMap.get('Complete');
                
            // Only return this person if they have tasks        
            if (open > 0 || lateInProgress > 0 || late > 0 || complete > 0)
                ret += '[\'' + key + '\', ' + open + ',' + late + ',' + lateInProgress + ',' + complete + ', \'\' ],';
        }
        
        return ret;
    }
    
    public String simplifyOverallStatus(String status)
    {
        if (status == 'Late In Progress')
        {
            return status;
        } else if (status == 'Complete') {
            return status;      
        } else if (status.contains('Late')) {
            return 'Late';
        } else if (status.contains('Open')) {
            return 'Open';
        }
        
        return '';
    }
    
    public Pagereference viewMyTasks() {
        return new Pagereference('/' + settings.Report_Id_My_tasks_by_project__c + '?pv0=' + String.valueOf(targetProject).substring(0,15) + '&pv1=' + UserInfo.getFirstName() + ' ' + UserInfo.getLastName());
    }

    public Pagereference viewBlockedTasks() {
      
        return new Pagereference('/' + settings.Report_Id_Blocked_Tasks_by_Project__c + '?pv0=' + String.valueOf(targetProject).substring(0,15) );
    }

    public Pagereference viewOverdueTasks() {
        return new Pagereference('/' + settings.Report_Id_Overdue_Tasks_by_Project__c + '?pv0=' + String.valueOf(targetProject).substring(0,15) );
    }

    public Pagereference viewOpenTasks() {
        return new Pagereference('/' + settings.Report_Id_Open_Task_Status_by_Project__c + '?pv0=' + String.valueOf(targetProject).substring(0,15) );
    }

    public Pagereference viewMilestoneOpenTasks() {
        return new Pagereference('/' + settings.Report_Id_Project_Milestone_Open_Task__c + '?pv0=' + String.valueOf(targetProject).substring(0,15) );
    }

    public Pagereference incompleteTasksByProject() {

        return new Pagereference('/' + settings.Report_Id_My_Tasks_By_Project_Milesto__c + '?pv0=' + Encodingutil.urlEncode(''+UserInfo.getName(), 'UTF-8' ));
    }

    public Pagereference incompleteTasksByPriority() {
  
        return new Pagereference('/' + settings.Report_Id_My_Tasks_By_Priority_Project__c + '?pv0=' + Encodingutil.urlEncode(''+UserInfo.getName(), 'UTF-8' ) );
    }

    public Pagereference summaryMyLateTasks() {
     
        return new Pagereference('/' + settings.Report_Id_My_Late_Tasks__c + '?pv0=' + Encodingutil.urlEncode(''+UserInfo.getName(), 'UTF-8' ) );
    }
    
    public Pagereference summaryMyBlockedTasks() {
     
        return new Pagereference('/' + settings.Report_Id_My_Blocked_Tasks__c + '?pv0=' + Encodingutil.urlEncode(''+UserInfo.getName(), 'UTF-8' ) );
    }
}