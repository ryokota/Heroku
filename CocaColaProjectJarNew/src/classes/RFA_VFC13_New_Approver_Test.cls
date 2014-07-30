/**
	updated by Jia Hu on 2013/11/08
 */
@isTest(SeeAllData=false) 
private class RFA_VFC13_New_Approver_Test {

    static testMethod void myUnitTest() {
    	/*
        // TO DO: implement unit test
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        RFATestData rtTest = new RFATestData();
         rtTest.buildProfitCenter();
        
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        testRFA.Stage__c = 'Draft';
        insert testRFA;
        
        
        string profile = RFAConstants.getRFAStandardUserProfileId();
        RFATestData RTData = new RFATestData();
        User grUser = new User();
        grUser = RTData.createUser(profile, 'TestUser', 'grlastt', grUser);

        User grUser2 = new User();
        grUser2 = RTData.createUser(profile, 'TUser2', 'grlas2', grUser2);
                
        RFAUserRole__c testRFARole = new RFAUserRole__c();
        testRFARole.UserName__c = grUser.Id;
        testRFARole.RFA__c = testRFA.ID;
        
        //testRFARole.Level__c = 'CCEJ'; //1. Key Operations
        insert testRFARole;
        */
        
        //RFA__c testRFA = RFATestData.buildRFACapital();
        RFA__c testRFA = RFATestData.buildRFAGeneral();
        RFAUserRole__c testRFARole = [Select Id, UserName__c, RFA__c 
        	from RFAUserRole__c where RFA__c =: testRFA.ID limit 1];

        PageReference pageRef = Page.RFA_VFP13_New_Approver;
        Test.setCurrentPage(pageRef); 
        System.currentPageReference().getParameters().put('id', testRFARole.id); 
        ApexPages.Standardcontroller stdController1 = new ApexPages.Standardcontroller(testRFARole);
        RFA_VFC13_New_Approver controller1 = new RFA_VFC13_New_Approver(stdController1); 
            
           //controller1.rfaUserObj.UserName__c = grUser2.Id;
           controller1.doSaveAndNew();
       
        PageReference pageRef1 = Page.RFA_VFP13_New_Approver;
        Test.setCurrentPage(pageRef1);     
        ApexPages.Standardcontroller stdController2 = new ApexPages.Standardcontroller(testRFARole);
        RFA_VFC13_New_Approver controller2 = new RFA_VFC13_New_Approver(stdController2); 

    }
    
    /*
     static testMethod void myUnitTest2() {
        // TO DO: implement unit test
 
        RFA__c testRFA = new RFA__c();
        testRFA.ProfitCenterNumber__c = RFATestData.testProfitCenter.Id;
        RFATestData rtTest = new RFATestData();
         rtTest.buildProfitCenter();
        
        testRFA.RequestTitle__c = 'Capital Project Request RFA Title';
        testRFA.Stage__c = 'Draft';
        insert testRFA;
        
        
        string profile = RFAConstants.getRFAStandardUserProfileId();
        RFATestData RTData = new RFATestData();
        User grUser = new User();
        grUser = RTData.createUser(profile, 'TestUser', 'grlastt', grUser);

        User grUser2 = new User();
        grUser2 = RTData.createUser(profile, 'TUser2', 'grlas2', grUser2);
                
        RFAUserRole__c testRFARole = new RFAUserRole__c();
        testRFARole.UserName__c = grUser.Id;
        testRFARole.RFA__c = testRFA.ID;
        
        //testRFARole.Level__c = 'CCEJ'; //1. Key Operations
        insert testRFARole;

       

        PageReference pageRef = Page.RFA_VFP13_New_Approver;
        Test.setCurrentPage(pageRef); 
        System.currentPageReference().getParameters().put('id', testRFARole.id); 
        ApexPages.Standardcontroller stdController1 = new ApexPages.Standardcontroller(testRFARole);
        RFA_VFC13_New_Approver controller1 = new RFA_VFC13_New_Approver(stdController1); 
            
           controller1.rfaUserObj.UserName__c = grUser2.Id;
           controller1.doSave();
           
        PageReference pageRef1 = Page.RFA_VFP13_New_Approver;
        Test.setCurrentPage(pageRef1);     
        ApexPages.Standardcontroller stdController2 = new ApexPages.Standardcontroller(testRFARole);
        RFA_VFC13_New_Approver controller2 = new RFA_VFC13_New_Approver(stdController2); 

    }
    */
}