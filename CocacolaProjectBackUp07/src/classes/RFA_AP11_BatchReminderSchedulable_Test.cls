/**
	updated by Jia Hu on 2013/11/08
 */
//@isTest(SeeAllData=true)
@isTest(SeeAllData=false) 
private class RFA_AP11_BatchReminderSchedulable_Test {

    static testMethod void testBatchReminder() {
    	// TO DO: implement unit test
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();
        Map<String, List<RFAUserRole__c>> approverLevelMap = new Map<String, List<RFAUserRole__c>>();
    	RFATestData testData = new RFATestData();
    	
    	//testData.buildProfitCenter();
    	testData.createRequester();
    	
    	//String rt = RFAGlobalConstants.RECORDTYPESMAP.get(
    	//	Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
    	
    	RFA__c testRFA;
    	
    	//System.runAs(RFATestData.requester)
    	//{
    		//updated by Jia Hu on 2013/11/12
    		//testRFA = RFATestData.buildTestRFA(testRFA, rt);
    		testRFA = RFATestData.buildRFACapital();
    		
    		
    	//}
    	
    	/*
    	User approver1 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app1', 'app1');
    	
    	User approver2 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app2', 'app2');
    	
    	RFAUserRole__c rfaApprover1 = RFATestData.buildApprover(testRFA.Id, approver1
    		//, 'CCEJ'
    		);//CCEJ
    	RFAUserRole__c rfaApprover2 = RFATestData.buildApprover(testRFA.Id, approver2
    		//, 'CCEJ'
    		); //1. Key Operations
    	*/	
    	
    	//removed by Jia Hu on 2013/11/12	
    	//approverLevelMap.put('CCEJ', new List<RFAUserRole__c>{rfaApprover1, rfaApprover2}); //1. Key Operations
    	//insert approverlevelMap.get('CCEJ'); //1. Key Operations
    	
    	/*
    	System.runAs(RFATestData.levelLCUserMap.get('CCEJ')) //1. Key Operations
    	{
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
    	}
    	*/
    	
    	//Test.StartTest();
    	
    	RFA_BatchReminder__c reminder = new RFA_BatchReminder__c();
    	reminder.Name = 'Approval Reminder';
    	reminder.ReminderThreshold__c = '3';
    	insert reminder;
    	
    	String jobId = System.schedule('testBatchReminderApex',
        	RFA_AP11_BatchReminderSchedulable.CRON_EXP, 
        	new RFA_AP11_BatchReminderSchedulable());
        
        
    	String queryString = 'Select Agent1__c, Agent2__c, Agent3__c, UserName__c, RFA__c, ApprovalProcess__c FROM RFAUserRole__c WHERE' + ' ';
    	queryString = queryString + 'RecordType.Name=' +'\'' + RFAConstants.RTLabel_RFAUserRole_Approver + '\'';
    	queryString = queryString + ' ' + 'AND ApprovalRecommendation__c=' + '\'' 
    		+ RFAConstants.ApproverRecommend_AwaitingApproval
    		//RFAGlobalConstants.PROCESS_PENDING_RECOMMENDATION 
    		+ '\'';
    	queryString = queryString + ' ' + 'ORDER BY UserName__c LIMIT 20';	
    	
    	RFA_AP10_BatchReminder batchReminder = new RFA_AP10_BatchReminder(queryString);
    	database.executebatch(batchReminder);              
    	
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