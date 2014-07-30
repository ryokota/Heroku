@isTest(SeeAllData=false) 
public with sharing class RFATestLogic {
	
	//RFA_Util_PerformDML
	static testMethod void unitTest_RFA_Util_PerformDML() {
		
		List<SObject> objectsForUpdlist = new List<SObject>();
		RFA__c rfa = RFATestData.buildRFAGeneral();
		objectsForUpdlist.add(rfa);
		
		try {
			RFA_Util_PerformDML.performUpdOperation(objectsForUpdlist);
		} catch(Exception ex) {
			system.debug('------ Exception: ' + ex);
		}
		
		try {
			RFA_Util_PerformDML.performUpsOperation(objectsForUpdlist);
		} catch(Exception ex) {
			system.debug('------ Exception: ' + ex);
		}		
		
		Attachment attach = new Attachment();
        Blob body = Blob.valueOf('Some Text');
        attach.Body = body;
        // add the user entered name
        attach.Name = 'RFA_Attachment.pdf';
        attach.IsPrivate = false;
        attach.ParentId = rfa.Id;
               
        List<SObject> objectsInsList = new List<SObject>();     
		objectsInsList.add(attach);
		try {
			RFA_Util_PerformDML.performInsOperation(objectsForUpdlist);
		} catch(Exception ex) {
			system.debug('------ Exception: ' + ex);
		}	
		
		try {
			RFA_Util_PerformDML.performDelOperation(objectsForUpdlist);
		} catch(Exception ex) {
			system.debug('------ Exception: ' + ex);
		}			
		
	}
	
	static testMethod void unitTest_RFA_Util_ObjectQuery() {
		RFATestData inst = new RFATestData();
		RFA__c rfa = RFATestData.buildRFAGeneral();
		Attachment attach = inst.buildAttachment(rfa.Id);
		
		RFA_Util_ObjectQuery inst1 = new RFA_Util_ObjectQuery();
		inst1.getAttachment(attach.Id);
		 
	}

    private static testMethod void testPageButton() { 
        RFA_AP07_PageButtonWrapper inst 
            = new RFA_AP07_PageButtonWrapper('buttonlabel', 'target', true, true );
    }	
    
    private static testMethod void testPageAction() {     
        RFA__c rfa = RFATestData.buildRFAGeneral();
        RFA_AP17_RemoteActionController inst = new RFA_AP17_RemoteActionController();
        RFA_AP17_RemoteActionController.ErrorDisplay inst1 
            = new RFA_AP17_RemoteActionController.ErrorDisplay('errorDetail', 'componentLabel', 'summary');
    
        RFA_AP17_RemoteActionController.performAction(rfa.Id, RFAConstants.RFA_STATUS_ReturnToRequester
        	//RFAGlobalConstants.RETURN_TO_SENDER
        );
        RFA_AP17_RemoteActionController.performAction(
        	rfa.Id, 
        	RFAConstants.RFA_STATUS_CIRCULATION
        	//RFAGlobalConstants.RFA_CIRCULATION_STAGE
        	);
    }    
    
    private static testMethod void testEmail() { 
    	//RFA__c rfa = [Select Id, Name, RequestTitle__c, createdbyid, createdby.Name from RFA__c where id = 'a0TO0000000yUzW'];
		//RFA_VFC04_CompletionOfRFA inst = new RFA_VFC04_CompletionOfRFA();
		//inst.sendEmail_CompleteMemo(rfa);
    }
    

}