@isTest(SeeAllData=false) 
public with sharing class RFA_VFC_RequesterCloseControllerTest {
	
	static testMethod void testCloseRFA1() {
		
		RFA__c testRFA = RFATestData.buildRFAGeneral();
		
    	Map<String, String> urlParams = new Map<String, String>
    	{
    			'Id' => testRFA.Id
    	};		

		Test.setCurrentPageReference(RFATestData.getPageReference('RFA_Requester_Close', urlParams));
		ApexPages.standardController stdController = new ApexPages.Standardcontroller(testRFA);
		RFA_VFC_RequesterCloseController controller = new RFA_VFC_RequesterCloseController(stdController);
		
		controller.selectedLevel = RFAConstants.RFA_STATUS_CLOSED;
			//RFAGlobalConstants.RFA_STAGE_CLOSED;
		controller.currentStage = RFAConstants.RFA_STATUS_ReturnToRequester;
			//RFAGlobalConstants.RETURN_TO_SENDER;
		//controller.hasError = false;
		
		try {
			controller.updateRFA();
		} catch(Exception ex) {
			system.debug('------- Exception: ' + ex);
		}		
	
	}		
	/*
	static testMethod void testCloseRFA2() {
		
		RFA__c testRFA = RFATestData.buildRFAGeneral();
		
    	Map<String, String> urlParams = new Map<String, String>
    	{
    			'Id' => testRFA.Id
    	};		

		Test.setCurrentPageReference(RFATestData.getPageReference('RFA_Requester_Close', urlParams));
		ApexPages.standardController stdController = new ApexPages.Standardcontroller(testRFA);
		RFA_VFC_RequesterCloseController controller = new RFA_VFC_RequesterCloseController(stdController);
		
		List<SelectOption> option = controller.getLevel();	
		
		controller.selectedLevel = RFAConstants.RFA_STATUS_CLOSED;
			//RFAGlobalConstants.RFA_STAGE_CLOSED;
		controller.currentStage = RFAConstants.RFA_STATUS_ReturnToRequester;
			//RFAGlobalConstants.RETURN_TO_SENDER;
		
		try {
			controller.closeReason = 'reason ';
			controller.updateRFA();
		} catch(Exception ex) {
			system.debug('------- Exception: ' + ex);
		}	
		
		
	}*/		
	
	
	
	

}