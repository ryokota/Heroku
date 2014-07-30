global class Milestone1_MSCharts_ExtensionController {

    private final Milestone1_Milestone__c milestone;
    public ID targetMilestone {get; set;}
    
    public Milestone1_Settings__c settings = Milestone1_Settings__c.getInstance();
    
     public Milestone1_MSCharts_ExtensionController(ApexPages.StandardController stdController) {
        this.milestone = (Milestone1_Milestone__c)stdController.getRecord();
        targetMilestone = this.milestone.Id;
    }
    
    public String simplifyOverallStatus(String status)
    {
        if (status == 'Late In Progress')
        {
            return status;      
        } else if (status.contains('Late')) {
            return 'Late';
        } else if (status == 'Complete') {
            return status;
        } else if (status.contains('Open')) {
            return 'Open';
        }
        
        return '';
    }
    
    public String getTaskStatusForOwners() {
        return getTaskStatusForOwners(this.milestone.Id, '');
    }
    
    public String getTaskStatusForProjectLeaders() {
        return getTaskStatusForOwners(this.milestone.Id, 'projectLeader');
    }
    
    public String getTaskStatusForProjectSponsors() {
        return getTaskStatusForOwners(this.milestone.Id, 'projectSponsor');
    }
    
    public String getTaskStatusForAssigned() {
        return getTaskStatusForOwners(this.milestone.Id, 'projectAssigned');
    }
    
    public String getTaskStatusForOwners(String milestoneId, String queryType) {
        List<Milestone1_Task__c> tasks = [SELECT Milestone1_Task__c.Name, Accountable_Owner__c, OverAll_PickList_Status__c, Overall_Status__c, ProjectId__c, Project_Milestone__c, Assigned_To__c FROM Milestone1_Task__c ORDER BY Accountable_Owner__c, Overall_Status__c ];

        System.debug('getTaskStatusForOwners: ' + targetMilestone + ', tasks ' + tasks);

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
            } else if (queryType == 'projectAssigned') {
                if ((task.Assigned_To__c != null) && !usernames.containsKey(task.Assigned_To__c)) {
                    usernames.put(task.Assigned_To__c, '');
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
            theMap.get(key).put('Late In Progress', 0);
            theMap.get(key).put('Late', 0);
            theMap.get(key).put('Complete', 0);
        }
        
        for(Milestone1_Task__c task : tasks) 
        {
        
            Milestone1_Project__c project = projects.get(task.ProjectId__c);
            
            System.debug('Task [' + task.Name + '] Sponsor: [' + project.Project_Sponsor__c + '] Leader: [' + project.Project_Leader__c + ']');
            
            if (queryType == 'projectSponsor') {
                if ((project.Project_Sponsor__c != null) && theMap.containsKey(project.Project_Sponsor__c)
                    && (task.Project_Milestone__c == targetMilestone)) {
                    Map<String, Integer> mapForUser = theMap.get(project.Project_Sponsor__c);

                    // Get status
                    if (mapForUser != null)
                    {
                        Integer currentCount = mapForUser.get(simplifyOverallStatus((String)task.OverAll_PickList_Status__c));
                        System.debug('' + mapForUser + ', Overall status: ' + task.Overall_Status__c + ', ' + currentCount);
                        if (currentCount != null)
                            mapForUser.put(simplifyOverallStatus((String)task.Overall_Status__c), (currentCount+1));
                    }
                }
            } else if (queryType == 'projectLeader') {
                if ((project.Project_Leader__c != null) && theMap.containsKey(project.Project_Leader__c)
                    && (task.Project_Milestone__c == targetMilestone)) {
                    Map<String, Integer> mapForUser = theMap.get(project.Project_Leader__c);

                    // Get status
                    if (mapForUser != null)
                    {
                        Integer currentCount = mapForUser.get(simplifyOverallStatus((String)task.OverAll_PickList_Status__c));
                        System.debug('' + mapForUser + ', Overall status: ' + task.Overall_Status__c + ', ' + currentCount);
                        if (currentCount != null)
                            mapForUser.put(simplifyOverallStatus((String)task.Overall_Status__c), (currentCount+1));
                    }
                } 
            } else if (queryType == 'projectAssigned') {
                if ((task.Assigned_To__c != null) && theMap.containsKey(task.Assigned_To__c)
                    && (task.Project_Milestone__c == targetMilestone)) {
                    Map<String, Integer> mapForUser = theMap.get(task.Assigned_To__c);

                    // Get status
                    if (mapForUser != null)
                    {
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
                    && (task.Project_Milestone__c == targetMilestone)) {
                    Map<String, Integer> mapForUser = theMap.get(task.Accountable_Owner__c);

                    // Get status
                    if (mapForUser != null)
                    {
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
}