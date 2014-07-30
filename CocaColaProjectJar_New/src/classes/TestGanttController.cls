@isTest
    private class TestGanttController {
    
        static testMethod void testControllerGettersAndSetters()
        {
            String eMytarget = 'ExpectedTarget';
            String eObjectType = 'ExpectedObjectType';
            String eStartDateFieldName = 'ExpectedFieldName';
            String eEndDateFieldName = 'ExpectedEndFieldName';
            String eIdFieldName = 'ExpectedIdFieldName';
            String eFullViewURL = 'http://www.salesforce.com/?j3g9jg3&test=2';

        
            GanttController c = new GanttController();
            c.mytarget = eMytarget;
            c.objectType = eObjectType;
            c.startDateFieldName = eStartDateFieldName;
            c.endDateFieldName = eEndDateFieldName;
            c.idFieldName = eIdFieldName;
            c.fullViewURL = eFullViewURL;

            
            doAssert('testControllerGettersAndSetters', c.mytarget, eMytarget);
            doAssert('testControllerGettersAndSetters', c.objectType, eObjectType);
            doAssert('testControllerGettersAndSetters', c.startDateFieldName, eStartDateFieldName);
            doAssert('testControllerGettersAndSetters', c.endDateFieldName, eEndDateFieldName);
            doAssert('testControllerGettersAndSetters', c.idFieldName, eIdFieldName);
            doAssert('testControllerGettersAndSetters', c.fullViewURL, eFullViewURL);
            
        }
        
        static testMethod void testApexController()
        {
            Milestone1_Project__c p1 = Milestone1_Test_Utility.sampleProjectActive('ApexJson');
            insert p1;
        

            Milestone1_Milestone__c m2 = Milestone1_Test_Utility.sampleMilestone(p1);
            m2.Deadline__c = Date.today()-1;
            insert m2;   
  
      
            Milestone1_Task__c t1 = Milestone1_Test_Utility.sampleTask(m2.Id);
            insert t1;
            
            Milestone1_Task__c subtask1 = Milestone1_Test_Utility.sampleTask(m2.Id, t1.Id, Date.today()-1, Date.today()+2);
            subtask1.Parent_Task__c = t1.Id;
            insert subtask1;

            Milestone1_Task__c subsubtask1 = Milestone1_Test_Utility.sampleTask(m2.Id, subtask1.Id, Date.today()-1, Date.today()+2);
            subsubtask1.Parent_Task__c = subtask1.Id;
            insert subsubtask1;         
        
            ApexPages.StandardController sc = new ApexPages.StandardController(t1);        
        }
    
        static testMethod void testGetFiveLevelsDataTopLevel()
        {
            Milestone1_Project__c p1 = Milestone1_Test_Utility.sampleProjectActive('Json');
            insert p1;
        
            Milestone1_Milestone__c m2 = Milestone1_Test_Utility.sampleMilestone(p1);
            m2.Deadline__c = Date.today()-1;
            insert m2;   
            
            Milestone1_Milestone__c subm1 = Milestone1_Test_Utility.testSampleMilestone(p1.Id, m2.Id, 'Submilestone');
            subm1.Parent_Milestone__c = m2.Id;
            subm1.Deadline__c = Date.today()-1;
            insert subm1;   
      
            Milestone1_Task__c t1 = Milestone1_Test_Utility.sampleTask(m2.Id);
            insert t1;
            
            Milestone1_Task__c subtask1 = Milestone1_Test_Utility.sampleTask(m2.Id, t1.Id, Date.today()-1, Date.today()+2);
            subtask1.Parent_Task__c = t1.Id;
            insert subtask1;

            Milestone1_Task__c subsubtask1 = Milestone1_Test_Utility.sampleTask(m2.Id, subtask1.Id, Date.today()-1, Date.today()+2);
            subsubtask1.Parent_Task__c = subtask1.Id;
            insert subsubtask1;        
        
            GanttController c = new GanttController();            
            String json = c.getFiveLevelsData();
  
            System.assert(json.length() > 0, 'top level');
            
            c.mytarget = Schema.SObjectType.Milestone1_Project__c.getKeyPrefix();
            String jsonLevel2 = c.getFiveLevelsData();
            System.assert(jsonLevel2.length() > 0, 'level 2');            
            
            c.mytarget = Schema.SObjectType.Milestone1_Milestone__c.getKeyPrefix();
            String jsonLevel3 = c.getFiveLevelsData();
            System.assert(jsonLevel3.length() > 0, 'level 3');            
            
            
        }
        
    
        static testMethod void testWrapTasks()
        {

            List<Milestone1_Task__c> msTaskList = new List<Milestone1_Task__c>();
            
            Milestone1_Task__c task = new Milestone1_Task__c();
            task.Name = 'Main Task';            
            msTaskList.add(task);
                     
            GanttController c = new GanttController();
            List<TaskWrap> taskWrapList = c.wrapTasks(msTaskList);
            
            String json = c.getJsonForTaskList(taskWrapList, 3, 'MILESTONE', false);            
            json = json.replaceAll('\\d{13}', '');
            
            String expected = '{ "desc" : "Main Task",  "id" : "null",  "level" : "4",  "name" : "",  "parentId" : "MILESTONE", "values": [{  "dataObj" : {       "id" : "null",      "progress" : "0.0"  }, "parent" : "MILESTONE", "from": "/Date()/","to": "/Date()/", "customClass" : "ganttGray","label": "Main Task" }]},';

            
            doAssert('testWrapTasks', json, expected);
        }
        
        
        static testMethod void testGetSubmilestoneData() {
            String eName = '';
            
            Milestone1_Milestone__c parent = new Milestone1_Milestone__c();
            parent.Name = 'ParentMilestone';
            
            Milestone1_Milestone__c ms = new Milestone1_Milestone__c();
            ms.Name = eName;
            ms.Parent_Milestone__c = parent.Id;
            
            WrapperClass submilestone = new WrapperClass();
            submilestone.subM.Name = eName;
            
            GanttController c = new GanttController();
            String json = c.getSubmilestoneData(submilestone, 'PARENTID');
            json = json.replaceAll('\\d{13}', '');
            
            String ret = '{  "id" : "null",  "level" : "2",  "isMS" : true,  "desc" : "", "values": [{  "dataObj" : {       "id" : "null",      "progress" : "0.0"  }, "parent" : "PARENTID", "from": "/Date()/","to": "/Date()/", "customClass" : "ganttGray","label": "" }] }, ';

            doAssert('testGetSubmilestoneData', json, ret);
        }
    
        static testMethod void testGetMilestoneData()
        {
            String eName = '';
            
            Milestone1_Milestone__c ms = new Milestone1_Milestone__c();
            ms.Name = eName;
            
            WrapperClass milestone = new WrapperClass();
            milestone.subM.Name = eName;

            GanttController c = new GanttController();

            String json = c.getMilestoneData(milestone);
            json = json.replaceAll('\\d{13}', ''); 
            
            String ret = '{  "level" : "1",  "id" : "null", "isMS" : true,  "desc" : "", "values": [{  "dataObj" : {       "id" : "null",      "progress" : "0.0"  }, "parent" : "", "from": "/Date()/","to": "/Date()/", "customClass" : "ganttGray","label": "" }] }, ';
            
            ret = ret.replaceAll('\\d{13}', ''); 

            doAssert('testGetMilestoneData', json, ret);
        }
    
        static testMethod void testGetTaskData() {
            String eTaskName = '';
            String eLevel = '2';
            double eProgress = 20;
            
            Milestone1_Task__c task = new Milestone1_Task__c();
            task.Name = eTaskName;
            task.Progress__c = eProgress;
            
            GanttController c = new GanttController();
            String json = c.getTaskData(task, 1, ''); 
            json = json.replaceAll('\\d{13}', '');           
        
            String ret = '{ "desc" : "",  "id" : "null",  "level" : "2",  "name" : "",  "parentId" : "", "values": [{  "dataObj" : {       "id" : "null",      "progress" : "20.0"  }, "parent" : "", "from": "/Date()/","to": "/Date()/", "customClass" : "ganttGray","label": "" }]}'; 
        
            ret = ret.replaceAll('\\d{13}', '');

            doAssert('getTaskData', json, ret);
               
        }

        
        
        static testMethod void testEscape()
        {
            GanttController c = new GanttController();
            String original = 'Hello "World"!';
            String result = c.escapeDoubleQuotes(original);
            
            String expected = 'Hello \\"World\\"!';
            
            System.assert(stringEquals(result, expected), 'escaped: ' + result + ', ' + expected);
        }
        
        
        static boolean stringEquals(String a, String b) {
            return (a == b);
        }
 
        static String formatExpected(String methodName, String result, String expected)
        {
            return '[' +methodName + ']\nResult: [\n' + result + '\n]\nExpected: [\n' + expected + '\n]';
        }
        
        static void doAssert(String methodName, String result, String expected)
        {
            System.assert(stringEquals(result, expected), formatExpected(methodName, result, expected));
        }
  
  
    }