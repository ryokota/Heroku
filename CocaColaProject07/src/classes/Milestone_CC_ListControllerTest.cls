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
private class Milestone_CC_ListControllerTest {

    static testMethod void myUnitTest() {
    	Test.startTest();
    	RFATestData testData = new RFATestData();
    	User userObj = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'ppoc', 'ppoc');
        system.debug('TEST *************' + userObj.Id);
        system.debug('LanguageLocaleKey *************' + userObj.LanguageLocaleKey);
        
        Milestone1_Project__c proObj = new Milestone1_Project__c(Name='testProject');
        insert proObj;
        
        Milestone1_Milestone__c mileObj = new Milestone1_Milestone__c(Name='testMilestone', Project__c = proObj.Id);
        insert mileObj;
        
        Milestone1_Task__c taskObj = new Milestone1_Task__c();
        taskObj.Name = 'Test_TASK';
        taskObj.Assigned_To__c = userObj.Id;
        taskObj.Project_Milestone__c = mileObj.Id;
        insert taskObj;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(taskObj);
        Milestone_CC_ListController cont = new Milestone_CC_ListController(sc);
        
        //System.assertEquals(cont.ccList.get(0).title_name, 'CC ユーザ名');
        
        sc = new ApexPages.StandardController(taskObj);
        Milestone_TaskCC__c ccObj = new Milestone_TaskCC__c();
        ccObj.Task_Id__c = taskObj.Id;
        ccObj.User_Id__c = userObj.Id;
        insert ccObj;
        cont = new Milestone_CC_ListController(sc);
        //system.assertEquals(cont.ccList.get(0).user_name, 'ppoc');
        Test.stopTest();
    }
}