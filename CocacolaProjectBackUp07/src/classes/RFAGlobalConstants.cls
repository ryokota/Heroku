/****************************************************************************************************************************************
 ****************************************************************************************************************************************    
 *  Class            : RFAGlobalConstants
 *  Author           : Accenture
 *  Version History  : 3.0
 *  Creation         : 05/14/2012
 *  Assumptions      : N/A
 *  Description      : Class for storing global constants which are referrenced in multiple classes.
 *
 *  updated by Jia Hu on 2013/10/29                                    
 ****************************************************************************************************************************************
 ****************************************************************************************************************************************/
/*
Deleted Custom Lable:
NameSorted  Categories	Short Description	Value
RFA_CL002	RFA_VFP01	Business Unit	Business Unit
RFA_CL003	RFA_VFP01	Group	Group	English
RFA_CL004	RFA_VFP01	Corporate	Corporate	English
RFA_CL005	RFA_VFP01	Executive	Executive	English
RFA_CL006	RFA_VFP01	Senior Executive	Senior Executive

RFA_CL091	RFA_C04	RFA_CL091	USD ???

RFA_CL099	RFAGlobalConstants	You can only edit users in Levels below yours for this Profit Center	You can only edit users in Levels below yours for this Profit Center

RFA_CL013	RFA_WS05	Missing Id in request	Id NOT Specified in the Request.
RFA_CL014	RFA_WS03	RfaId or federationID cannot be Null.	RfaId or federationID cannot be Null.	English
RFA_CL015	RFA_WS03, RFA_WS05	Id in request not Matching with SFDC Id	Id Specified in the Request NOT Found in Salesforce

RFA_CL025	RFA_WS03	RFA_CL025	Click here to view the Record in Salesforce

RFA_CL027	 	OK	OK
RFA_CL028	RFA_WS03, RFA_WS04, RFA_WS05	Success	SUCCESS
RFA_CL029	 	Location Coordinator not found.	Location Coordinator not found.
RFA_CL030	RFA_WS04	RFA ID not valid for this workItemID	RFA ID not valid for this workItemID.
RFA_CL031	RFA_WS04, RFA_WS03	UPDATED_NONE	UPDATED_NONE

RFA_Cl032	RFA_WS04	Request was already updated	Request was already updated	English
RFA_CL033	RFA_WS04	Manadatory Input Parameter for Set Recommendation	RFA WorkItem Id, User Id and Recommendation can not be NULL in the Request.	English
RFA_CL034	RFA_WS04, RFA_WS05, RFA_WS03	Error	ERROR	English
RFA_CL036	RFA_WS04	Approval status should be Awaiting approval before setting the recommendation	Approval is No longer Required. RFA is either on Capital Management Hold or Pending Board Review or Returned To Sender or Moved from the Circulation Stage.	English
RFA_CL037	RFA_WS02	No Pending RFA in the system.	No Pending RFA in the system.

RFA_CL042	RFA_WS03	RFA_CL042	No Active Approval Request Exist for the User.

RFA_CL060	RFAUserRoleTrigger	RFA_CL060	Ratification

RFA_CL104	Group Consolidated Plan	RFA CL104	Group Consolidated Capital Plan
RFA_CL105	CAPPr Request	RFA CL105	CAPPr Request

RFA_CL109	RFA_VR04_AREMonthRequired	RFA CL109	Select the A.R.E. Month

RFA_CL115	RFA_VR10_PrimaryDOAMandatory	RFA CL115	Select the Primary DOA Category / Sub Category	English
RFA_CL116	RFA_VR11_DOACategoryUniqueness	RFA CL116	A DOA Category/Sub Category can only be selected once. Cannot select same value for Primary DOA Category/Sub Category and Second DOA Category / Sub Category and Third DOA Category / Sub Category	English
RFA_CL117	RFA_VR12_CapitalDOACategoryRestriction	RFA CL117	Capital Expenditures DOA Category values can only be selected as either Primary DOA Category / Sub Category or Second DOA Category / Sub Category or Third DOA Category / Sub Category field value.


RFA_CL143	RFA_VFP13_New_Approver	Co-Creator	01210000000QsJk

RFA_FR1_78	RFA - Phase2	RFA_FR1.78	Not yet confirmed.
RFA_FR1_86	RFA - Phase2	RFA_FR1.86	Asset Disposal	English

RFA_CL016	Email Template - Route to Local Coordinator for Analysis	RFA CL016	All Approvers have responded to this RFA. Control #
RFA_CL017	Email Template - Route to Local Coordinator for Analysis	RFA CL017	All Approvers have responded to this RFA and waiting for your review
RFA_CL018	Email Template - Route to Local Coordinator for Analysis	RFA CL018	<B>Project Title : </B>	English
RFA_CL019	Email Template - Route to Local Coordinator for Analysis	RFA CL019	<B>Control # : </B>	English
RFA_CL020	Email Template - Route to Local Coordinator for Analysis	RFA CL020	<B> Profit Center : </B>	English
RFA_CL021	Email Template - Route to Local Coordinator for Analysis	RFA CL021	<B> USD Amount : </B>	English
RFA_CL022	Email Template - Route to Local Coordinator for Analysis	RFA CL022	<B> Click link to open the RFA Request Document </B>	English
RFA_CL023	Email Template - Route to Local Coordinator for Analysis	RFA CL023	<p><font color="red"><Strong>Note : THIS IS A SYSTEM GENERATED MESSAGE.</Strong></font>.Please <font color="red"><Strong>DO NOT RESPOND</Strong></font> to this email.</p><BR/>	English
RFA_CL024	Email Template - Route to Local Coordinator for Analysis	RFA CL024	<B> Brief Request Summary </B> :

deleted by Jia Hu on 2013/12/02
RFA_CL001	RFA_VFP01	Key Operations	CCEJ
RFA_CL007	RFA_VFP01, RFA_WS04	Capital Management Hold	Capital Management Hold
RFA_CL008	RFA_VFP01, RFA_WS04	Pending Board Review	Pending Board Review

RFA_CL038	RFA_VFC03, RFAGlobalConstants	RFA CL038	Pre-Circulation
RFA_VFC03,RFAGlobalConstants	RFA CL039	Post-Circulation

RFA_CL057: Unconditionally Approved
RFA_CL058	RFAUserRoleTrigger	RFA_CL058	Conditionally Approved

*/
public with sharing class RFAGlobalConstants {
    
    //Label.RFA_CL070: Additional Years
    //public static final String CASH_SPENT_ADDITIONAL_YEARS = Label.RFA_CL070;
    //RFA_CL061: Approver List is not ordered properly
    public static final String EXCEPTION_LIST_ORDER = Label.RFA_CL061;
    //RFA_CL062: Please add Approvers to the process before submitting it for Approval
    //public static final String EXCEPTION_NO_APPROVERS = Label.RFA_CL062;
    //RFA_CL063: There should be either Approvers OR Reviewers to push the RFA into Circulation
    //public static final String EXCEPTION_NO_APPROVERS_REVIEWERS = Label.RFA_CL063;
    //RFA_CL064: Approver
    //public static final String APPROVER_RECORDTYPE = Label.RFA_CL064;
    
    //removed by Jia Hu on 2013/12/08
    //RFA_CL065: Coordinator  ---> need to remove ??!!   --- ROWCAUSE_LABEL_LC
    //public static final String PC_USERTYPE_LC = Label.RFA_CL065;
    
    //Viewer - All
    //RFAGlobalConstants.PC_USERTYPE_Viewer -> RFAConstants.ProfitCenterUserRole_UserType_Viewer
    //public static final String PC_USERTYPE_Viewer = Label.RFA_CL066;
    //Viewer - Capital Only
    //RFAGlobalConstants.PC_USERTYPE_RFCViewer -> RFAConstants.ProfitCenterUserRole_UserType_Capital
    //public static final String PC_USERTYPE_RFCViewer = Label.RFA_CL067;
    
    //In Progress removed by Jia Hu on 2013/12/08
    //public static final String PROCESS_IN_PROGRESS = Label.RFA_CL068;
    //Completed   removed by Jia Hu on 2013/12/08
    //public static final String PROCESS_COMPLETED = label.RFA_CL069;
    //Awaiting Approval  removed by Jia Hu on 2013/12/08
    //public static final String PROCESS_PENDING_RECOMMENDATION = Label.RFA_CL056; 
    //RFA_CL071: Process has already been submitted for Approval
    
    public static final String EXCEPTION_PROCESSHASBEEN_SUBMITTED = Label.RFA_CL071;
    //RFA_CL072: Info Copy Only
    //public static final String RECORDTYPE_INFOONLY = Label.RFA_CL072;
    
    //RFA_CL073: Co-Creator  --- deleted by Jia Hu on 2013/10/29
    //public static final String RECORDTYPE_CO_CREATOR = Label.RFA_CL073;
    
    //RFA_CL074: Primary Point of Contact
    //public static final String RECORDTYPE_PRIMARY_POC = Label.RFA_CL074;

    //public static final String RECORDTYPE_GENERAL_REQUEST = Label.RFA_CL122; //General Request

	//RFA_CL050: Small Project Request ( 25MM＜≦50MM )
    //public static final String RECORDTYPE_SMALL_PROJECT_REQUEST = Label.RFA_CL050;
    //RFA_CL051: Capital Project Request
    //public static final String RECORDTYPE_CAPITAL_PROJECT_REQUEST = Label.RFA_CL051;
    
    //removed by Jia Hu on 2013/10/31
    //public static final String RECORDTYPE_CAPPR_REQUEST = 'CAPPr Request';
    //public static final String RECORDTYPE_GROUP_CONSOLIDATED_PLAN = 'Group Consolidated Capital Plan';
    
    //need to remove ??!!    --- PC_USERTYPE_LC  removed by Jia Hu on 2013/12/08
    //public static final String ROWCAUSE_LABEL_LC = Label.RFA_CL075; //PCLocationCoordinator


    //public static final String ROWCAUSE_REQUESTER = Label.RFA_CL076; //KORequestor
    //You donot have permission to add users
    //public static final String INSUFFICIENT_PERMISSION = Label.RFA_CL077; 
    
    //removed by Jia Hu on 2013/12/01  --- RFA_AP01_ProfitCenterUserRole.cls
    //You can only edit users in Levels below yours for this Profit Center
    //public static final String INSUFFICIENT_EDIT_PERMISSION = Label.RFA_CL099; 
    //public static final String INSUFFICIENT_EDIT_PERMISSION 
    //	= 'You can only edit users in Levels below yours for this Profit Center'; 
    
    //You have selected a level greater than your assigned level. 
    //Please select a level which is equal to or less than your assigned level
    //public static final String EXCEPTION_HIGHER_LEVEL = Label.RFA_CL078; 
    
    //User is not part of this Profit Center.
    //public static final String EXCEPTION_NOT_PART_OF_PC = Label.RFA_CL079;
    
    //removed by Jia Hu on 2013/12/08
    //public static final String RFA_CIRCULATION_STAGE = Label.RFA_CL041; //Circulation
    
    //removed by Jia Hu on 2013/12/02
    //public static final String RFA_POST_CIRCULATION_STAGE = Label.RFA_CL039; //Post-Circulation   
    //removed by Jia Hu on 2013/12/01
    //public static final String RFA_PRE_CIRCULATION_STAGE = Label.RFA_CL038; //Pre-Circulation
    
    //removed by Jia Hu on 2013/12/08
    //public static final String RETURN_TO_SENDER = Label.RFA_CL040; //Return To Sender
    
    //removed by Jia Hu on 2013/12/02
    //public static final String POST_CIRCULATION = Label.RFA_CL039; //Post-Circulation
    
    //removed by Jia Hu on 2013/12/01
    //public static final String PRE_CIRCULATION = Label.RFA_CL038; //Pre-Circulation
    
    //public static final String PROCESS_NOT_COMPLETED = Label.RFA_CL080; //Not Completed
    
    //public static final String TEMPLATE_PRE_CIRCULATION = Label.RFA_CL044; //00X10000000e7AS
    
    //public static final String TEMPLATE_RETURN_TO_SENDER = Label.RFA_CL049; //00X10000000e7AV
    
    //public static final String TEMPLATE_RFA_RESUMED_FROM_RETURNTOSENDER = Label.RFA_CL093; //00X10000000e7AV
    
    //removed by Jia Hu on  2013/12/01
    //public static final String PENDING_BOARD_REVIEW = Label.RFA_CL008; //Pending Board Review    
    //public static final String CAPITAL_MGMT_HOLD = Label.RFA_CL007; //Capital Management Hold
    
    //public static final String RFA_STAGE_CLOSED = Label.RFA_CL081; //Closed
    
    //public static final String RFA_STAGE_APPROVED = Label.RFA_CL082; //Approved
    
    //public static final String RFA_STAGE_REJECTED = Label.RFa_CL059; //Rejected
    
    //public static final String RFA_STAGE_DRAFT = Label.RFA_CL083; //Draft
    
    //public static final String TCCC_HQ_NAME = Label.RFA_CL084; //Atlanta, Georgia  ???
    
    //removed by Jia Hu on 2013/12/01
    //public static final String SEND_TO_PRE_CIRCULATION = Label.RFA_CL085; //Send to Pre-Circulation
    
    //removed by Jia Hu   Change to: URL.getSalesforceBaseUrl().toExternalForm()
    //public static final String CURRENT_DOMAIN_NAME = Label.RFA_CL026; //https://ap.salesforce.com
    
    public static Map<String, Map<String, RecordType>> RECORDTYPESMAP = 
        RFA_Util_RecordTypeHelper.createRecordTypesMap(
                new String[]{
                        Schema.sObjectType.RFAUserRole__c.getName(), 
                        Schema.Sobjecttype.RFA__c.getName()
                        }, 
                new String[]{
                		RFAConstants.RTLabel_RFAUserRole_Approver,
                        //RFAGlobalConstants.APPROVER_RECORDTYPE,
                        
                        //RFAGlobalConstants.RECORDTYPE_CO_CREATOR,
                        
                        RFAConstants.RTLabel_RFAUserRole_InfoOnly,
                        //RFAGlobalConstants.RECORDTYPE_INFOONLY,
                        
                        RFAConstants.RTLabel_RFAUserRole_PPOC,
                        //RFAGlobalConstants.RECORDTYPE_PRIMARY_POC,
                        
                        RFAConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST,
                        //RFAGlobalConstants.RECORDTYPE_CAPITAL_PROJECT_REQUEST,
                        
                        //RFAGlobalConstants.RECORDTYPE_SMALL_PROJECT_REQUEST,
                        RFAConstants.RECORDTYPE_Medium_PROJECT_REQUEST,
                        
                        //added by Jia Hu on 2013/10/29
                        //RFAConstants.RECORDTYPE_SMALL_PROJECT_REQUEST_LessThan25MM,                        
                        //RFAConstants.RECORDTYPE_SMALL_PROJECT_REQUEST,
                        RFAConstants.RECORDTYPE_SMALL_PROJECT_REQUEST,
                        
                        //RFAGlobalConstants.RECORDTYPE_GENERAL_REQUEST
                        RFAConstants.RECORDTYPE_General_PROJECT_REQUEST,
                        
                        RFAConstants.RECORDTYPE_Travel_Expenses_REQUEST,
                        
                        RFAConstants.RECORDTYPE_Entertainment_REQUEST
                        
                        }
        );
    
    /* removed by Jia Hu on 2013/12/01
	//updated by Jia Hu on 2013/10/31	 
	//from current level to retrive all previous levels   
    public static final Map<Integer, String> ORDERED_LEVEL_MAP = new Map<Integer, String>
    {
        1 => 'CCEJ' //, //1. Key Operations
        //2 => '2. Business Unit',
        //3 => '3. Group',
        //4 => '4. Corporate',
        //5 => '5. Executive',
        //6 => '6. Senior Executive'
     };     
	//updated by Jia Hu on 2013/10/31
    public static final Map<String, Integer> LEVEL_ORDER_MAP = new Map<String, Integer>
    {
        'CCEJ' => 1 //, //1. Key Operations
        //'2. Business Unit' => 2,
        //'3. Group' => 3,
        //'4. Corporate' => 4,
        //'5. Executive' => 5,
        //'6. Senior Executive' => 6
     };*/
    
    /* removed by Jia Hu on 2013/12/01
    public static final Map<String, String> LEVEL_ABBR_MAP = new Map<String, String>
    {
        'CCEJ'     => 'KO' //, //1. Key Operations
        //'2. Business Unit'      => 'BU',
        //'3. Group'              => 'Group',
        //'4. Corporate'          => 'Corporate',
        //'5. Executive'          => 'Exec',
        //'6. Senior Executive'   => 'Sr.Exec'
    };*/
    
    //public static boolean isBlank(String str) 
    //{
    //    return str == null || str.trim() == null || str.trim().length() == 0;
    //}
}