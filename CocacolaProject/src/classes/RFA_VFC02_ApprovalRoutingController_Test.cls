/**
	updated by Jia Hu on 2013/11/08
 */
//@isTest(SeeAllData=true)
@isTest(SeeAllData=false) 
private class RFA_VFC02_ApprovalRoutingController_Test {
	/*
    static testMethod void testSubmitForApproval() {
        // TO DO: implement unit test
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();
        RFATestData testData = new RFATestData();

    	
    	RFA__c testRFA = RFATestData.buildRFACapital();
    	
    	User approver1 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app1', 'app1');
    	
    	User approver2 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app2', 'app2');
    	
    	RFAUserRole__c rfaApprover1 = RFATestData.buildApprover(testRFA.Id, approver1
    		//, 'CCEJ'
    		);
    	RFAUserRole__c rfaApprover2 = RFATestData.buildApprover(testRFA.Id, approver2
    		//, 'CCEJ'
    		);
    	//approverLevelMap.put('CCEJ', new List<RFAUserRole__c>{rfaApprover1, rfaApprover2});
    	//insert approverlevelMap.get('CCEJ');
    	//Test.startTest();
    	//System.runAs(RFATestData.levelLCUserMap.get('CCEJ'))
    	//{
    		Map<String, String> urlParams = new Map<String, String>
    		{
    			'Id' => testRFA.Id
    		};
    		Test.setCurrentPageReference(getPageReference('RFA_VFP03_ApprovalRouting', urlParams));
    		ApexPages.standardController stdController = new ApexPages.Standardcontroller(testRFA);
    		RFA_VFC02_ApprovalRoutingController controller = new RFA_VFC02_ApprovalRoutingController(stdController);
  
    		controller.sequenceList[0].sequence = 1;
    		controller.sequenceList[1].sequence = 1;
    		controller.submitForApproval();
    	//}
    	 RFAUserRole__c[] validateUserRole = [Select UserName__c, ApprovalRecommendation__c, 
    	 	//Level__c, 
    	 	//RFA__r.Level__c, 
    	 	RFA__r.Stage__c 
    	 									  FROM RFAUserRole__c 
    	 									  WHERE RFA__c =: testRFA.Id 
    	 									  AND RecordTypeId =: RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName()).get(RFAConstants.RTLabel_RFAUserRole_Approver).Id];
    	 
    	 //System.assertEquals('CCEJ', validateUserRole[0].RFA__r.Level__c);
    	 System.debug('\n RFA Stage :'+validateUserRole[0].RFA__r.Stage__c);
    	 //System.assertEquals('Circulation', validateUserRole[0].RFA__r.Stage__c);
    	 									  
    	 for(RFAUserRole__c approver : validateUserRole)
    	 {
    	 	//System.assertEquals('Awaiting Approval', approver.ApprovalRecommendation__c);
    	 }	
    	 //Test.stopTest();
    }*/
    
    
    
    
    
     static testMethod void testSubmitForApprovalnegativeCase() {
     	// TO DO: implement unit test
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();
        RFATestData testData = new RFATestData();
        /*
        Map<String, List<RFAUserRole__c>> approverLevelMap = new Map<String, List<RFAUserRole__c>>();
        List<RFAUserRole__c> cocreators = new List<RFAUserRole__c>();
        List<RFAUserRole__c> reviewers = new List<RFAUserRole__c>();
    	RFATestData testData = new RFATestData();
    	testData.buildProfitCenter();
    	testData.createRequester();
    	String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
    	
    	RFA__c testRFA;
    	Test.startTest();
    	System.runAs(RFATestData.requester)
    	{
    		testRFA = RFATestData.buildTestRFA(testRFA, rt);    		    		
    	}
    	*/
    	
    	RFA__c testRFA = RFATestData.buildRFACapital();
    	
    	User approver1 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app1', 'app1');
    	
    	User approver2 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app2', 'app2');
    	
    	RFAUserRole__c rfaApprover1 = RFATestData.buildApprover(testRFA.Id, approver1
    		//, 'CCEJ'
    		);
    	RFAUserRole__c rfaApprover2 = RFATestData.buildApprover(testRFA.Id, approver2
    		//, 'CCEJ'
    		);
    	//approverLevelMap.put('CCEJ', new List<RFAUserRole__c>{rfaApprover1, rfaApprover2});
    	//insert approverlevelMap.get('CCEJ');
    	
    	//System.runAs(RFATestData.levelLCUserMap.get('CCEJ'))
    	//{
    		Map<String, String> urlParams = new Map<String, String>
    		{
    			'Id' => testRFA.Id
    		};
    		Test.setCurrentPageReference(getPageReference('RFA_VFP03_ApprovalRouting', urlParams));
    		ApexPages.standardController stdController = new ApexPages.Standardcontroller(testRFA);
    		RFA_VFC02_ApprovalRoutingController controller = new RFA_VFC02_ApprovalRoutingController(stdController);
    		
    		   		
    		controller.sequenceList[0].sequence = 0;
    		controller.sequenceList[1].sequence = 1;
    		controller.submitForApproval();
    	//}
    	 RFAUserRole__c[] validateUserRole = [Select UserName__c, ApprovalRecommendation__c, 
    	 	//Level__c, 
    	 	//RFA__r.Level__c, 
    	 	RFA__r.Stage__c 
    	 									  FROM RFAUserRole__c 
    	 									  WHERE RFA__c =: testRFA.Id 
    	 									  AND RecordTypeId =: RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName()).get(RFAConstants.RTLabel_RFAUserRole_Approver).Id];
    	 
    	 //System.assertEquals('CCEJ', validateUserRole[0].RFA__r.Level__c);
    	 System.debug('\n RFA Stage :'+validateUserRole[0].RFA__r.Stage__c);
    	 //System.assertEquals('Pre-Circulation', validateUserRole[0].RFA__r.Stage__c);
    	 //Test.stopTest();
     } 
     
     static testMethod void testSubmitForApprovalnegativeCase2() {
     	// TO DO: implement unit test
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();
        RFATestData testData = new RFATestData();
        /*
        Map<String, List<RFAUserRole__c>> approverLevelMap = new Map<String, List<RFAUserRole__c>>();
        List<RFAUserRole__c> cocreators = new List<RFAUserRole__c>();
        List<RFAUserRole__c> reviewers = new List<RFAUserRole__c>();
    	RFATestData testData = new RFATestData();
    	testData.buildProfitCenter();
    	testData.createRequester();
    	String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
    	
    	RFA__c testRFA;
    	Test.startTest();
    	System.runAs(RFATestData.requester)
    	{
    		testRFA = RFATestData.buildTestRFA(testRFA, rt);
    		
    		
    	}
    	*/
    	
    	RFA__c testRFA = RFATestData.buildRFACapital();
    	
    	User approver1 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app1', 'app1');
    	
    	User approver2 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app2', 'app2');
    	
    	RFAUserRole__c rfaApprover1 = RFATestData.buildApprover(testRFA.Id, approver1
    		//, 'CCEJ'
    		);
    	RFAUserRole__c rfaApprover2 = RFATestData.buildApprover(testRFA.Id, approver2
    		//, 'CCEJ'
    		);
    	//approverLevelMap.put('CCEJ', new List<RFAUserRole__c>{rfaApprover1, rfaApprover2});
    	//insert approverlevelMap.get('CCEJ');
    	
    	//System.runAs(RFATestData.levelLCUserMap.get('CCEJ'))
    	//{
    		Map<String, String> urlParams = new Map<String, String>
    		{
    			'Id' => testRFA.Id
    		};
    		Test.setCurrentPageReference(getPageReference('RFA_VFP03_ApprovalRouting', urlParams));
    		ApexPages.standardController stdController = new ApexPages.Standardcontroller(testRFA);
    		RFA_VFC02_ApprovalRoutingController controller = new RFA_VFC02_ApprovalRoutingController(stdController);
    		
    		
    	//*********************** Negative Test Case ************************//
    			RFATestData.updateCapitalExpenditure(testRFA, 200);
    		
    		//*******************************************************************//
    		   		
    		controller.sequenceList[0].sequence = 1;
    		controller.sequenceList[1].sequence = 1;
    		controller.submitForApproval();
    	//}
    	 RFAUserRole__c[] validateUserRole = [Select UserName__c, ApprovalRecommendation__c, 
    	 	//Level__c, 
    	 	//RFA__r.Level__c, 
    	 	RFA__r.Stage__c 
    	 									  FROM RFAUserRole__c 
    	 									  WHERE RFA__c =: testRFA.Id 
    	 									  AND RecordTypeId =: RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName()).get(RFAConstants.RTLabel_RFAUserRole_Approver).Id];
    	 
    	 //System.assertEquals('CCEJ', validateUserRole[0].RFA__r.Level__c); //1. Key Operations
    	 System.debug('\n RFA Stage :'+validateUserRole[0].RFA__r.Stage__c);
    	 //System.assertEquals('Pre-Circulation', validateUserRole[0].RFA__r.Stage__c);
    	 //Test.stopTest();
     }
    
    static PageReference getPageReference(String page, Map<String, String> params) {
        String url = '/apex/'+page+'?';
        for (String param : params.keySet()) {
            url += param + '=' + params.get(param) + '&';
        }
        PageReference p = new PageReference(url);
        return p;
    }
    
    
}