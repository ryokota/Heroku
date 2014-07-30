/**
	updated by Jia Hu on 2013/11/08
 */
//@isTest(SeeAllData=true )
@isTest(SeeAllData=false) 
private class RFA_VCC04_CapitalExpCompCntrlSTDtest {

    static testMethod void myUnitTest() {
    	/*
        // TO DO: implement unit test
        String rt = RFAConstants.getRecordType('Capital Project Request', 'RFA__c');
        
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        testRFA.RecordTypeId =  rt;
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        //testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
        testRFA.Stage__c = 'Draft';
        insert testRFA;
        
        Capital_Expenditure__c CapEx = new Capital_Expenditure__c();
        CapEx.Amount__c = 1234567;
        CapEx.RFA__c = testRFA.Id;
        insert CapEx;
        */
        RFA__c testRFA = RFATestData.buildRFACapital();
        
        PageReference pg = Page.RFA_VFP01_CapitalExpenditure;
        Test.setCurrentPage(pg);   
        RFA_VCC04_CapitalExpComponentContrlSTD cnrt = new RFA_VCC04_CapitalExpComponentContrlSTD();
        
        //need to confirm here
        //cnrt.setRecordRFAId(testRFA.id);
        
        //cnrt.getRFA_Capital_CreationMethod();
        //cnrt.capitalExpenditureList.add(CapEx);
        
        //cnrt.performEdit();
        //cnrt.performCancel();
        
        //???
        //cnrt.performSave();
        
        //ISBillingExtension ib = new ISBillingExtension(mc);    
    }
    
     static testMethod void myUnitTest2() {
     	/*
        // TO DO: implement unit test
        String rt = RFAConstants.getRecordType('Small Project Request', 'RFA__c');
        
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        testRFA.RecordTypeId =  rt;
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        //testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
        testRFA.Stage__c = 'Draft';
        insert testRFA;       
        
        Capital_Expenditure__c CapEx = new Capital_Expenditure__c();
        CapEx.Amount__c = 1234567;
        CapEx.RFA__c = testRFA.Id;
        insert CapEx;
        */
        
        RFA__c testRFA = RFATestData.buildRFACapital();
        
        PageReference pg = Page.RFA_VFP01_CapitalExpenditure;
        Test.setCurrentPage(pg);   
        RFA_VCC04_CapitalExpComponentContrlSTD cnrt = new RFA_VCC04_CapitalExpComponentContrlSTD();
        //
        //cnrt.setRecordRFAId(testRFA.id);
        //cnrt.getRFA_Capital_CreationMethod();
        //cnrt.capitalExpenditureList.add(CapEx);
       
        //cnrt.performEdit();
        //cnrt.performCancel();
        
        //???
        //cnrt.performSave();
        
        //ISBillingExtension ib = new ISBillingExtension(mc);    
    }

    
    
    
}