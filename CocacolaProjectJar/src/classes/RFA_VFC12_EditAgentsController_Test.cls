/**
	updated by Jia Hu on 2013/11/12
 */
@isTest(SeeAllData=false) 
private class RFA_VFC12_EditAgentsController_Test {

    /*
     * Scenario 1: Test updating Agents as a user which is not a location coordinator (error output)
     * Scenario 2: Test updating Agents as a user which is a location coordinator
     * Scenario 3: Test as Admin, assign user as agent (error output)
     * Scenario 4: Test as Admin, set required field, email address, to null to invoke an error (error output)
    */ 
    static testMethod void myUnitTest1() 
    { 
        string profile = RFAConstants.getRFAStandardUserProfileId();
        RFATestData RTData = new RFATestData();
        
        //RTData.buildProfitCenter();
        RFA__c testRFA = RFATestData.buildRFACapital();
        
        // Obtain a Location Coordinator
        ProfitCenterUserRole__c profitCenterUser = [
        	Select UserName__c From ProfitCenterUserRole__c 
        	where ProfitCenter__c = :RFATestData.testProfitCenter.id LIMIT 1];
        	
        User lcUser;
        
        if (profitCenterUser != null)
            lcUser = new User(id = profitCenterUser.UserName__c);
        
        User notLCUser = RTData.createUser(profile, 'NotLCUsr', 'NotLCUser');
        
        User grUser = RTData.createUser(profile, 'TestUser', 'grlastt');
        
        PageReference pageRef = Page.RFA_RF1_22_EditAgents;
        Test.setCurrentPage(pageRef); 
        System.currentPageReference().getParameters().put('id', grUser.id); 
        ApexPages.Standardcontroller stdController1 = new ApexPages.Standardcontroller(grUser);
        RFA_VFC12_EditAgentsController controller1 = new RFA_VFC12_EditAgentsController(stdController1); 
        
        // Test as a user which is not a Location Coordinator
        System.runAs(notLCUser)
        {
            controller1.userobj.RFA_Agent_1__c = notLCUser.id;
            controller1.updateUserAgents();
        }
        
        // Test as Location Coordinator
        /*
        if (lcUser != null)
        {
            // Reset pcAssociatedUsers static list variable on the RFA_WS07_CheckRFAUser class
            RFA_WS07_CheckRFAUser.pcAssociatedUsers = null;
            
            System.runAs(lcUser)
            {
                controller1.userobj.RFA_Agent_1__c = lcUser.id;
                controller1.updateUserAgents();
            }
        }*/
        
        // Test Failed Scenarios
        controller1.userobj.RFA_Agent_1__c = grUser.Id;
        controller1.updateUserAgents();
        
        controller1.userobj.RFA_Agent_1__c = null;
        controller1.userobj.email = null;
        controller1.updateUserAgents();
    }
    
}