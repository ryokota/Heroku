/**
	updated by Jia Hu on 2013/11/08
 */
@isTest(SeeAllData=false) 
private class RFA_VC_DeleteNotesAndAttachments_Test {
		
    static testMethod void myUnitTest() {
    	/*
        // TO DO: implement unit test
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        RFATestData rtTest = new RFATestData();
        //rtTest.buildProfitCenter();
        
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        //testRFA.PrimaryReportingUnitNumber__c = RFATestData.testReportingUnit.Id;
        testRFA.Stage__c = 'Draft';
        insert testRFA;
        */
        
        RFA__c testRFACapital = RFATestData.buildRFACapital();
        
        Note n = new Note();
        n.Body = 'Test Note';
        n.Title = 'Test Title';
        n.ParentId = testRFACapital.id;
        
        insert n;

        Blob myBIGblob = Blob.toPdf('TEST STRING');
        Attachment att = new Attachment();
        att.Body = myBIGblob;
        att.Name = 'AttachmentTest';
        att.ParentId = testRFACapital.id;
        
        insert att;

        PageReference pageRef = Page.RFA_VFP_DeleteNotesAndAttachments;
        Test.setCurrentPage(pageRef);
       
      	ApexPages.Standardcontroller stdController1 
      		= new ApexPages.Standardcontroller(testRFACapital);
       	RFA_VC_DeleteNotesAndAttachments controllerObj 
       		= new RFA_VC_DeleteNotesAndAttachments(stdController1);
       	RFA_VC_DeleteNotesAndAttachments.RFAAttachments obj
       		= new RFA_VC_DeleteNotesAndAttachments.RFAAttachments();
       
       
       	RFA_VC_DeleteNotesAndAttachments.RFAAttachments obj1
       		= new RFA_VC_DeleteNotesAndAttachments.RFAAttachments(att,true);
       	RFA_VC_DeleteNotesAndAttachments.RFAAttachments obj2
       		= new RFA_VC_DeleteNotesAndAttachments.RFAAttachments(n,true);
       
       
       	controllerObj.getAttachmentList();
       	controllerObj.getListCount();
       	controllerObj.deleteAttachment();
       	
                  
    }
}