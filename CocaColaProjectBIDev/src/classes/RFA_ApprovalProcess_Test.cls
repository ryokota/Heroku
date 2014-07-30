/**
	updated by Jia Hu on 2013/11/08
 */
//@isTest(SeeAllData=true)
@isTest(SeeAllData=false) 
private class RFA_ApprovalProcess_Test {

    static testMethod void testSubmitForApproval() {
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();
        RFATestData testData = new RFATestData();
        /*
        Map<String, List<RFAUserRole__c>> approverLevelMap = new Map<String, List<RFAUserRole__c>>();
        List<RFAUserRole__c> cocreators = new List<RFAUserRole__c>();
        List<RFAUserRole__c> reviewers = new List<RFAUserRole__c>();
    	
    	testData.buildProfitCenter();
    	testData.createRequester();
    	String rt = RFAGlobalConstants.RECORDTYPESMAP.get(
    		Schema.Sobjecttype.RFA__c.getName()).get(
    			RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
    	
    	RFA__c testRFA;
    	
    	System.runAs(RFATestData.requester)
    	{
    		testRFA = RFATestData.buildTestRFA(testRFA, rt);
    	}
    	*/
    	
    	/*
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
    	
    	ApprovalProcess__c testProcess = new ApprovalProcess__c();
    	
    	Database.UpsertResult result = RFA_AP03_ApprovalProcessHelper.submitForApproval(testProcess, testRFA);
    	
    	System.assert(result.isSuccess());
    	
    	rfaApprover1.ApprovalRecommendation__c = 'Awaiting Approval';
    	rfaApprover1.ApprovalOrder__c = 1;
    	rfaApprover1.ApprovalProcess__c = result.getId();
    	update rfaApprover1;
    	
    	rfaApprover2.ApprovalRecommendation__c = 'Awaiting Approval';
    	rfaApprover2.ApprovalOrder__c = 1;
    	rfaApprover2.ApprovalProcess__c = result.getId();
    	update rfaApprover2;
    	
    	testRFA.Stage__c = 'Circulation';
    	update testRFA;
    	
    	//Test.startTest();
    	
    	RFA__Share[] rfaShareRecords = [Select parentId, RowCause, UserOrGroupId, AccessLevel 
    		From RFA__Share where parentId =: testRFA.Id];
		System.debug('\n rfa share records :'+rfaShareRecords);
    	for(RFA__Share share : rfaShareRecords)
    	{
    		rfaShareMap.put(share.UserOrGroupId, share);
    	}
    	System.assertEquals('Read', rfaShareMap.get(approver1.Id).AccessLevel);
    	System.assertEquals('Read', rfaShareMap.get(approver2.Id).AccessLevel);
    	
    	rfaApprover1.ApprovalRecommendation__c = 'Unconditionally Approved';
    	update rfaApprover1;
    	
    	rfaApprover2.ApprovalRecommendation__c = 'Unconditionally Approved';
    	update rfaApprover2;
    	
    	*/
    	
    	//Test.stopTest();    	
    }
    
    /*
    static testMethod void testSubmitForApproval2() {
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();
        Map<String, List<RFAUserRole__c>> approverLevelMap = new Map<String, List<RFAUserRole__c>>();
        List<RFAUserRole__c> cocreators = new List<RFAUserRole__c>();
        List<RFAUserRole__c> reviewers = new List<RFAUserRole__c>();
    	RFATestData testData = new RFATestData();
    	testData.buildProfitCenter();
    	testData.createRequester();
    	String rt = RFAGlobalConstants.RECORDTYPESMAP.get(
    		Schema.Sobjecttype.RFA__c.getName()).get(
    			RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
    	
    	RFA__c testRFA;
    	
    	System.runAs(RFATestData.requester)
    	{
    		testRFA = RFATestData.buildTestRFA(testRFA, rt);
    	}
    	
    	User approver1 = new User();
    	approver1 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app1', 'app1', approver1);
    	
    	User approver2 = new User();
    	approver2 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app2', 'app2', approver2);
    	
    	RFAUserRole__c rfaApprover1 = RFATestData.buildApprover(testRFA.Id, approver1
    		//, 'CCEJ'
    		);
    	RFAUserRole__c rfaApprover2 = RFATestData.buildApprover(testRFA.Id, approver2
    		//, 'CCEJ'
    		);
    	approverLevelMap.put('CCEJ', new List<RFAUserRole__c>{rfaApprover1, rfaApprover2});
    	insert approverlevelMap.get('CCEJ');
    	
    	ApprovalProcess__c testProcess = new ApprovalProcess__c();
    	
    	Database.UpsertResult result = RFA_AP03_ApprovalProcessHelper.submitForApproval(testProcess, testRFA);
    	
    	System.assert(result.isSuccess());
    	
    	rfaApprover1.ApprovalRecommendation__c = 'Awaiting Approval';
    	rfaApprover1.ApprovalOrder__c = 1;
    	rfaApprover1.ApprovalProcess__c = result.getId();
    	update rfaApprover1;
    	
    	rfaApprover2.ApprovalRecommendation__c = 'Awaiting Approval';
    	rfaApprover2.ApprovalOrder__c = 2;
    	rfaApprover2.ApprovalProcess__c = result.getId();
    	update rfaApprover2;
    	
    	testRFA.Stage__c = 'Circulation';
    	update testRFA;
    	
    	Test.startTest();
    	
    	RFA__Share[] rfaShareRecords = [
    		Select parentId, RowCause, UserOrGroupId, AccessLevel 
    		From RFA__Share where parentId =: testRFA.Id];
		System.debug('\n rfa share records :'+rfaShareRecords);
    	for(RFA__Share share : rfaShareRecords)
    	{
    		rfaShareMap.put(share.UserOrGroupId, share);
    	}
    	    	
    	
    	rfaApprover1.ApprovalRecommendation__c = 'Unconditionally Approved';
    	update rfaApprover1;
    	
    	rfaApprover2.ApprovalRecommendation__c = 'Unconditionally Approved';
    	update rfaApprover2;
    	
    	Test.stopTest();
    	   	
    }
    */
    
    static testMethod void testDeleteApprover() {
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();
        RFATestData testData = new RFATestData();
        /*
        Map<String, List<RFAUserRole__c>> approverLevelMap = new Map<String, List<RFAUserRole__c>>();
        List<RFAUserRole__c> cocreators = new List<RFAUserRole__c>();
        List<RFAUserRole__c> reviewers = new List<RFAUserRole__c>();    	
    	testData.buildProfitCenter();
    	testData.createRequester();
    	String rt = RFAGlobalConstants.RECORDTYPESMAP.get(
    		Schema.Sobjecttype.RFA__c.getName()).get(
    			RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
    	
    	RFA__c testRFA;
    	
    	System.runAs(RFATestData.requester)
    	{
    		testRFA = RFATestData.buildTestRFA(testRFA, rt);
    	}
    	*/
    	
    	/*
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
    	
    	ApprovalProcess__c testProcess = new ApprovalProcess__c();
    	
    	Database.UpsertResult result = RFA_AP03_ApprovalProcessHelper.submitForApproval(testProcess, testRFA);
    	
    	System.assert(result.isSuccess());
    	
    	rfaApprover1.ApprovalRecommendation__c = 'Awaiting Approval';
    	rfaApprover1.ApprovalOrder__c = 1;
    	rfaApprover1.ApprovalProcess__c = result.getId();
    	update rfaApprover1;
    	
    	rfaApprover2.ApprovalRecommendation__c = 'Awaiting Approval';
    	rfaApprover2.ApprovalOrder__c = 1;
    	rfaApprover2.ApprovalProcess__c = result.getId();
    	update rfaApprover2;
    	
    	testRFA.Stage__c = 'Circulation';
    	update testRFA;
    	
    	//Test.startTest();
    	
    	RFA__Share[] rfaShareRecords = [
    		Select parentId, RowCause, UserOrGroupId, AccessLevel 
    		From RFA__Share where parentId =: testRFA.Id];
		System.debug('\n rfa share records :'+rfaShareRecords);
    	for(RFA__Share share : rfaShareRecords)
    	{
    		rfaShareMap.put(share.UserOrGroupId, share);
    	}
    	System.assertEquals('Read', rfaShareMap.get(approver1.Id).AccessLevel);
    	System.assertEquals('Read', rfaShareMap.get(approver2.Id).AccessLevel);
    	
    	rfaApprover1.ApprovalRecommendation__c = 'Unconditionally Approved';
    	update rfaApprover1;
    	
    	//=========================START of Fix for INC0432162 - BSA - 18-Mar-2013 ==========================================
    	rfaApprover1.ApprovalRecommendation__c = 'No Longer Needed';
    	update rfaApprover2;
    	
    	testRFA.Stage__c = 'Post-Circulation';
    	update testRFA;
    	//=========================END of Fix for INC0432162 - BSA - 18-Mar-2013 ==========================================
    	     	
    	RFA__c rfaValidate = [Select 
    		//Level__c, 
    		Stage__c FROM RFA__c where Id = : testRFA.Id];
    	
    	ApprovalProcess__c processValidate = [
    		Select 
    		//ApprovalProcessLevel__c, 
    		Status__c FROM ApprovalProcess__c where RFA__c =: testRFA.Id];
    	
    	System.assertEquals('Post-Circulation', rfaValidate.Stage__c);
    	
      	//System.assertEquals('Completed', processValidate.status__c);
    	
    	
    	//=========================START of Fix for INC0432162 - BSA - 18-Mar-2013 ==========================================
    	//delete rfaApprover2; - commented out BSA
    		try {
            if (rfaApprover2.RFAStage__c != RFAConstants.RFA_STATUS_CIRCULATION
            	//RFAGlobalConstants.RFA_CIRCULATION_STAGE
            ){
            delete rfaApprover2;
            }
        } catch (DmlException e) {
            //Assert Error Message
            System.assert( e.getMessage().contains('You cannot delete Approver during Circulation Stage'), e.getMessage() );
        }
    	//=========================END of Fix for INC0432162 - BSA - 18-Mar-2013 ==========================================
    	
    	*/
    	
    	//Test.stopTest();
    	
    	
    }
    
    static testMethod void testAddApprover() {
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();
        RFATestData testData = new RFATestData();
        /*
        Map<String, List<RFAUserRole__c>> approverLevelMap = new Map<String, List<RFAUserRole__c>>();
        List<RFAUserRole__c> cocreators = new List<RFAUserRole__c>();
        List<RFAUserRole__c> reviewers = new List<RFAUserRole__c>();
    	
    	testData.buildProfitCenter();
    	testData.createRequester();
    	String rt = RFAGlobalConstants.RECORDTYPESMAP.get(
    		Schema.Sobjecttype.RFA__c.getName()).get(
    		RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
    	
    	RFA__c testRFA;
    	
    	System.runAs(RFATestData.requester)
    	{
    		testRFA = RFATestData.buildTestRFA(testRFA, rt);
    	}
    	*/
    	RFA__c testRFA = RFATestData.buildRFACapital();
    	
    	User approver1 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app1', 'app1');
    	
    	User approver2 =testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app2', 'app2');
    	
    	RFAUserRole__c rfaApprover1 = RFATestData.buildApprover(testRFA.Id, approver1
    		//, 'CCEJ'
    		);
    	//RFAUserRole__c rfaApprover2 = RFATestData.buildApprover(testRFA.Id, approver2, 'CCEJ');
    	//approverLevelMap.put('CCEJ', new List<RFAUserRole__c>{rfaApprover1});
    	//insert approverlevelMap.get('CCEJ');
    	
    	ApprovalProcess__c testProcess = new ApprovalProcess__c();
    	
    	Database.UpsertResult result = RFA_AP03_ApprovalProcessHelper.submitForApproval(testProcess, testRFA);
    	
    	System.assert(result.isSuccess());
    	
    	rfaApprover1.ApprovalRecommendation__c = 'Awaiting Approval';
    	rfaApprover1.ApprovalOrder__c = 1;
    	rfaApprover1.ApprovalProcess__c = result.getId();
    	update rfaApprover1;
    	
    	    	
    	testRFA.Stage__c = 'Circulation';
    	update testRFA;
    	
    	//Test.startTest();
    	
    	RFAUserRole__c rfaApprover2 = RFATestData.buildApprover(testRFA.Id, approver2
    		//, 'CCEJ'
    		);
    	//insert rfaApprover2;
    	
    	//Test.stopTest();
    	
    	
    }
    
    static testMethod void testAddApprover2() {
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();
        RFATestData testData = new RFATestData();
        /*
        Map<String, List<RFAUserRole__c>> approverLevelMap = new Map<String, List<RFAUserRole__c>>();
        List<RFAUserRole__c> cocreators = new List<RFAUserRole__c>();
        List<RFAUserRole__c> reviewers = new List<RFAUserRole__c>();
    	
    	testData.buildProfitCenter();
    	testData.createRequester();
    	String rt = RFAGlobalConstants.RECORDTYPESMAP.get(
    		Schema.Sobjecttype.RFA__c.getName()).get(
    			RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
    	
    	RFA__c testRFA;
    	
    	System.runAs(RFATestData.requester)
    	{
    		testRFA = RFATestData.buildTestRFA(testRFA, rt);
    	}
    	*/
    	//testRFA.Level__c = '2. Business Unit';
    	//update testRFA;
    	
    	RFA__c testRFA = RFATestData.buildRFACapital();
    	
    	User approver1 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app1', 'app1');
    	
    	User approver2 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app2', 'app2');
    	
    	RFAUserRole__c rfaApprover1 = RFATestData.buildApprover(testRFA.Id, approver1
    		//, '2. Business Unit'
    		);
    	
    	//insert rfaApprover1;
    	
    	//Test.startTest();
    	
    	ApprovalProcess__c testProcess = new ApprovalProcess__c();
    	
    	Database.UpsertResult result = RFA_AP03_ApprovalProcessHelper.submitForApproval(testProcess, testRFA);
    	
    	System.assert(result.isSuccess());
    	
    	rfaApprover1.ApprovalRecommendation__c = 'Awaiting Approval';
    	
    	rfaApprover1.ApprovalOrder__c = 1;
    	
    	rfaApprover1.ApprovalProcess__c = result.getId();
    	
    	update rfaApprover1;
    	    	    	
    	testRFA.Stage__c = 'Circulation';
    	
    	update testRFA;
    	
    	RFAUserRole__c rfaApprover2 = RFATestData.buildApprover(testRFA.Id, approver2
    		//, 'CCEJ'
    		); //1. Key Operations
    	
    	//insert rfaApprover2;
    	
    	//Test.stopTest();   	
    	
    }
}