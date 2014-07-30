@isTest(SeeAllData=true) 
public with sharing class RFATestData_Capital {
	
	//static testmethod void RFA_Test_Capital_1(){
	//	RFATestData.buildRFACapital();
	//}
	
	public static RFA__c getDraftRFAwithApprover() {
		RFA__c rfawithApp;
		
		Id generalRFAId = RFAConstants.getRecordType('General Request', 'RFA__c');
		Id approverRTId = RFAConstants.getRecordType('Approver', 'RFAUserRole__c');
		

		for(RFA__c rfa : [Select Id, Stage__c, RequestTitle__c, 
			ReturnReason__c, RequestAmountFunctionalCurrency__c,
			(Select Id from RFA_User_Roles__r where RecordTypeId =: approverRTId) 
			from RFA__c 
			where Stage__c =: RFAConstants.RFA_STATUS_DRAFT //AND RequestTitle__c = 'test_class_data'
			AND RecordTypeId =: generalRFAId
			order by CreatedDate Desc
			limit 1
			]
		) {
			
			List<RFAUserRole__c> approverList = rfa.RFA_User_Roles__r;
			if(approverList != null && approverList.size() > 0) {
				return rfa;
			}				
		}
			
		return rfawithApp;	
		
	}
	
	static testmethod void RFA_Test_General_1(){
		
		/*
		RFA__c rfa = [Select Id, Stage__c, RequestTitle__c, 
			ReturnReason__c, RequestAmountFunctionalCurrency__c 
			from RFA__c 
			where Stage__c =: RFAConstants.RFA_STATUS_DRAFT //AND RequestTitle__c = 'test_class_data'
			order by CreatedDate Desc
			limit 1
			];*/
		
		RFA__c rfa = getDraftRFAwithApprover();
		
		if(rfa != null) {
		rfa.Stage__c = RFAConstants.RFA_STATUS_CIRCULATION;
		update rfa;
		
		rfa.Stage__c = RFAConstants.RFA_STATUS_ReturnToRequester;
		rfa.ReturnReason__c = 'Return Reason';
		update rfa;
		
		rfa.Stage__c = RFAConstants.RFA_STATUS_CIRCULATION;
		update rfa;
		}
	
	}	
	
	static testmethod void RFA_Test_General_2(){
		
		RFA__c rfa = getDraftRFAwithApprover();
		
		if(rfa != null) {
		rfa.Stage__c = RFAConstants.RFA_STATUS_CIRCULATION;
		update rfa;
		
		List<RFAUserRole__c> approvers = [
			Select Id, ApprovalComments__c, ApprovalRecommendation__c from RFAUserRole__c 
			where RFA__c =: rfa.Id And ApprovalRecommendation__c = : RFAConstants.ApproverRecommend_AwaitingApproval
		];
		
		for(RFAUserRole__c approver : approvers) {
			approver.ApprovalComments__c = 'Conditional Approved';
			approver.ApprovalRecommendation__c = RFAConstants.ApproverRecommend_ConditionalApproved;
			
		}		
		
		if(approvers != null && approvers.size() > 0) {
			update approvers;
		}
			
		}
	}		
	
	static testmethod void RFA_Test_General_3(){
		
		RFA__c rfa = getDraftRFAwithApprover();
		
		if(rfa != null) {
		rfa.Stage__c = RFAConstants.RFA_STATUS_CIRCULATION;
		update rfa;
		
		List<RFAUserRole__c> approvers = [
			Select Id, ApprovalComments__c, ApprovalRecommendation__c from RFAUserRole__c 
			where RFA__c =: rfa.Id And ApprovalRecommendation__c = : RFAConstants.ApproverRecommend_AwaitingApproval
		];
		
		if(approvers != null && approvers.size() > 0) {
			approvers[0].ApprovalComments__c  = 'ReturnToRequester';
			approvers[0].ApprovalRecommendation__c = RFAConstants.ApproverRecommend_ReturnToRequester;
			update approvers[0];
		}
		
		}
		
	}		
	
	static testmethod void RFA_Test_General_4(){
		
		RFA__c rfa = getDraftRFAwithApprover();
		
		if(rfa != null) {
		rfa.Stage__c = RFAConstants.RFA_STATUS_CIRCULATION;
		update rfa;
		
		List<RFAUserRole__c> approvers = [
			Select Id, ApprovalComments__c, ApprovalRecommendation__c from RFAUserRole__c 
			where RFA__c =: rfa.Id And ApprovalRecommendation__c = : RFAConstants.ApproverRecommend_AwaitingApproval
		];
		
		if(approvers != null && approvers.size() > 0) {
			approvers[0].ApprovalComments__c  = ';';
			approvers[0].ApprovalRecommendation__c = RFAConstants.ApproverRecommend_Rejected;
			update approvers[0];
		}
		
		}
		
	}		
	
	
	static testmethod void RFA_Test_Temp(){
		RFATestDataTemp.Method1();
		RFATestDataTemp.Method2();
		RFATestDataTemp.Method3();
		RFATestDataTemp.Method4();
		RFATestDataTemp.Method5();
		RFATestDataTemp.Method6();
		RFATestDataTemp.Method7();
		RFATestDataTemp.Method8();
		RFATestDataTemp.Method9();
		RFATestDataTemp.Method10();
		RFATestDataTemp.Method11();
	}
	static testmethod void RFA_Test_Temp2(){
		RFATestDataTemp.Method12();
		RFATestDataTemp.Method13();
		RFATestDataTemp.Method14();
	}	
	
	static testmethod void RFA_Test_Temp3(){
		RFATestDataTemp.Method21();
		RFATestDataTemp.Method22();
		RFATestDataTemp.Method23();
		RFATestDataTemp.Method24();
		RFATestDataTemp.Method25();
		RFATestDataTemp.Method26();
		RFATestDataTemp.Method27();
		RFATestDataTemp.Method28();
		RFATestDataTemp.Method29();
		RFATestDataTemp.Method30();
		RFATestDataTemp.Method31();
	}	
	
	static testmethod void RFA_Test_Temp4(){
		RFATestDataTemp.Method32();
		RFATestDataTemp.Method33();
		RFATestDataTemp.Method34();
	}			

}