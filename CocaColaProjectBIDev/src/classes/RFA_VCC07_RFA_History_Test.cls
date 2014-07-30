/**
	updated by Jia Hu on 2013/11/08
 */
//@isTest(SeeAllData=true )
@isTest(SeeAllData=false) 
private class RFA_VCC07_RFA_History_Test {

    static testMethod void myUnitTest() {
    	/*
        // TO DO: implement unit test
        String rt = RFAConstants.getRecordType('Capital Project Request', 'RFA__c');
        
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        testRFA.RecordTypeId =  rt;
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        testRFA.Stage__c = 'Draft';
        insert testRFA;
        
        testRFA.Approver_Name__c = 'test';
        update testRFA;
        */
        
        RFA__c testRFA = RFATestData.buildRFACapital();
        
        RFA__History RfaHist = new RFA__History();
        
        /*
        Capital_Expenditure__c CapEx = new Capital_Expenditure__c();
        CapEx.Amount__c = 1234567;
        CapEx.RFA__c = testRFA.Id;
        insert CapEx;
        */
        
        PageReference pg = Page.RFA_VFP07_DetailsAsPDF;
        Test.setCurrentPage(pg);   
        ApexPages.Standardcontroller stdController1 = new ApexPages.Standardcontroller(testRFA);
        RFA_VCC07_RFA_History cnrt = new RFA_VCC07_RFA_History();
        RFA_VCC07_RFA_History.RFAObjectHistory InnerClass = new RFA_VCC07_RFA_History.RFAObjectHistory(RfaHist);
        RFA_VCC07_RFA_History.RFAObjectHistory InnerClass2 = new RFA_VCC07_RFA_History.RFAObjectHistory();
        cnrt.getRFAObjectHistory(testRFA.Id);
        cnrt.showMore();
        InnerClass.getActionFormat();
       // InnerClass.RFAObjectHistory();
    }
    
}