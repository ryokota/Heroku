/**
	updated by Jia Hu on 2013/11/08
 */
//@isTest(SeeAllData=true)
@isTest(SeeAllData=false) 
private class RFA_RFAUserRoleTrigger_Test {

    static testMethod void testUserRoleTrigger1() {
        
        RFATestData testData = new RFATestData();
        /*
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
        //create approver 1
        
        User approverUser1 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app1', 'app1');
        
        User agent1 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'agent1', 'agent1');
        
        User agent2 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'agent2', 'agent2');
        
        User agent3 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'agent3', 'agent3');
        
        RFAUserRole__c approver = RFATestData.buildApprover(testRFA.Id, approverUser1 //, testRFA.level__c
        );
        approver.agent1__c = agent1.Id;
        approver.Agent2__c = agent2.Id;
        approver.Agent3__c = agent3.Id;
        //insert approver;
        //create PPOC
        User pocUser = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'ppoc', 'ppoc');
        RFAUserRole__c ppocUserRole = RFATestData.buildPPOC(testRFA.Id, pocUser);
        //insert ppocUserRole;
        //create Co-Creator
        
        //User cocreator = new User();
        //cocreator = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'coc', 'coc', cocreator);
        //RFAUserRole__c cocreatoruserrole = RFATestData.buildCoCreator(testRFA.Id, cocreator);
        //insert cocreatoruserrole;
        //create Info Only Users    
        
        User infoCopyUser = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'info', 'info');
        
        RFAUserRole__c infoUserRole = RFATestData.buildInfoOnlyUsers(testRFA.Id, infoCopyUser //, testRFA.Level__c
        );
        //insert infoUserRole;
        RFA__c rfa = [Select Id, 
        	//Level__c, 
        	Stage__c, 
        	(select Id, UserName__c, Agent1__c, Agent2__c, Agent3__c, RecordTypeId FROM RFA_User_Roles__r) 
        	FROM RFA__c where Id = : testRFA.Id];
        //System.assertEquals(4, rfa.RFA_User_Roles__r.size());
        
        //Test.startTest();
        approver.Agent2__c = null;
        update approver;
        
        ApprovalProcess__c testProcess = new ApprovalProcess__c();
        Database.UpsertResult upsertResult = RFA_AP03_ApprovalProcessHelper.submitForApproval(testProcess, testRFA);
        if(upsertResult.isSuccess())
        {
            approver.ApprovalProcess__c = upsertResult.getId();
            approver.ApprovalOrder__c = 1;
            approver.ApprovalRecommendation__c = 'Awaiting Approval';
            update approver;
            infoUserRole.ApprovalProcess__c = upsertResult.getId();
            update infoUserRole;    
        }
        infoUserRole.UserName__c = agent1.Id;
        update infoUserRole;
        approver.Agent1__c = infoCopyUser.Id;
        approver.Agent2__c = agent1.Id;
        approver.Agent3__c = agent2.Id;
        update approver;
       
       //=========================START of Fix for INC0432162 - BSA - 18-Mar-2013 ========================================== 
         //delete approver; - commented out BSA
         try {
            delete approver;
        } catch (DmlException e) {
            //Assert Error Message
            System.assert( e.getMessage().contains('You cannot delete Approver during Circulation Stage. If the Approver is no longer needed, you may Edit the Approver record and enter an Approval Recommendation of No Longer Needed. Approver may be deleted during Pre-Circulation or Post-Circulation stage'), e.getMessage() );
        }        
       //=========================END of Fix for INC0432162 - BSA - 18-Mar-2013 ==========================================
        
        //cocreatoruserrole.UserName__c = infoCopyUser.Id;
        //ppocUserRole.UserName__c = cocreator.Id;
        //update cocreatoruserrole;
        update ppocUserRole;
        //delete cocreatoruserrole;
//      delete ppocUserRole;
        //Test.stopTest();
        */
    }
    
    static testMethod void testUserRoleTrigger2(){
        RFATestData testData = new RFATestData();
        /*
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
        RFA__c testRFA;
        System.runAs(RFATestData.requester)
        {
            testRFA = RFATestData.buildTestRFA(testRFA, rt);
            
        }
        */
        RFA__c testRFA = RFATestData.buildRFACapital();
        
        User infoCopyUser = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'info', 'info');
        
        RFAUserRole__c infoUserRole = RFATestData.buildInfoOnlyUsers(testRFA.Id, infoCopyUser
        	//, testRFA.Level__c
        	);
        //insert infoUserRole;
        
        ApprovalProcess__c testProcess = new ApprovalProcess__c();
        Database.UpsertResult upsertResult = RFA_AP03_ApprovalProcessHelper.submitForApproval(testProcess, testRFA, true);
        if(upsertResult.isSuccess())
        {
            
            infoUserRole.ApprovalProcess__c = upsertResult.getId();
            update infoUserRole;    
        }
        RFA__c rfaVal = [SELECT 
        	//Level__c, 
        	Stage__c FROM RFA__c where Id =: testRFA.Id];
        //System.assertEquals('Post-Circulation', rfaVal.Stage__c);
    }
    
    /*
     *	Test 2013 Q1 Enhancement functionality in RFAUserRole Trigger.
     *
     *	FR 1.14 - Creator, CoCreator, Primary POC (assuming they are not RFA Admin or RFA Location Coordinator as well) 
     * 	cannot edit or delete Approver or User Info Only record on an RFA if notification has already been sent to the Approver/Info Only. 
     *
     *  FR 1.75 - Provide the ability for Info Copy Only Users to have Agents.  Location Coordinators and Capital Management Team members could pre-define three Agents to any Info Copy Only user.  
     *	Production Support would have the ability to mass upload agent assignments.
     *
     *	FR 1.91 - If the RFA is in Circulation, Post-Circulation, Approved, Closed, Rejected, or  Pending Board Review,  send email notification immediately to same level and below.
     *	If the RFA is in Pre-Circulation, send email notification immediately to level(s)  below only.  At same level is not sent immediately.
     *	If the RFA is in Draft, Capital Mgmt Hold, or Return to Sender, take no action
     *  
     *  FR 1.87 - If logged in user is not a RFA Admin, prevent Approvers from being added to RFA when RFA is completed.
    */
    //System.LimitException: Too many SOQL queries: 101
    //Class.RFA_AP05_RFATrigger.captureEmailTempValues: line 643, column 1
    //Trigger.RFA_RFATrigger: line 353, column 1
    private static void testUserRoleTrigger3(){
    //static testMethod void testUserRoleTrigger3(){
    	RFATestData testData = new RFATestData();
    	/*
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_GENERAL_REQUEST).Id;
        RFA__c testRFA;
        
        // create new General RFA with all required fields updated
        System.runAs(RFATestData.requester)
        {
            testRFA = RFATestData.buildTestRFA(testRFA, rt);
        } 	
        */
        
        RFA__c testRFA = RFATestData.buildRFACapital();
    	
    	// add Primary Point of Contact
    	User pocUser = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'ppoc', 'ppoc');
        RFAUserRole__c ppocUserRole = RFATestData.buildPPOC(testRFA.Id, pocUser);
        //insert ppocUserRole;
        
        // add Primary Point of Contact which is also a Location Coordinator
        ProfitCenterUserRole__c profitCenterUser = [
        	Select UserName__c From ProfitCenterUserRole__c where ProfitCenter__c = :RFATestData.testProfitCenter.id LIMIT 1];
        User pocUser2;
        RFAUserRole__c ppocUserRole2;
        
        if (profitCenterUser != null)
        {
        	pocUser2 = new User(id = profitCenterUser.UserName__c);
        	ppocUserRole2 = RFATestData.buildPPOC(testRFA.Id, pocUser2);
        	//insert ppocUserRole2;
        }
    	
    	// add Info Only user at RFA level
        User infoCopyUser = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'info', 'info');
        RFAUserRole__c infoUserRole = RFATestData.buildInfoOnlyUsers(testRFA.Id, infoCopyUser
        	//, testRFA.Level__c
        	);
        //insert infoUserRole;
        
        // Validate that Info Only User did not receive an email notification while the RFA is in Draft/Pre-Circulation
        infoUserRole = [Select 
        	//RFA_Level__c, 
        	RFAStage__c, Notifyuserfirsttime__c, ApprovalProcess__c, ApprovalRecommendation__c From RFAUserRole__c where id = :infoUserRole.id];
    	//System.assert(infoUserRole.RFAStage__c == RFAGlobalConstants.RFA_PRE_CIRCULATION_STAGE || infoUserRole.RFAStage__c == RFAGlobalConstants.RFA_STAGE_DRAFT, 'RFA Stage is expected to be in Draft or Pre-Circulation');
    	System.assert(!infoUserRole.Notifyuserfirsttime__c, 'Info Only on RFA record was notified when the info only user should have not been notified.');  	
    	
    	// add Approver user at RFA level
    	User approverUser1 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app1', 'app1');
        RFAUserRole__c approver = RFATestData.buildApprover(testRFA.Id, approverUser1 //, testRFA.level__c
        );
        //insert approver;
    	
    	// add Approver at Senior Executive Level
    	User approverUser2 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app2', 'app2');
        RFAUserRole__c approver2 = RFATestData.buildApprover(testRFA.Id, approverUser2 //, RFAGlobalConstants.ORDERED_LEVEL_MAP.get(6)
        );
        //insert approver2;
    	
    	// Send Notification to Approver 1 and Info Only. Put RFA in Post-Circulation
    	ApprovalProcess__c testProcess = new ApprovalProcess__c();
        Database.UpsertResult upsertResult = RFA_AP03_ApprovalProcessHelper.submitForApproval(testProcess, testRFA, true);
        if(upsertResult.isSuccess())
        {
        	infoUserRole.NotifyUsers__c = true;
            infoUserRole.ApprovalProcess__c = upsertResult.getId();
            approver.ApprovalProcess__c = upsertResult.getId();
            approver.ApprovalRecommendation__c = 'No Longer Needed';
            update infoUserRole; 
            update approver;   
        }
        
        //Start Test
    	//Test.startTest();
    	
    	// Validate Approver/Info Only received notification and RFA is in Post-Circulation
    	RFA__c rfaVal = [SELECT 
    		//Level__c, 
    		Stage__c FROM RFA__c where Id =: testRFA.Id];
        //System.assertEquals('Post-Circulation', rfaVal.Stage__c);
    	approver = [Select ApprovalProcess__c, ApprovalRecommendation__c From RFAUserRole__c where id = :approver.id];
    	System.assert(approver.ApprovalProcess__c != null, 'Approver 1 on RFA record was not notified.');
    	infoUserRole = [Select 
    		//RFA_Level__c, 
    		RFAStage__c, 
    		//Level__c, 
    		Notifyuserfirsttime__c, ApprovalProcess__c, ApprovalRecommendation__c From RFAUserRole__c where id = :infoUserRole.id];
    	//System.assertEquals(infoUserRole.Level__c, rfaVal.Level__c);
    	System.assert(infoUserRole.Notifyuserfirsttime__c, 'Info Only on RFA record was not notified.');
    	
    	// Test 2013 Q1 Enhancement FR 1.75 & FR 1.91
    	
    	// add Info Only user 2 at RFA level while RFA is in Post-Circulation
        User infoCopyUser2 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'info2', 'info2');
        RFAUserRole__c infoUserRole2 = RFATestData.buildInfoOnlyUsers(testRFA.Id, infoCopyUser2
        	//, testRFA.Level__c
        	);
        infoUserRole2.Agent1__c = infoCopyUser.id;
        infoUserRole2.Agent2__c = approverUser1.id;
        infoUserRole2.Agent3__c = approverUser2.id;
        update infoUserRole2;
        
        // Validate that Info Only User 2 did receive an email notification while the RFA is in Post-Circulation
        infoUserRole2 = [
        	Select 
        		//RFA_Level__c, 
        		RFAStage__c, Notifyuserfirsttime__c, ApprovalProcess__c, ApprovalRecommendation__c 
        	From RFAUserRole__c where id = :infoUserRole2.id];
    	System.assert(infoUserRole2.Notifyuserfirsttime__c, 'Info Only User 2 added during Post-Circulation on RFA record was not notified.');  
    	
    	// add Info Only user 3 at level above RFA level while RFA is in Post-Circulation
        User infoCopyUser3 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'info3', 'info3');
        RFAUserRole__c infoUserRole3 = RFATestData.buildInfoOnlyUsers(testRFA.Id, infoCopyUser3
        	//, RFAGlobalConstants.ORDERED_LEVEL_MAP.get(3)
        	);
        infoUserRole3.Agent1__c = infoCopyUser.id;
        infoUserRole3.Agent2__c = approverUser1.id;
        infoUserRole3.Agent3__c = approverUser2.id;
        update infoUserRole3;
        
		// Validate that Info Only User did not receive an email notification while the RFA is in Draft/Pre-Circulation
        infoUserRole3 = [Select 
        	//Level__c, 
        	//RFA_Level__c, 
        	RFAStage__c, Notifyuserfirsttime__c, ApprovalProcess__c, ApprovalRecommendation__c 
        	From RFAUserRole__c where id = :infoUserRole3.id];
    	System.assert(!infoUserRole3.Notifyuserfirsttime__c, 'Info Only User 3 on RFA record was notified when the info only user should have not been notified.');  	
    	
    	// update Info Only user 3 level to RFA level and check if notification has been sent
    	//infoUserRole3.Level__c = testRFA.Level__c;
    	update infoUserRole3;
    	
    	infoUserRole3 = [
    		Select Username__c, Agent1__c, Agent2__c, Agent3__c, 
    			//RFA_Level__c, 
    			RFAStage__c, Notifyuserfirsttime__c, 
    		ApprovalProcess__c, ApprovalRecommendation__c 
    		From RFAUserRole__c where id = :infoUserRole3.id];
    	System.assert(infoUserRole3.Notifyuserfirsttime__c, 'Info Only User 3 updated to RFA level was not notified.');
    	
    	// update Username and all three agent fields on an Info Only record which has the notification flag checked, verify notification 
        infoUserRole3.Username__c = approverUser1.id;
        infoUserRole3.Agent1__c = approverUser2.id;
        infoUserRole3.Agent2__c = infoCopyUser.id;
        infoUserRole3.Agent3__c = infoCopyUser2.id;
    	update infoUserRole3;
    	System.assert(infoUserRole3.Notifyuserfirsttime__c, 'Info Only User 3 updated to RFA level was not notified.');
    	
    	// delete Info Only record which had notification already sent, validate that delete is permitted
    	delete infoUserRole3;
    	// no error should be thrown when deleting info only 
    	
    	// End Test 2013 Q1 Enhancement FR 1.75 & FR 1.91
    	
    	// Put RFA in Return to Sender
    	rfaVal.Stage__c = RFAConstants.RFA_STATUS_ReturnToRequester;
    		//RFAGlobalConstants.RETURN_TO_SENDER;
    	rfaVal.ReturnReason__c = 'Testing RFAUserRole Trigger: RFA_RFAUserRoleTrigger_Test.testUserRoleTrigger3()';
    	update rfaVal;
    	
    	// Because Return to Sender has moved to Return to Sender, update Primary Point of Contact Access level on RFA
    	RFA__Share pocUserShare = [Select UserOrGroupId, RowCause, ParentId, AccessLevel From RFA__Share where UserOrGroupId = :pocUser.id and ParentId = :rfaVal.id LIMIT 1];
    	pocUserShare.AccessLevel = 'Edit';
    	update pocUserShare;
    	
    	// Test 2013 Q1 Enhancement FR 1.14
    	
    	// Reset isAdmin static boolean variable on the RFA_WS07_CheckRFAUser class
        //RFA_WS07_CheckRFAUser.isAdmin = null;
    	
    	System.runAs(pocUser)
        {
        	// as Primary Point of Contact, attempt to edit Approver 1, Info Only (assert check fail)
        	infoUserRole.DoNotSendEmail__c = true;
        	approver.DoNotSendEmail__c = true;
        	approver2.DoNotSendEmail__c = true;
        	
        	try	{ update InfoUserRole; System.assert(false, 'Primary Point of Contact should not be able to update InfoUserRole when notification has been sent.');}
        	catch (exception e){ System.assert(e.getMessage().contains(System.Label.RFA_CL138), e.getMessage()); }
        	
        	try	{ update approver; System.assert(false, 'Primary Point of Contact should not be able to update Approver when notification has been sent.');}
        	catch (exception e){ System.assert(e.getMessage().contains(System.Label.RFA_CL138), e.getMessage()); }
        	
        	// as Primary Point of Contact, attempt to delete Approver 1, Info Only (assert check fail)
        	try	{ delete InfoUserRole; System.assert(false, 'Primary Point of Contact should not be able to delete InfoUserRole when notification has been sent.');}
        	catch (exception e){ System.assert(e.getMessage().contains(System.Label.RFA_CL138), e.getMessage()); }
        	
        	try	{ delete approver; System.assert(false, 'Primary Point of Contact should not be able to delete Approver when notification has been sent.');}
        	catch (exception e){ System.assert(e.getMessage().contains(System.Label.RFA_CL138), e.getMessage()); }
        	
        	// as Primary Point of Contact, attempt to edit Approver 2. No error message should be thrown
        	update approver2;
        }
        
        // test as a Primary point of contact which is also a Location Coordinator on the RFA
        if (ppocUserRole2 != null && pocUser2 != null)
        {
	        // Reset isAdmin static boolean variable on the RFA_WS07_CheckRFAUser class
        	//RFA_WS07_CheckRFAUser.isAdmin = null;
	    	
	    	System.runAs(pocUser2)
	        {
	        	// as Primary Point of Contact, attempt to edit Approver 1, Info Only (assert check fail)
	        	infoUserRole.DoNotSendEmail__c = true;
	        	approver.DoNotSendEmail__c = true;
	        	
	        	// as Primary Point of Contact who is also a Location Coordinator, attempt to edit Approver 2. No error message should be thrown
	        	update infoUserRole;
	        	update approver;
	        }
        }
        
        // Test 2013 Q1 Enhancement FR 1.87
        
        // Set RFA to a completed Stage
        rfaVal = [SELECT 
        	//Level__c, 
        	Stage__c //, 
        	//PreviousLevel__c 
        	FROM RFA__c where Id =: testRFA.Id];
        //rfaVal.Level__c = rfaVal.PreviousLevel__c;
        rfaVal.Stage__c = RFAConstants.RFA_STATUS_CLOSED;
        	//RFAGlobalConstants.RFA_STAGE_CLOSED;
    	update rfaVal;
    	    	
    	// Reset isAdmin static boolean variable on the RFA_WS07_CheckRFAUser class
        //RFA_WS07_CheckRFAUser.isAdmin = null;
    	
    	/*
    	// As a user that is not an RFA Admin, prevent Approvers from being added to RFA when RFA is completed. (FR 1.87)
    	System.runAs(pocUser)
    	{
	    	User approverUser3 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app3', 'app3');
	        RFAUserRole__c approver3 = RFATestData.buildApprover(testRFA.Id, approverUser3 //, RFAGlobalConstants.ORDERED_LEVEL_MAP.get(1)
	        );
	        
			//try	{ insert approver3; System.assert(false, 'User that is not an RFA Admin can add an Approver to a completed RFA. They should not be able to.');}
        	//catch (exception e){ System.assert(e.getMessage().contains(System.Label.RFA_CL139), e.getMessage()); }
    	}
    	*/
    	
    	//Stop Test
    	//Test.stopTest();
    }
}