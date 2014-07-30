@isTest
public class Test_ChartGVM_ExtensionController {

    static testMethod void testGetTaskStatusForOwners() {        
        Milestone1_Project__c ms = new Milestone1_Project__c();
        ms.Kickoff__c = Date.Today();
        ms.Deadline__c = Date.Today()+10;
        insert ms;

        List<Milestone1_Project__c> projects = [SELECT Id FROM Milestone1_Project__c LIMIT 1];
                
        String pid = null;
        Milestone1_Project__c lastProject = null;
        for (Milestone1_Project__c p : projects)
        {
            pid = p.Id;
            lastProject = p;
        }
                
        System.debug('Project ID: ' + pid);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(lastProject);
        Milestone1_ChartGVM_ExtensionController controller = new Milestone1_ChartGVM_ExtensionController(sc);

        controller.getTaskStatusForOwners();

    }

}