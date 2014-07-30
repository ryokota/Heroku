@isTest
private class Milestone_CokeOne_MatrixReportCtrlTest {
	static testMethod void myUnitTest() {
    	Test.startTest();
    	//Project_Type__c : Key, Integration, Finance Specific, ERP
    	//Sub_Function__c : Controller's Group, BP&A, Commercial Finance, Supply Chain Finance, M&A, Finance Integration, Investor Relations, Internal Audit, Corporate Administrator

        Milestone1_Project__c p1 = new Milestone1_Project__c(Name = 'Project1', Sub_Function__c='Commercial Finance', Project_Type__c='Integration',Function__c='Finance', Project_Status__c='Green', Status__c = 'Active' );
        insert p1;
        List<Milestone1_Milestone__c> mileList = new List<Milestone1_Milestone__c>();
        for(integer i=0; i<10; i++){
        	Milestone1_Milestone__c m = new Milestone1_Milestone__c(Name='Test'+i,
								Deadline__c=System.today(),
								CompletedDate__c=System.today(),
								Project__c = p1.Id, RecordTypeId =system.Label.Milestone_RecordType_CokeOne);
			mileList.add(m);
        }
        insert mileList;
        Milestone_CokeOne_MatrixReportCtrl matrix = new Milestone_CokeOne_MatrixReportCtrl();
        
        //マップキー確認
        system.debug('projectMap : '+matrix.projectMap);
        System.assertEquals(true, matrix.projectMap.containsKey('Project1'));
        System.assertEquals(true, matrix.statusMap.containskey('Green'));
        
        //設定したPickListサイズチェック
        List<SelectOption> statusFilter = matrix.getFilterStatus();
        System.assertEquals(5, statusFilter.size());
        Test.stopTest();
    }
}