/**
	updated by Jia Hu on 2013/11/08
	
 */
@isTest(SeeAllData=false) 
private class RFA_AP01UTIl_PdfGeneratorUtil_Test {

    static testMethod void myUnitTest() {
    	/*
        // TO DO: implement unit test
 		String rt = RFAConstants.getRecordType('General Request', 'RFA__c');
    	
        RFA__c testRFA = new RFA__c();
    	testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
    	testRFA.RecordTypeId = 	rt;
    	
    	testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
    	//testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
    	testRFA.Stage__c = 'Draft';
    	insert testRFA;
    	*/
    	
    	//RFA__c testRFA = RFATestData.buildRFACapital();
    	RFA__c testRFA = RFATestData.buildRFAGeneral();
    	
        RFA_AP01UTIl_PdfGeneratorUtil.savePDF(testRFA.Id);
    }
}