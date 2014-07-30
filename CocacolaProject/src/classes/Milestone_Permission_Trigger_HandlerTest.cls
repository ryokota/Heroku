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
private class Milestone_Permission_Trigger_HandlerTest {

    static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        Test.startTest();
        //ユーザデータ
    	RFATestData testData = new RFATestData();
    	User userObj = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'ppoc', 'ppoc');
        system.debug('TEST *************' + userObj.Id);
        system.debug('LanguageLocaleKey *************' + userObj.LanguageLocaleKey);
        
        //Projectデータ
        Milestone1_Project__c proObj = new Milestone1_Project__c(Name='testProject');
        insert proObj;
        
        Milestone_Permission__c mp = new Milestone_Permission__c();
        mp.Project__c = proObj.Id;
		mp.UserName__c = userObj.Id;
		mp.ProjectRole__c = 'インフォのみ';
		//mp.Access_Permission__c = '参照のみ';
		insert mp;
		
		Milestone1_Project__Share shareList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel 
													FROM Milestone1_Project__Share 
													WHERE ParentId =: mp.Project__c AND UserOrGroupId = :mp.UserName__c limit 1];
		System.assertEquals('Read', shareList.AccessLevel);
		mp.ProjectRole__c = 'スタッフ';
		//mp.Access_Permission__c = '参照/更新';
		update mp;
		
		shareList = [SELECT Id, ParentId, UserOrGroupId, AccessLevel 
							FROM Milestone1_Project__Share 
							WHERE ParentId =: mp.Project__c AND UserOrGroupId = :mp.UserName__c limit 1];
		System.assertEquals('Edit', shareList.AccessLevel);
		
		delete mp;
		List<Milestone1_Project__Share> shareList2 = [SELECT Id, ParentId, UserOrGroupId, AccessLevel 
													FROM Milestone1_Project__Share 
													WHERE ParentId =: mp.Project__c AND UserOrGroupId = :mp.UserName__c];
		System.assertEquals(0, shareList2.size());
		
		Test.stopTest();
    }
}