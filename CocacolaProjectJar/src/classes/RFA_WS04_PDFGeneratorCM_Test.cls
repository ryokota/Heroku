/**
    updated by Jia Hu on 2013/11/12
 */
@isTest(SeeAllData=false) 
public class RFA_WS04_PDFGeneratorCM_Test {
    static testMethod void myUnitTest() {
        /*
        RFATestData testData = new RFATestData();
        String rt = RFAConstants.getRecordType('General Request', 'RFA__c');
        RFA__c testRFA = new RFA__c();
        testRFA.RequestTitle__c = 'testtitle';
        testRFA.DataClassification__c = 'Restricted';
        //testRFA.RequestAmountFunctionalCurrency__c = '10';
        //testRFA.Functional_Currency__c = '100';
        //testRFA.AREMonth__c = 'January';
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        testRFA.RecordTypeId =   rt;
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        testRFA.Stage__c = 'Draft';
        try{
            insert testRFA;
           }
        catch(System.DMLException e) {}


        // POC 
        User testUserPOC = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'ppoc', 'ppoc');
        String utPOC = RFAConstants.getRecordType('Primary Point of Contact', 'RFAUserRole__c');
        RFAUserRole__c TestURPOC = new RFAUserRole__c();
        TestURPOC.UserName__c = testUserPOC.id;
        TestURPOC.RecordTypeId =   utPOC;
        TestURPOC.RFA__c = testRFA.id;
        insert TestURPOC; 

        // Co-Creater 
        User testUserCOC = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'Co-Cre', 'Co-Cre');
        String utCOC = RFAConstants.getRecordType('Co-Creator', 'RFAUserRole__c');
        RFAUserRole__c TestURCOC = new RFAUserRole__c();
        TestURCOC.UserName__c = testUserCOC.id;
        TestURCOC.RecordTypeId =   utCOC;
        TestURCOC.RFA__c = testRFA.id;
        insert TestURCOC; 
        
        // Approver 
        //User testUserApprover = new User();
        //RFATestData.rfaStandardUserProfile  -> RFAConstants.getRFAStandardUserProfileId()
        User testUserApprover = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'Approver', 'Approver');
        String utApp = RFAConstants.getRecordType('Approver', 'RFAUserRole__c');
        RFAUserRole__c TestURApp = new RFAUserRole__c();
        TestURApp.UserName__c = testUserApprover.id;
        TestURApp.RecordTypeId =   utApp;
        TestURApp.Agent1__c = testUserCOC.id;
        TestURApp.RFA__c = testRFA.id;
        insert TestURApp; 
        
        // LOC 
        ProfitCenter__c testProfitCenter = new ProfitCenter__c();
        //testProfitCenter.Business_Unit_Name__c = 'Coca-Cola USA Industries';
        //testProfitCenter.GroupName__c = 'Bottling Investments';
        //testProfitCenter.KeyOperationName__c = 'Coca Cola NA';
        testProfitCenter.ProfitCenterName__c = 'Test Coke PC';
        testProfitCenter.ActiveInactive__c = 'Active';
        insert testProfitCenter;
        
        User testUserLOCA = testData.createUser(RFAConstants.getRFAStandardUserProfileId(), 'LOC', 'LOC');
        
        ProfitCenterUserRole__c PCUR = new ProfitCenterUserRole__c();
        //PCUR.Level__c = 'CCEJ'; //1. Key Operations
        PCUR.ProfitCenter__c = testProfitCenter.id;
        PCUR.UserName__c = testUserLOCA.Id;
        PCUR.UserType__c = 'Coordinator'; //Location Coordinator
        insert PCUR;
        */
        
        //RFA__c testRFA = RFATestData.buildRFACapital();
        RFA__c testRFA = RFATestData.buildRFAGeneral();
        
        testRFA.ToEmailAddressCM__c = 'bisht Sanjeev';
        testRFA.CCEmailAddressCM__c = 'bisht Sanjeev';
        
        //testRFA.POC_Name__c = TestURPOC.UserName__r.Name;
        //testRFA.CO_CREATOR_Name__c = TestURCOC.UserName__r.Name;
        //testRFA.Approver_Name__c = TestURApp.UserName__r.Name;
        //testRFA.Agents_Name__c = TestURApp.Agent1__c;
        //testRFA.LOC_Name__c = PCUR.UserName__r.Name;
        
        testRFA.Thefollowingitem__c = 'Key operation level for Approval and/or for information as requied';
        testRFA.Theapprovalstatusofyourrequestis__c = 'Conditionally Approved';
        testRFA.ApprovalLetterComments__c = 'Not Applicable';
        testRFA.CommentsConditions__c = 'Test';
    
        try{
            update testRFA;
           }
        catch(System.DMLException e) {}
        
    }
        
    static testMethod void testAttachments()
    {
            //RFA__c testRFA = new RFA__c();
            //insert testRFA;
            
            //RFA__c testRFA = RFATestData.buildRFACapital();
            RFA__c testRFA = RFATestData.buildRFAGeneral();
     
            Attachment attach = new Attachment();     
            attach.Name = 'Unit Test Attachment';
            Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
            attach.body = bodyBlob;
            attach.parentId = testRFA.id;
            insert attach;
            
            List<Attachment> attachments=[select id, name from Attachment where parent.id=:testRFA.id];
            //System.assertEquals(1, attachments.size());
    }
    
    static testMethod void myUnitTest1() {
        //RFA__c rfa = RFATestData.buildRFACapital();
        RFA__c rfa = RFATestData.buildRFAGeneral();
        RFA_WS04_PDFGeneratorCM.PDFGenerator(rfa.Id, Userinfo.getSessionId());
    }
}