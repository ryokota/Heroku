/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Milestone_Task_Delete_ControllerTest {

    static testMethod void myUnitTest() {
    	Test.startTest();
    	//milestone
        Milestone1_Project__c proObj = new Milestone1_Project__c(Name='testProject');
        insert proObj;
        
        Milestone1_Milestone__c mileObj = new Milestone1_Milestone__c(Name='testMilestone', Project__c = proObj.Id);
        insert mileObj;
        
        Milestone_Task_Delete_Controller.deleteConfirm(mileObj.Id, 'milestone');
        
        
        //task
        Milestone1_Project__c proObj1 = new Milestone1_Project__c(Name='testProject1');
        insert proObj1;
        
        Milestone1_Milestone__c mileObj1 = new Milestone1_Milestone__c(Name='testMilestone1', Project__c = proObj1.Id);
        insert mileObj1;
        
        Milestone1_Task__c taskObj1 = new Milestone1_Task__c(Project_Milestone__c = mileObj1.Id, Name='testTask1');
        insert taskObj1;
        Milestone_Task_Delete_Controller.deleteConfirm(taskObj1.Id, 'task');
        
        Test.stopTest();
    }
}