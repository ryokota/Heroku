/**
	updated by Jia Hu on 2013/11/08
 */
//@isTest(SeeAllData=true)
@isTest(SeeAllData=false) 
private class RFA_VFC05_RFAClosingController_Test
{
  static testmethod void RFA_VFC05_RFATest()
  {
  		/*
  		RFATestData testData = new RFATestData();
    	testData.buildProfitCenter();
    	testData.createRequester();
    	String rt 
    		= RFAGlobalConstants.RECORDTYPESMAP.get(
    			Schema.Sobjecttype.RFA__c.getName()).get(
    				RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST).Id;
    				
    	
    	RFA__c testRFA;
    	
    	System.runAs(RFATestData.requester)
    	{
    		testRFA = RFATestData.buildTestRFA(testRFA, rt);    		
    	}
    	*/
    	
    	//RFA__c testRFA = RFATestData.buildRFACapital();
    	RFA__c testRFA = RFATestData.buildRFAGeneral();
    	
    	//System.runAs(RFATestData.levelLCUserMap.get(testRFA.Level__c))
		//{
			Map<String, String> urlParams = new Map<String, String>
			{
				'Id' => testRFA.Id
			};
			Test.setCurrentPage(getPageReference('RFA_VFP06_RFAClosing', urlParams));
			ApexPages.Standardcontroller stdController1 = new ApexPages.Standardcontroller(testRFA);
			RFA_VFC05_RFAClosingController controller1 = new RFA_VFC05_RFAClosingController(stdController1);
			//controller1.selectedStage = 'Approved';
			/*
			controller1.updateRFA();
			controller1.selectedStage = 'Approved';
			controller1.updateRFA();
			*/
		//}
  
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