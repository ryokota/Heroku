@isTest(SeeAllData=false) 
public with sharing class RFA_VFC_ApproverListControllerTest {
	
	static testMethod void testApproverList() {
		RFA__c testRFA = RFATestData.buildRFAGeneral();
		
    	Map<String, String> urlParams = new Map<String, String>
    	{
    			'Id' => testRFA.Id
    	};		

		Test.setCurrentPageReference(RFATestData.getPageReference('RFA_Button_ApproverList', urlParams));
		ApexPages.standardController stdController = new ApexPages.Standardcontroller(testRFA);
		RFA_VFC_ApproverListController controller = new RFA_VFC_ApproverListController(stdController);		
		
		controller.empty();
		controller.Beginning();
		controller.Previous();
		controller.Next();
		controller.End();
		controller.getDisablePrevious();
		controller.getDisableNext();
		controller.getTotal_size();
		controller.getPageNumber();
		controller.getTotalPages();
		
	}

}