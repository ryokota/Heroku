/**
   Updated by Jia Hu on 2013/10/25
 */
//@isTest(SeeAllData=true)
@isTest(SeeAllData=false) 
private class RFA_AP05_RFATriggerTest {

	/*
    static testMethod void testNewRfas()
    {
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();      
        RFATestData testData = new RFATestData();
        
        // start of test
        Test.startTest();
        // Run in context of the creator
        //System.runAs(RFATestData.requester)
        //{
            RFA__c testRFA = RFATestData.buildRFACapital();
            //RFA__c testRFA = RFATestData.buildRFAGeneral();
            
            RFA__Share[] rfaShareRecords = [
                Select parentId, RowCause, UserOrGroupId, AccessLevel 
                From RFA__Share where parentId =: testRFA.Id];
            System.debug('\n rfa share records : ' + rfaShareRecords);
            for(RFA__Share share : rfaShareRecords)
            {
                rfaShareMap.put(share.UserOrGroupId, share);
            }
        //  System.assertEquals(rfaShareMap.get(RFATestData.requester.Id).RowCause, 'KORequestor__c');
            System.assertEquals(testRFA.Stage__c, 'Draft');
            //System.assertEquals(RFATestData.testProfitCenter.MinLevel__c, 'CCEJ');//1. Key Operations
            
                        
            RFATestData.updateThreeYearCashSpentForRFA(testRFA, 1200);
            
            RFATestData.updateCapitalExpenditure(testRFA, 1200);
            
            // move RFA to Key opts pre circulation
            testRFA.RequestAmountFunctionalCurrency__c = 1200;
            //System.debug('\n ARE Functional Currency :' + RFATestData.testARE.Id);
            //testRFA.Functional_Currency__c = RFATestData.testARE.Id;
            testRFA.Stage__c = 'Pre-Circulation';
            //testRFA.Level__c = 'CCEJ';//1. Key Operations
            try{
                update testRFA; 
            }
            catch(DMLException dme)
            {
                System.assert(dme.getDMLMessage(0).contains('Error: Missing or Invalid Data for Required Fields (*)'));
            }

            //create PPOC
            User pocUser = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'ppoc', 'ppoc');
            RFAUserRole__c ppocUserRole = RFATestData.buildPPOC(testRFA.Id, pocUser);
            //insert ppocUserRole;

            
        //}
        
        
        Test.stopTest();
        // end of test
    }*/
    
    
    
    static testMethod void updateRFA()
    {	
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();
        /*
        RFATestData testData = new RFATestData();
        //testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAConstants.getRecordType('Capital Project Request', 'RFA__c');
        RFA__c testRFA; 
        */
        //RFA__c testRFA = RFATestData.buildRFACapital();
        RFA__c testRFA = RFATestData.buildRFAGeneral();
        
        //Test.startTest();
        //System.runAs(RFATestData.requester)
        //{
            //testRFA = RFATestData.buildTestRFA(testRFA, rt);
            System.debug('\n Test RFA Inserted : ' + testRFA);
            //testRFA.Level__c = RFAGlobalConstants.ORDERED_LEVEL_MAP.get(1);
            testRFA.Stage__c = 'Pre-Circulation';
            //update testRFA;
            
        //}
        /*
        RFA__Share[] rfaShareRecords = [
            Select parentId, RowCause, UserOrGroupId, AccessLevel 
            From RFA__Share where parentId =: testRFA.Id];
        System.debug('\n rfa share records : ' + rfaShareRecords);
        for(RFA__Share share : rfaShareRecords)
        {
            rfaShareMap.put(share.UserOrGroupId, share);
        }
        //System.assertEquals('CCEJ', testRFA.Level__c);//1. Key Operations
        //System.assertEquals('Read', rfaShareMap.get(RFATestData.requester.Id).AccessLevel);
        //System.runAs(RFATestData.levelLCUserMap.get(testRFA.Level__c))
        //{
            testRFA.Stage__c = 'Post-Circulation';
            
            update testRFA;
            
            testRFA.Stage__c = RFAConstants.RFA_STATUS_ReturnToRequester; //'Return To Sender';
            try{
                update testRFA; 
            }catch(DMLException dme)
            {
                System.assert(dme.getMessage().contains('Please provide the reason for Return. Return Reason is required when selected level for RFA is Return To Sender'));
                System.debug('\n Error message : ' + dme.getMessage()); 
            }
            testRFA.Stage__c = RFAConstants.RFA_STATUS_ReturnToRequester; //'Return To Sender';
            testRFA.ReturnReason__c = 'test Reason';
            //testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnitSubstitute.Id;
            //testRFA.RecordTypeId = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_GROUP_CONSOLIDATED_PLAN).Id;
            update testRFA;
            
            RFA__c validateRFA1 = [Select Stage__c
            	//PreviousLevel__c, 
            	//level__c 
            	FROM RFA__c where Id = : testRFA.Id];
            //System.assertEquals('Return To Sender', validateRFA1.Level__c);
            
            //System.assertEquals('CCEJ', validateRFA1.PreviousLevel__c);//1. Key Operations
            
            //testRFA.Level__c = RFAGlobalConstants.ORDERED_LEVEL_MAP.get(1);
            //update testRFA;
            //testRFA.Level__c = 'Pending Board Review';
            update testRFA;
            RFA__c validateRFA2 = [Select Stage__c
            	//PreviousLevel__c, 
            	//level__c 
            	FROM RFA__c where Id = : testRFA.Id];
            //System.assertEquals('Pending Board Review', validateRFA2.Level__c);
            //System.assertEquals('CCEJ', validateRFA2.PreviousLevel__c);//1. Key Operations
        //}
        //Test.stopTest();
        */
    }
    
    /* testProfitCenterUpdateOnRFA method tests 2013 Q1 Enhancements FR1.54 and FR1.79
    * FR1.54: The “Send to” button should always reflect the lowest level of available coordinator when the profit center
    * is changed while the RFA is in draft mode.
    *
    * FR1.79: Capital Management has the ability to change the profit center of inflight RFAs.  
    * When the profit center is changed on an inflight RFA, the buttons which reflect the level/stage of the RFA should 
    * reflect the levels available to the newly assigned profit center.   
    */
    static testMethod void testProfitCenterUpdateOnRFA()
    {
    	/*
        Map<String, RFA__Share> rfaShareMap = new Map<String, RFA__Share>();
        RFATestData testData = new RFATestData();
        //testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAConstants.getRecordType('General Request', 'RFA__c');
        
        ProfitCenter__c testPcMinLevelGroup = testData.buildProfitCenterWithMinLevel('PC Min Level 3. Group', 'Label.RFA_CL003');
        ProfitCenter__c testPcMinLevelExec = testData.buildProfitCenterWithMinLevel('PC Min Level 5. Executive', 'Label.RFA_CL005');


        RFA__c testRFA;
        
        // start of test
        Test.startTest();

        // build General Request Test RFA
        testRFA = RFATestData.buildTestRFA(testRFA, rt);
        
        //create PPOC
        User pocUser = new User();
        pocUser = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'ppoc', 'ppoc', pocUser);
        RFAUserRole__c ppocUserRole = RFATestData.buildPPOC(testRFA.Id, pocUser);
        insert ppocUserRole;
        
        // Check to make sure RFA Level is at Key Operations Draft
        System.assertEquals(RFAGlobalConstants.ORDERED_LEVEL_MAP.get(1), testRFA.Level__c);
        */
        
        RFA__c testRFA = RFATestData.buildRFACapital();
        //RFA__c testRFA = RFATestData.buildRFAGeneral();
        
        /*
        // Test Profit Center Change while RFA is in Draft. Make sure Level has updated to new profit center min level, 3. Group
        testRFA.Stage__c = RFAGlobalConstants.RFA_STAGE_DRAFT;
        //testRFA.ProfitCenterNumber__c = testPcMinLevelGroup.Id;
        update testRFA;
        */
        
        testRFA = [SELECT id, 
        	//Level__c, 
        	//PreviousLevel__c, 
        	ProfitCenterNumber__c FROM RFA__c WHERE id = :testRFA.id];
        //System.assertEquals(RFAGlobalConstants.ORDERED_LEVEL_MAP.get(3), testRFA.Level__c);
        
        // put RFA back to lower level while RFA is in Draft. Level should get updated to Key Operations.
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        //update testRFA;
        //testRFA = [SELECT id, 
        	//Level__c, 
        	//PreviousLevel__c, 
       // 	ProfitCenterNumber__c FROM RFA__c WHERE id = :testRFA.id];
        //System.assertEquals(RFAGlobalConstants.ORDERED_LEVEL_MAP.get(1), testRFA.Level__c);

        // move RFA to Post-Circulation
        //testRFA.Stage__c = RFAGlobalConstants.POST_CIRCULATION;
        //update testRFA;
        
        // Test Profit Center Change while RFA is in Post-Circulation. Make sure Level has updated to higher profit center min level, 3. Group, and Stage is set to Pre-Circulation.
        //testRFA.ProfitCenterNumber__c = testPcMinLevelGroup.Id;
        //update testRFA;
        //testRFA = [SELECT id, Stage__c, Level__c, 
        	//PreviousLevel__c, 
        //	ProfitCenterNumber__c FROM RFA__c WHERE id = :testRFA.id];
        //System.assertEquals(RFAGlobalConstants.PRE_CIRCULATION, testRFA.Stage__c);
        //System.assertEquals(RFAGlobalConstants.ORDERED_LEVEL_MAP.get(3), testRFA.Level__c);
        
        // move RFA to Pending Board Review
        //testRFA.Level__c = RFAGlobalConstants.PENDING_BOARD_REVIEW;
        //update testRFA;
        
        // Attempt to change RFA profit center to high level, 5. Executive, while the RFA is in Pending Board Review. Previous level should change but not level
        //testRFA.ProfitCenterNumber__c = testPcMinLevelExec.Id;
        //update testRFA;
        //testRFA = [SELECT id, Level__c, 
        	//PreviousLevel__c, 
        //	ProfitCenterNumber__c FROM RFA__c WHERE id = :testRFA.id];
        //System.assertEquals(RFAGlobalConstants.PENDING_BOARD_REVIEW, testRFA.Level__c);
        //System.assertEquals(RFAGlobalConstants.ORDERED_LEVEL_MAP.get(5), testRFA.PreviousLevel__c);
        
        //Test.stopTest();
        // end of test
    }
}