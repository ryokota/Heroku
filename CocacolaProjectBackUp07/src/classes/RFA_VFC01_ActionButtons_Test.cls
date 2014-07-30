/**
	updated by Jia Hu on 2013/11/08
 */
//@isTest(SeeAllData=true)
@isTest(SeeAllData=false) 
private class RFA_VFC01_ActionButtons_Test {

    static testMethod void testActionButtonAsRequester() {
        RFATestData testData = new RFATestData();
        //testData.buildProfitCenter();
        //testData.createRequester();
        //String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
        
        //RFA__c testRFA;
        
        //System.runAs(RFATestData.requester)
        //{
        	/*
            testRFA = new RFA__c();
            testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA.RecordTypeId =  rt;
            testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
            //testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA.Stage__c = 'Draft';
            testRFA.RequestAmountFunctionalCurrency__c = 1200;      
            //testRFA.Functional_Currency__c = RFATestData.testARE.Id;
            //testRFA.Stage__c = 'Pre-Circulation';
            testRFA.Level__c = 'Draft';
            testRFA.DataClassification__c = 'Internal Use';
            //testRFA.AREMonth__c = 'February';
            testRFA.InitialBudgetYear__c = '2013';
            testRFA.BudgetType__c = 'Formal';
            testRFA.IsthisanAnnualCapitalPlanrequest__c = 'No';
            //testRFA.ExecutiveSummary__c = 'This is for the purpose of testing';
            //testRFA.PrimaryDOACategorySubCategory__c = '1.A.1   Capital Expenditures - Annual Capital Plan Request or Formal Approval of Annual Capital Plan Request';
            insert testRFA;
            */
            
            RFA__c testRFA = RFATestData.buildRFACapital();
            
            Map<String, String> urlParams = new Map<String, String>{
                'Id'    => testRFA.Id    
            };
            
            Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));
            ApexPages.Standardcontroller stdController = new ApexPages.StandardController(testRFA);
            RFA_VFC01_ActionButtons controller  = new RFA_VFC01_ActionButtons(stdController);
        //}
    }
    
     static testMethod void testActionButtonAsLocalCoordinator1() {
        RFATestData testData = new RFATestData();
        
        //testData.buildProfitCenter();
        //testData.createRequester();
        String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(
        	RFAConstants.RECORDTYPE_SMALL_PROJECT_REQUEST
        	).Id;
        
        RFA__c testRFA;
        
        //System.runAs(RFATestData.requester)
        //{
        	//testRFA = RFATestData.buildRFACapital();
        	testRFA = RFATestData.buildRFAGeneral();
            //testRFA = RFATestData.buildTestRFA(testRFA, rt);
            /*
            Map<String, String> urlParams = new Map<String, String>{
                'Id'    => testRFA.Id    
            };
            
            Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));
            ApexPages.Standardcontroller stdController = new ApexPages.StandardController(testRFA);
            RFA_VFC01_ActionButtons controller  = new RFA_VFC01_ActionButtons(stdController);*/
        //}
        
        
        RFA__c validateRFA = [Select 
        	//Level__c, 
        	//PreviousLevel__c, 
        	Stage__c FROM RFA__c WHERE Id = : testRFA.Id];
        //System.runAs(RFATestData.levelLCUserMap.get(validateRFA.Level__c))
        //{
            Map<String, String> urlParams = new Map<String, String>{
                'Id'    => testRFA.Id    
            };
            Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));
            ApexPages.Standardcontroller stdController = new ApexPages.StandardController(testRFA);
            RFA_VFC01_ActionButtons controller  = new RFA_VFC01_ActionButtons(stdController);   
        //}
    }
    
    static testMethod void testActionButtonAsLocalCoordinator2() {
    	/*
        RFATestData testData = new RFATestData();
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAGlobalConstants.RECORDTYPESMAP.get(
        	Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
        */
        
        RFA__c testRFA;
        
        //System.runAs(RFATestData.requester)
        //{
            //testRFA = RFATestData.buildTestRFA(testRFA, rt);
            testRFA = RFATestData.buildRFACapital();
        //}
        RFA__c validateRFA = [Select 
        	//Level__c, 
        	//PreviousLevel__c, 
        	Stage__c FROM RFA__c WHERE Id = : testRFA.Id];
        //System.runAs(RFATestData.levelLCUserMap.get(validateRFA.Level__c))
        //{
            testRFA.Stage__c = 'Post-Circulation';
            update testRFA;
            
            Map<String, String> urlParams = new Map<String, String>{
                'Id'    => testRFA.Id    
            };
            Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));
            ApexPages.Standardcontroller stdController = new ApexPages.StandardController(testRFA);
            RFA_VFC01_ActionButtons controller  = new RFA_VFC01_ActionButtons(stdController);   
            
        //}
    }
    
    static testMethod void testActionButtonAsAdmin() {
    	/*
        RFATestData testData = new RFATestData();
        testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAGlobalConstants.RECORDTYPESMAP.get(Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
        */
        RFA__c testRFA;
        
        //System.runAs(RFATestData.requester)
        //{
            //testRFA = RFATestData.buildTestRFA(testRFA, rt);
            //testRFA = RFATestData.buildRFACapital();
            testRFA = RFATestData.buildRFAGeneral();
            /*
            Map<String, String> urlParams = new Map<String, String>{
                'Id'    => testRFA.Id    
            };
            
            Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));
            ApexPages.Standardcontroller stdController = new ApexPages.StandardController(testRFA);
            RFA_VFC01_ActionButtons controller  = new RFA_VFC01_ActionButtons(stdController);*/
        //}
        /*
        testRFA.Stage__c = RFAConstants.RFA_STATUS_ReturnToRequester; //'Return To Sender';
        testRFA.ReturnReason__c = 'This is for the purpose of testing';
        update testRFA;     
        
        Map<String, String> urlParams = new Map<String, String>{
            'Id'    => testRFA.Id    
        };
        Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));
        ApexPages.Standardcontroller stdController = new ApexPages.StandardController(testRFA);
        RFA_VFC01_ActionButtons controller  = new RFA_VFC01_ActionButtons(stdController);
        */
        
        /*
        testRFA.Level__c = 'Capital Management Hold';
        update testRFA;
        Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));  
        ApexPages.Standardcontroller stdController1 = new ApexPages.StandardController(testRFA);
        RFA_VFC01_ActionButtons controller1  = new RFA_VFC01_ActionButtons(stdController1);
        
        testRFA.Level__c = 'Pending Board Review';
        update testRFA;
        Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));  
        ApexPages.Standardcontroller stdController2 = new ApexPages.StandardController(testRFA);
        RFA_VFC01_ActionButtons controller2  = new RFA_VFC01_ActionButtons(stdController2);
        
        testRFA.Stage__c = 'Approved';
        update testRFA;
        Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));  
        ApexPages.Standardcontroller stdController3 = new ApexPages.StandardController(testRFA);
        RFA_VFC01_ActionButtons controller3  = new RFA_VFC01_ActionButtons(stdController3);
        */
        
        //Test.startTest();
        
        /*
        testRFA.Level__c = '2. Business Unit';
        testRFA.Stage__c = 'Pre-Circulation';
        update testRFA;
        Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));  
        ApexPages.Standardcontroller stdController4 = new ApexPages.StandardController(testRFA);
        RFA_VFC01_ActionButtons controller4  = new RFA_VFC01_ActionButtons(stdController4);
        
        testRFA.Level__c = '3. Group';
        testRFA.Stage__c = 'Pre-Circulation';
        update testRFA;
        Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));  
        ApexPages.Standardcontroller stdController5 = new ApexPages.StandardController(testRFA);
        RFA_VFC01_ActionButtons controller5  = new RFA_VFC01_ActionButtons(stdController5);
        
        testRFA.Level__c = '4. Corporate';
        testRFA.Stage__c = 'Pre-Circulation';
        update testRFA;
        Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));  
        ApexPages.Standardcontroller stdController6 = new ApexPages.StandardController(testRFA);
        RFA_VFC01_ActionButtons controller6  = new RFA_VFC01_ActionButtons(stdController6);
        
        testRFA.Level__c = '5. Executive';
        testRFA.Stage__c = 'Pre-Circulation';
        update testRFA;
        Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));  
        ApexPages.Standardcontroller stdController7 = new ApexPages.StandardController(testRFA);
        RFA_VFC01_ActionButtons controller7  = new RFA_VFC01_ActionButtons(stdController7);
        
        testRFA.Level__c = '6. Senior Executive';
        testRFA.Stage__c = 'Pre-Circulation';
        update testRFA;
        Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));  
        ApexPages.Standardcontroller stdController8 = new ApexPages.StandardController(testRFA);
        RFA_VFC01_ActionButtons controller8  = new RFA_VFC01_ActionButtons(stdController8);
        */
        //Test.stopTest();
    }
    
    static testMethod void testActionButtonAsAdmin_step2() {
        RFA__c testRFA = RFATestData.buildRFACapital();      
        Map<String, String> urlParams = new Map<String, String>{
            'Id'    => testRFA.Id    
        };
        
        //testRFA.Level__c = 'Capital Management Hold';
        //update testRFA;
        Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));  
        ApexPages.Standardcontroller stdController1 = new ApexPages.StandardController(testRFA);
        RFA_VFC01_ActionButtons controller1  = new RFA_VFC01_ActionButtons(stdController1);
    }    
    
    static testMethod void testActionButtonAsAdmin_step3() {
        RFA__c testRFA = RFATestData.buildRFACapital();      
        Map<String, String> urlParams = new Map<String, String>{
            'Id'    => testRFA.Id    
        };
        //testRFA.Level__c = 'Pending Board Review';
        //update testRFA;
        Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));  
        ApexPages.Standardcontroller stdController2 = new ApexPages.StandardController(testRFA);
        RFA_VFC01_ActionButtons controller2  = new RFA_VFC01_ActionButtons(stdController2);
             
    }        
    /*
    static testMethod void testActionButtonAsAdmin_step4() {
        //RFA__c testRFA = RFATestData.buildRFACapital();    
        RFA__c testRFA = RFATestData.buildRFAGeneral();    
        Map<String, String> urlParams = new Map<String, String>{
            'Id'    => testRFA.Id    
        };
        
        testRFA.Stage__c = 'Approved';
        update testRFA;
        Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));  
        ApexPages.Standardcontroller stdController3 = new ApexPages.StandardController(testRFA);
        RFA_VFC01_ActionButtons controller3  = new RFA_VFC01_ActionButtons(stdController3);      
    }     
    */
    
    /*
    static testMethod void testActionButtonAtCirculaitionStage() {
    	
        RFATestData testData = new RFATestData();
        
        //testData.buildProfitCenter();
        //testData.createRequester();
       // String rt = RFAGlobalConstants.RECORDTYPESMAP.get(
       // 	Schema.Sobjecttype.RFA__c.getName()).get(RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
        
        
        RFA__c testRFA;
        
        //System.runAs(RFATestData.requester)
        //{
            //testRFA = RFATestData.buildTestRFA(testRFA, rt);
            testRFA = RFATestData.buildRFACapital();
            
           // Map<String, String> urlParams = new Map<String, String>{
           //     'Id'    => testRFA.Id    
          //  };
            
          //  Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));
          //  ApexPages.Standardcontroller stdController = new ApexPages.StandardController(testRFA);
          //  RFA_VFC01_ActionButtons controller  = new RFA_VFC01_ActionButtons(stdController);
            
        //}   
        User approver1 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app1', 'app1');
        
        User approver2 = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'app2', 'app2');
        
        RFAUserRole__c rfaApprover1 = RFATestData.buildApprover(testRFA.Id, approver1
        	//, 'CCEJ'
        	);
        RFAUserRole__c rfaApprover2 = RFATestData.buildApprover(testRFA.Id, approver2
        	//, 'CCEJ'
        	);
        //insert rfaApprover2;
        //insert rfaApprover1;
        
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
         RFAUserRole__c[] validateUserRole = [
         	Select UserName__c, ApprovalRecommendation__c, 
         	//Level__c, 
         	//RFA__r.Level__c, 
         	RFA__r.Stage__c 
                                              FROM RFAUserRole__c 
                                              WHERE RFA__c =: testRFA.Id 
                                              AND RecordTypeId =: RFAGlobalConstants.RECORDTYPESMAP.get(Schema.sObjectType.RFAUserRole__c.getName()).get(RFAConstants.RTLabel_RFAUserRole_Approver).Id];
         
         //System.assertEquals('CCEJ', validateUserRole[0].RFA__r.Level__c); //1. Key Operations
         System.debug('\n RFA Stage :'+validateUserRole[0].RFA__r.Stage__c);
         //System.assertEquals('Circulation', validateUserRole[0].RFA__r.Stage__c);
                                              
         for(RFAUserRole__c approver : validateUserRole)
         {
            //System.assertEquals('Awaiting Approval', approver.ApprovalRecommendation__c);
         }
         
         //Map<String, String> urlParams = new Map<String, String>{
         urlParams = new Map<String, String>{	
                'Id'    => testRFA.Id    
         };
         
         System.runAs(approver1)
         {
                        
            Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));
            //ApexPages.Standardcontroller stdController = new ApexPages.StandardController(testRFA);
            stdController = new ApexPages.StandardController(testRFA);
            //RFA_VFC01_ActionButtons controller  = new RFA_VFC01_ActionButtons(stdController);   
            //controller  = new RFA_VFC01_ActionButtons(stdController);   
         }  
         Test.setCurrentPage(getPageReference('RFA_VFP08_ActionButtonTop', urlParams));
         ApexPages.Standardcontroller stdController1 = new ApexPages.StandardController(testRFA);
         RFA_VFC01_ActionButtons controller2  = new RFA_VFC01_ActionButtons(stdController1);
         //Test.stopTest();
        
    }
    */
    
    static PageReference getPageReference(String page, Map<String, String> params) {
        String url = '/apex/'+page+'?';
        for (String param : params.keySet()) {
            url += param + '=' + params.get(param) + '&';
        }
        PageReference p = new PageReference(url);
        return p;
    }
    
}