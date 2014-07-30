/*  
 *  Class            : RFAConstants
 *  Author           : Pasona-Tquila
 *  Version History  : 1.0
 *  Creation         : 2013/10/25
 *  Assumptions      : N/A
 *  Description      : Class for storing constants used in RFA.                                  
 */
public with sharing class RFAConstants {

	/*
		Custom Button Label
	*/    
	public static final String Button_Send_To_Circulation = 'Send to Circulation'; 
	public static final String Button_Approval_Recommend = 'Submit Approval Recommendation';
	public static final String Button_Show_Approver = 'Show Approvers';
	public static final String Button_Close_RFA = 'Close RFA';
	//public static final String Button_Return_To_Requester = 'Return to Requester';
	
    /*
        RFA Object (API: RFA__c)
    */
    
    //previous name is Stage; Label: Status / API: Stage__c (Picklist)   
    public static final String RFA_STATUS_DRAFT = 'Draft'; 
    public static final String RFA_STATUS_ReturnToRequester = 'Return to Requester';   
     
    public static final String RFA_STATUS_CIRCULATION = 'Circulation'; 
    
    public static final String RFA_STATUS_APPROVED = 'Approved';  
    public static final String RFA_STATUS_REJECTED = 'Rejected';          
    public static final String RFA_STATUS_CLOSED = 'Closed';
    
       
    //RFA Record Type Value   //'Small Project Request ( < 25MM )';
    //Small Project Request B -> Small Project Request  by Jia Hu on 2013/12/02
    //RECORDTYPE_SMALL_PROJECT_REQUEST_LessThan25MM -> RECORDTYPE_SMALL_PROJECT_REQUEST
    public static final String RECORDTYPE_SMALL_PROJECT_REQUEST = 'Small Project Request'; 
    //Small Project Request A -> Medium Project Request
    //RECORDTYPE_SMALL_PROJECT_REQUEST_A -> RECORDTYPE_Medium_PROJECT_REQUEST
    public static final String RECORDTYPE_Medium_PROJECT_REQUEST = 'Medium Project Request';   
    public static final String RECORDTYPE_CAPITAL_PROJECT_REQUEST = 'Capital Project Request';
    public static final String RECORDTYPE_General_PROJECT_REQUEST = 'General Request';
    public static final String RECORDTYPE_Travel_Expenses_REQUEST = 'Travel Expenses Request';
    public static final String RECORDTYPE_Entertainment_REQUEST = 'Entertainment Request';
 
    //Apex Sharing Reasons
    public static final String RowCause_Requestor = 'KORequestor__c'; //Label.RFA_CL076; //KORequestor
    public static final String RowCause_Approver = 'Approver__c';
    public static final String RowCause_PCReviewer = 'PCReviewer__c';
    public static final String RowCause_Reviewer = 'Reviewer__c';
    
    
    
    /*
        error msg of RFA object
    */
    //PrimaryCOACategory__c
    public static final String Primary_COA_Category_MandatoryMsg 
        = 'Select the Primary COA Category';
    

    /*
        RFA Approver/User Object (API: RFAUserRole__c)
    */
    public static final String Obj_RFAUserRole_APIName = 'RFAUserRole__c'; 
    
    public static final String RTLabel_RFAUserRole_Approver = 'Approver'; 
    public static final String RTLabel_RFAUserRole_PPOC = 'Primary Point of Contact'; 
    public static final String RTLabel_RFAUserRole_InfoOnly = 'Info Copy Only'; 
    
    //Approval Recommendation (API: ApprovalRecommendation__c):Picklist
    public static final String ApproverRecommend_UnconditionalApproved = 'Unconditionally Approved / 承認（条件なし）'; 
    //public static final String ApproverRecommend_UnconditionalApproved_JP = '承認（条件なし）';
    public static final String ApproverRecommend_ConditionalApproved = 'Conditionally Approved / 承認（条件付き）'; 
    //public static final String ApproverRecommend_ConditionalApproved_JP = '承認（条件付き）';
    public static final String ApproverRecommend_Rejected = 'Rejected / 否認'; 
    //public static final String ApproverRecommend_Rejected_JP = '否認';
    public static final String ApproverRecommend_AwaitingApproval = 'Awaiting Approval / 承認待ち'; 
    //public static final String ApproverRecommend_AwaitingApproval_JP = '承認待ち';
    public static final String ApproverRecommend_ReturnToRequester = 'Return to Requester / 差し戻し'; 
    
	public static final String Approver_Source_COA = 'COA'; 
	public static final String Approver_Source_COA_Group = 'COA Group'; 
	public static final String Approver_Source_COA_Single = 'COA Single'; 
    public static final String Approver_Source_Manager = 'Manager'; 
    public static final String Approver_Source_CokeOneManager = 'CokeOne Manager'; 
    public static final String Approver_Source_Approver = 'Approver'; 
    public static final String Approver_Source_Requester = 'Requester'; 
    public static final String Approver_Source_CapitalMgmt = 'Capital Mgmt.';      
    public static final String Approver_Source_TreasuryMgr = 'Treasury Mgr'; 
    public static final String Approver_Source_FixAssetMgr = 'Fix Asset Mgr'; 
	public static final String Approver_Source_ELT = 'ELT'; 
	public static final String Approver_Source_InfoCopy = 'Info Copy';     
	public static final String Approver_Source_InfoCopy_Manager = 'Info Copy - Manager';     
	public static final String Approver_Source_CokeOne_ProjectFinance = 'CokeOne';
    
    /*
        Approval Process Object (API: ApprovalProcess__c)
    */    
    public static final String ApprovalProcess_Not_Started = 'Not Started'; 
    public static final String ApprovalProcess_In_Progress = 'In Progress';
    public static final String ApprovalProcess_Completed = 'Completed';
    public static final String ApprovalProcess_Not_Completed = 'Not Completed';
    
    /*
        COA Object (API: COA__c)
    */      
    public static final String Threshold_Type_All = 'All'; 
    public static final String Threshold_Type_Value = 'Value'; 
    public static final String Threshold_Type_ValueWithRT = 'Value with Record Type'; 
    public static final String Threshold_Type_Budgeted = 'Budgeted'; 
    
    public static final String Group1 = 'Gr.1'; 
    public static final String Group2 = 'Gr.2'; 
    public static final String Group3 = 'Gr.3'; 
    public static final String Group4 = 'Gr.4'; 
    public static final String Group5 = 'Gr.5'; 
    public static final String Group6 = 'Gr.6'; 
    public static final String Group7 = 'Gr.7'; 
    
    /*
        Profit Center Object (API: ProfitCenter__c)
    */  
    //Profit Center Name  API: ProfitCenterName__c / Text(100)
    
    public static final String ProfitCenter_Name_CCEJ = 'CCEJ'; 
    
    /*
        Profit Center User Role Object (API: ProfitCenterUserRole__c)
    */
    //User Type (UserType__c)
    //public static final String ProfitCenterUserRole_UserType_Coordinator = 'Coordinator';   
    public static final String ProfitCenterUserRole_UserType_Viewer = 'Viewer - All';   
    public static final String ProfitCenterUserRole_UserType_Capital = 'Viewer - Capital Only';     

    
    
    /*
        Cost Center Object (API: Cost_Center__c)
    */
    //Field Lable: Cost Center Number
    public static final String CostCenter_Name = '0001';    
    
    /*
        Old: RFA_TaxRate Object (API: RFA_TaxRate__c)
        New: Financial Constant (API: Financial_Constant__c)
        
    */
    //Field Lable: RFA_TaxRate Name 
    //public static final String TaxRate_Name = '0001';     
    
    public static final String FinancialConstant_RT_TaxRate = 'Tax Rate';
    public static final String FinancialConstant_RT_WACC = 'WACC';
    
    /*
        Related Document
    */
    public static final String Doc_Name_Investment_Category = 'Investment_Objective_Definition';        
    public static final String Doc_Name_Asset_Category = 'Asset_Category_Definition';
    
    
    /*
        =====================
            Config
        =====================
    */
    /*
        User Object
    */      
    public static final String SysAdminProfile  = 'System Administrator';
    public static final String SysAdminJPProfile  = 'システム管理者';
    
    public static final String RFASysAdminProfile = 'RFA - System Administrator';
    
    public static final String RFACapitalMgmtProfile = 'RFA - Capital Management Admin';
    public static final String RFAStandardProfile = 'RFA - Standard User';
    
    public static final String RFA_System_User = 'RFA System';
    
    public static Id getOrgWideEmailAddressId() {
    	OrgWideEmailAddress[] owea = [select Id, IsAllowAllProfiles, DisplayName 
    		from OrgWideEmailAddress where DisplayName =: RFA_System_User];
		system.debug('------ OrgWideEmailAddress[]: ' + owea);
		if(owea != null && owea.size() > 0) {
			return owea[0].Id;
		}
		return null;
    }
  
    public static boolean isRFAAdmin(String strProfileName)
    {       
        if(
        	strProfileName == SysAdminProfile || // System Administrator
        	strProfileName == SysAdminJPProfile  || //for Japanese
            strProfileName == RFASysAdminProfile // RFA - System Administrator           
          )
        { 
        	return true; // user is a RFA system admin         	
        }         
        return false;
    }    
    
    public static boolean evaluateIfAdmin(Id profileId)
    {
         boolean check = false;
         for(Profile profile : [
         	Select Id From Profile 
         		Where Name =: RFASysAdminProfile //'RFA - System Administrator' 
         			//OR Name = 'RFA - Capital Management Admin' 
         			OR Name =: SysAdminProfile //'System Administrator' 
         			OR Name =: SysAdminJPProfile //'システム管理者' 
         			])
         {
             if(
             	//UserInfo.getProfileId() 
             	profileId == profile.Id) {
                check = true;
             }	
         }
         return check;
    }    
    
    public static Id getRFAStandardUserProfileId()
    {
        return [Select Id, Name FROM Profile where Name =: RFAStandardProfile LIMIT 1].Id;
    }   
    
    
    public static Id getRFACapitalMgmtProfileId()
    {
        return [Select Id, Name FROM Profile where Name =: RFACapitalMgmtProfile LIMIT 1].Id;
    }       
    
    /*
        RecordType Object: using label not API name
        Id approverRTId = RFAConstants.getRecordType('Approver', 'RFAUserRole__c');
        Record Type Label:  Approver
        Record Type Name:   RUR_Approver
    */  
    public static Id getRecordType(String pName, String sObjectType)
    {
        system.debug('------- getRecordType() RT Name: ' + pName + ' Object: ' + sObjectType);
        return [Select Id, Name FROM RecordType Where SObjectType =: sObjectType AND Name =: pName].Id;
    }   
    
    public static boolean isBlank(String str) 
    {
        return str == null || str.trim() == null || str.trim().length() == 0;
    }    
    
}