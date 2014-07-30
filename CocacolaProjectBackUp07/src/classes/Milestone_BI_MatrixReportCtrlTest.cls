/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Milestone_BI_MatrixReportCtrlTest {

    static testMethod void myUnitTest() {
    	/*
    	List<tutisyo_header__c> header = [select id from tutisyo_header__c limit 1];
		Id headerId = header[0].Id;
		System.debug(headerId);
		PageReference pageRef = Page.SingleTutisyoAddup;
		pageRef.getParameters().put('id',headerId);
		Test.setCurrentPage(pageRef);

		PdfPrintExtension pdf = new PdfPrintExtension();
		pdf.tutisyoPrint();
    	*/
    	Test.startTest();
    	User u = [SELECT Id FROM User limit 1];
    	Milestone1_Project__c insertP = new Milestone1_Project__c(Name='Test', Project_Status__c='Green', Project_Sponsor__c=u.id, Project_Leader__c=u.id);
    	insert insertp;
    	Status_Indicator_Detail__c sid = new Status_Indicator_Detail__c(Name='SID', 
    																	Status_Date__c = system.today(), 
    																	Accomplishments_This_Period__c='ああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいい',
    																	Planned_But_Not_Accomplished__c='ああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいい',
    																	Planned_For_The_Next_Period__c='ああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいいああああああああああああああああああああいいいいいいいいいいいいいいいいいいいい',
    																	Project__c = insertp.Id);
        
        insert sid;
        List<Milestone1_Milestone__c> mileList = new List<Milestone1_Milestone__c>();
        for(integer i=0; i<10; i++){
        	Milestone1_Milestone__c m = new Milestone1_Milestone__c(Name='Test'+i,
								Deadline__c=System.today(),
								CompletedDate__c=System.today(),
								Project__c = insertP.Id);
			mileList.add(m);
        }
        insert mileList;
		
		PageReference pageRef = Page.Milestone_BI_MatrixReport;
		pageRef.getParameters().put('Id',sid.Id);
		Test.setCurrentPage(pageRef);  
		Milestone_BI_MatrixReportCtrl bi = new Milestone_BI_MatrixReportCtrl();
		Test.stopTest();      
        // TO DO: implement unit test
    }
}