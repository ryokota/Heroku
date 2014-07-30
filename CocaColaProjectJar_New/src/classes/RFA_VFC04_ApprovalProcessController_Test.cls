/**
	updated by Jia Hu on 2013/11/08
 */
//@isTest(SeeAllData=true)
@isTest(SeeAllData=false) 
private class RFA_VFC04_ApprovalProcessController_Test
{
    static testmethod void RFA_VFC04_ApprovalProcess_Test1()
    {
    	RFATestData testData = new RFATestData();
    	/*
    	testData.buildProfitCenter();
    	testData.createRequester();
    	String rt 
    		= RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
    	RFA__c testRFA;	
    	User approverUser;
    	
    	System.runAs(RFATestData.requester)
    	{
    		testRFA = RFATestData.buildTestRFA(testRFA, rt);
    		
    	}
    	*/
    	/*
    	RFA__c testRFA = RFATestData.buildRFACapital();
    	
    	//System.runAs(RFATestData.levelLCUserMap.get(testRFA.Level__c))
    	//{
    		User approverUser = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app1', 'app1');
    		RFAUserRole__c approver = RFATestData.buildApprover(testRFA.Id, approverUser
    			//, testRFA.level__c
    			);
    		//insert approver;
    		ApprovalProcess__c testProcess = new ApprovalProcess__c();
    		Database.UpsertResult upsertResult = RFA_AP03_ApprovalProcessHelper.submitForApproval(testProcess, testRFA);
    		if(upsertResult.isSuccess())
    		{
    			approver.ApprovalProcess__c = upsertResult.getId();
    			approver.ApprovalOrder__c = 1;
    			approver.ApprovalRecommendation__c = 'Awaiting Approval';
    			update approver;	
    		}
    		RFA__c rfaVsal = [Select Id, 
    			//Level__c, 
    			Stage__c FROM RFA__c where Id =: testRFA.Id];
    		//System.assertEquals('CCEJ', rfaVsal.Level__c);
    		//System.assertEquals('Circulation', rfaVsal.Stage__c);
    	//} 
    	//Test.startTest();
    	ApexPages.Standardcontroller stdController;
    	RFA_VFC04_ApprovalProcessController controller;
    	System.runAs(approverUser)
    	{
    		Map<String, String> urlParams = new Map<String, String>{
    			'Id' => testRFA.Id
    		};
    		Test.setCurrentPage(getPageReference('RFA_VFP02_Override', urlParams));
    		
    		stdController = new ApexPages.Standardcontroller(testRFA);
    		controller = new RFA_VFC04_ApprovalProcessController(stdController);
    		controller.prepareWorkItem();
    		List<SelectOption> recomOptions = controller.recommendationOptions;
    		controller.selectedRecommendation = 'Unconditionally Approved';
    		controller.selectedWorkItem = controller.workItemOptions[0].getValue();
    		
    		
    	}
    	controller.submitRecommendation();
    	ApprovalProcess__c processVal = [
    		Select 
    		//ApprovalProcessLevel__c, 
    		//RFA__r.Level__c, 
    		RFA__r.Stage__c, Status__c FROM ApprovalProcess__c WHERE RFA__c =: testRFA.Id];
    	//System.assertEquals('Completed', processVal.Status__c);
    	//System.assertEquals('CCEJ', processVal.RFA__r.Level__c);
    	//System.assertEquals('Post-Circulation', processVal.RFA__r.Stage__c);  	 
    	//Test.StopTest();
    	
    	*/
    }
    
    /*
    static testmethod void RFA_VFC04_ApprovalProcess_Test2()
    {
    	RFATestData testData = new RFATestData();

    	RFA__c testRFA = RFATestData.buildRFACapital();
    	
    	//System.runAs(RFATestData.levelLCUserMap.get(testRFA.Level__c))
    	//{
    		User approverUser = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app1', 'app1');
    		RFAUserRole__c approver = RFATestData.buildApprover(testRFA.Id, approverUser
    			//, testRFA.level__c
    			);
    		//insert approver;
    		ApprovalProcess__c testProcess = new ApprovalProcess__c();
    		Database.UpsertResult upsertResult = RFA_AP03_ApprovalProcessHelper.submitForApproval(testProcess, testRFA);
    		if(upsertResult.isSuccess())
    		{
    			approver.ApprovalProcess__c = upsertResult.getId();
    			approver.ApprovalOrder__c = 1;
    			approver.ApprovalRecommendation__c = 'Awaiting Approval';
    			update approver;	
    		}
    		RFA__c rfaVsal = [Select Id, 
    			//Level__c, 
    			Stage__c FROM RFA__c where Id =: testRFA.Id];
    		//System.assertEquals('CCEJ', rfaVsal.Level__c); //1. Key Operations
    		//System.assertEquals('Circulation', rfaVsal.Stage__c);
    	//} 
    	//Test.startTest();
    	ApexPages.Standardcontroller stdController;
    	RFA_VFC04_ApprovalProcessController controller;
    	System.runAs(approverUser)
    	{
    		Map<String, String> urlParams = new Map<String, String>{
    			'Id' => testRFA.Id
    		};
    		Test.setCurrentPage(getPageReference('RFA_VFP02_Override', urlParams));
    		
    		stdController = new ApexPages.Standardcontroller(testRFA);
    		controller = new RFA_VFC04_ApprovalProcessController(stdController);
    		controller.prepareWorkItem();
    		List<SelectOption> recomOptions = controller.recommendationOptions;
    		controller.selectedRecommendation = 'Unconditionally Approved';
    		//controller.selectedWorkItem = controller.workItemOptions[0].getValue();
    		
    		
    	}
    	controller.submitRecommendation();
    	ApprovalProcess__c processVal = [
    		Select 
    		//ApprovalProcessLevel__c, 
    		//RFA__r.Level__c, 
    		RFA__r.Stage__c, Status__c FROM ApprovalProcess__c WHERE RFA__c =: testRFA.Id];
    	
    	//Test.StopTest();
    }*/
    
    static PageReference getPageReference(String page, Map<String, String> params) {
        String url = '/apex/'+page+'?';
        for (String param : params.keySet()) {
            url += param + '=' + params.get(param) + '&';
        }
        PageReference p = new PageReference(url);
        return p;
    }

}