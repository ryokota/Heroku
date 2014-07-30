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
@isTest(SeeAllData=true) 
private class Milestone_BI_ToDoCtrlTest {

    static testMethod void myUnitTest() {
    	Test.startTest();
    	system.debug([SELECT Project__c, UserName__c FROM Milestone_Permission__c limit 1]);
    	Milestone_Permission__c userId = [SELECT Project__c, UserName__c FROM Milestone_Permission__c limit 1];
    	Milestone_BI_ToDoCtrl newObj = new Milestone_BI_ToDoCtrl();
    	newObj.loginUserId = userId.UserName__c;
    	newObj.inputObj.Function__c = 'Test';
    	newObj.inputObj.Due_Date__c = system.today();
    	newObj.inputObj.ToDo__c = 'ToDo';
    	newObj.inputObj.Note__c = 'Note';
    	newObj.inputTag = 'tag1,tag2';
    	newObj.doSave();
    	newObj.doDel();
    	Test.stopTest();
        // TO DO: implement unit test
    }
}