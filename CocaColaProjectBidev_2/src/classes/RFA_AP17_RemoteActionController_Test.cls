/**
	updated by Jia Hu on 2013/11/08
 */
//@isTest(SeeAllData=true)
@isTest(SeeAllData=false) 
private class RFA_AP17_RemoteActionController_Test {

    static testMethod void sendRFAToKeyOpsCoordinator() {
    	/*
        RFATestData testData = new RFATestData();
        //testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAConstants.getRecordType('Capital Project Request', 'RFA__c');
        RFA__c testRFA; 
        Test.startTest();
        System.runAs(RFATestData.requester)
        {
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
            RFATestData.updateThreeYearCashSpentForRFA(testRFA, 1200);
            RFATestData.updateCapitalExpenditure(testRFA, 1200);            
        }
        */
        
        RFA__c testRFA = RFATestData.buildRFACapital();
        
        RFA_AP17_RemoteActionController.performAction(testRFA.Id, 'Send to Coordinator'); 
        //should change to Send to Coordinator
        
        RFA__c validateRFA = [Select 
        	//Level__c, 
        	Stage__c FROM RFA__c WHERE Id = : testRFA.Id];
        
        //System.assertEquals('CCEJ', validateRFA.Level__c);//1. Key Operations
        
    }
  
	/*  
    static testMethod void sendRFAToBusinessUnitCoordinator() {
        RFATestData testData = new RFATestData();
        //testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAConstants.getRecordType('Capital Project Request', 'RFA__c');
        RFA__c testRFA; 
        Test.startTest();
        System.runAs(RFATestData.requester)
        {
            testRFA = new RFA__c();
            testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA.RecordTypeId =  rt;
            testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
            //testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA.Stage__c = 'Pre-Circulation';
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
            RFATestData.updateThreeYearCashSpentForRFA(testRFA, 1200);
            RFATestData.updateCapitalExpenditure(testRFA, 1200);
            
        }
        
        RFA_AP17_RemoteActionController.performAction(testRFA.Id, 'Send to Business Unit Coordinator');
        
        RFA__c validateRFA = [Select Level__c, Stage__c FROM RFA__c WHERE Id = : testRFA.Id];
        
        System.assertEquals('2. Business Unit', validateRFA.Level__c);
        
    }
    
    static testMethod void sendRFAToGroupCoordinator() {
        RFATestData testData = new RFATestData();
        //testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAConstants.getRecordType('Capital Project Request', 'RFA__c');
        RFA__c testRFA; 
        Test.startTest();
        System.runAs(RFATestData.requester)
        {
            testRFA = new RFA__c();
            testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA.RecordTypeId =  rt;
            testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
            //testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA.Stage__c = 'Pre-Circulation';
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
            RFATestData.updateThreeYearCashSpentForRFA(testRFA, 1200);
            RFATestData.updateCapitalExpenditure(testRFA, 1200);
            
        }
        
        RFA_AP17_RemoteActionController.performAction(testRFA.Id, 'Send to Group Coordinator');
        
        RFA__c validateRFA = [Select Level__c, Stage__c FROM RFA__c WHERE Id = : testRFA.Id];
        
        System.assertEquals('3. Group', validateRFA.Level__c);
        
    }
    
    static testMethod void sendRFAToCorpCoordinator() {
        RFATestData testData = new RFATestData();
        //testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAConstants.getRecordType('Capital Project Request', 'RFA__c');
        RFA__c testRFA; 
        Test.startTest();
        System.runAs(RFATestData.requester)
        {
            testRFA = new RFA__c();
            testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA.RecordTypeId =  rt;
            testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
            //testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA.Stage__c = 'Pre-Circulation';
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
            RFATestData.updateThreeYearCashSpentForRFA(testRFA, 1200);
            RFATestData.updateCapitalExpenditure(testRFA, 1200);
            
        }
        
        RFA_AP17_RemoteActionController.performAction(testRFA.Id, 'Send to Corporate Coordinator');
        
        RFA__c validateRFA = [Select Level__c, Stage__c FROM RFA__c WHERE Id = : testRFA.Id];
        
        System.assertEquals('4. Corporate', validateRFA.Level__c);
        
    }
    
    static testMethod void sendRFAToExecCoordinator() {
        RFATestData testData = new RFATestData();
        //testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAConstants.getRecordType('Capital Project Request', 'RFA__c');
        RFA__c testRFA; 
        Test.startTest();
        System.runAs(RFATestData.requester)
        {
            testRFA = new RFA__c();
            testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA.RecordTypeId =  rt;
            testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
            //testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA.Stage__c = 'Pre-Circulation';
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
            RFATestData.updateThreeYearCashSpentForRFA(testRFA, 1200);
            RFATestData.updateCapitalExpenditure(testRFA, 1200);
            
        }
        
        RFA_AP17_RemoteActionController.performAction(testRFA.Id, 'Send to Executive Coordinator');
        
        RFA__c validateRFA = [Select Level__c, Stage__c FROM RFA__c WHERE Id = : testRFA.Id];
        
        System.assertEquals('5. Executive', validateRFA.Level__c);
        
    }
    
    static testMethod void sendRFAToSrExecCoordinator() {
        RFATestData testData = new RFATestData();
        //testData.buildProfitCenter();
        testData.createRequester();
        String rt = RFAConstants.getRecordType('Capital Project Request', 'RFA__c');
        RFA__c testRFA; 
        Test.startTest();
        System.runAs(RFATestData.requester)
        {
            testRFA = new RFA__c();
            testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
            testRFA.RecordTypeId =  rt;
            testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
            //testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
            testRFA.Stage__c = 'Pre-Circulation';
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
            RFATestData.updateThreeYearCashSpentForRFA(testRFA, 1200);
            RFATestData.updateCapitalExpenditure(testRFA, 1200);
            
        }
        
        RFA_AP17_RemoteActionController.performAction(testRFA.Id, 'Send to Senior Executive Coordinator');
        
        RFA__c validateRFA = [Select Level__c, Stage__c FROM RFA__c WHERE Id = : testRFA.Id];
        
        System.assertEquals('6. Senior Executive', validateRFA.Level__c); 
        
    }
    */
}