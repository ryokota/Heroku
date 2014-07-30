/*
	updated by Jia Hu on 2013/11/08
	ver 20 -> 29
 */
@isTest(SeeAllData=false) 
private class RFA_WS01_PDFGenerator_TEST 
{
     static testmethod void RFA_AP01_Test()
     {
     	/*
        RFA__c testRFA 
        	= new RFA__c(
        		ProfitCenterNumber__c = RFATestData.testProfitCenter.Id, 
        		RequestTitle__c = 'Capital Project Request RFA Title' 
                //PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id, Stage__c = 'Draft'
              );
        
        insert testRFA;
        */
        
        RFA__c testRFA = RFATestData.buildRFACapital();
        
        //test.StartTest();
        
        RFA_WS01_PDFGenerator.PDFGenerator(testRFA.Id, Userinfo.getSessionId());
      
        //test.stopTest();
     }
}