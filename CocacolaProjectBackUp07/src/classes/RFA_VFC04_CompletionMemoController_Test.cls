/**
	updated by Jia Hu on 2013/11/08
 */
//@isTest(SeeAllData=true)
@isTest(SeeAllData=false) 
private class RFA_VFC04_CompletionMemoController_Test
{

    static testmethod void RFA_VFC04_Completion_Test()
    {
    	/*
    	RFATestData testData = new RFATestData();
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
    	
    	RFA__c testRFA = RFATestData.buildRFACapital();
    	
    	ApexPages.Standardcontroller stdController1 
    		= new ApexPages.Standardcontroller(testRFA);
    	RFA_VFC04_CompletionMemoController controller1 
    		= new RFA_VFC04_CompletionMemoController(stdController1);
    		
    	List<SelectOption> options = controller1.getSelectableUsers();
    	
    	controller1.selectedRecipients.add(options[0]);
    	controller1.selectedCCusers = 'test@coke.com';
    	controller1.rfaObj.Thefollowingitem__c 
    		= 'Key Operation level for approval and/or for information only as required';
    	controller1.rfaObj.Theapprovalstatusofyourrequestis__c = RFAConstants.ApproverRecommend_UnconditionalApproved; //'Unconditionally Approved';
    	controller1.rfaObj.CommentsConditions__c = 'This is for the purpose of testing';
    	controller1.rfaObj.ApprovalLetterComments__c 
    		= 'The requesting party must ensure appropriate coordination with the above approver(s) to fully address any and all approval conditions. Any failure to fully address these conditions will be subject to Audit review.';
    	controller1.sendEmail();
    
    }

}